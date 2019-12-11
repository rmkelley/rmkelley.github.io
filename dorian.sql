--Notated by Robert Kelley

--This gives november a geometry.
select addgeometrycolumn('november', 'geom', 102004, 'point',2);
UPDATE november
SET geom = st_transform(st_setsrid(st_makepoint(lng,lat),4326), 102004)

--This changes the geometry to 102004
UPDATE counties
SET geometry = st_transform(geometry,102004);
SELECT populate_geometry_columns('counties'::regclass);

--This deletes the counties in states that were not impacted by Dorian.
DELETE FROM counties
WHERE "STATEFP" NOT IN ('54', '51', '50', '47', '45', '44', '42', '39', '37',
'36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
'13', '12', '11', '10', '09', '05', '01');

--This adds a column for geoid to november.
ALTER TABLE november ADD COLUMN geoid varchar(5);

--This connects each tweet to its county.
update november
set geoid = counties."GEOID"
from counties
where st_intersects(november.geom, counties.geometry)

--This adds a column for geoid to dorian.
ALTER TABLE november ADD COLUMN geoid varchar(5);

--This connects each tweet to its county.
update dorian
set geoid = counties."GEOID"
from counties
where st_intersects(november.geom, counties.geometry)

--This adds a column to Dorian that is its total tweets.
ALTER TABLE dorian ADD COLUMN dortweet integer;
select count(status_id) as dortweet ,geoid
FROM dorian
GROUP BY geoid is not null

--This adds a column to November that is its total tweets.
ALTER TABLE november ADD COLUMN novtweet integer;
select count(status_id) as novtweet, geoid
FROM november
GROUP BY geoid

--This adds a column to my counties that is equal to the total november tweets, separated by county.
ALTER TABLE counties ADD COLUMN novcount integer;
update counties 
set novcount= a
from (select count(status_id) as a, geoid
from november where geoid is not null 
group by geoid) as nc
where counties."GEOID" = nc.geoid

--This adds a column to my counties that is equal to the total november tweets, separated by county.
ALTER TABLE counties ADD COLUMN dorcount integer;
update counties 
set dorcount= a
from (select count(status_id) as a, geoid
from dorian where geoid is not null 
group by geoid) as nc
where counties."GEOID" = nc.geoid

--This normalizes the dorian tweets by population (for every 10,000 people).
ALTER TABLE counties ADD COLUMN normaldor real;
update counties 
set normaldor= dorcount/("POP"/10000)

--This changes null values to 0 in novcount.
update counties 
set novcount = 0
where novcount is null

--This creates the ntdi in counties where there were tweets in either dataset.
ALTER TABLE counties ADD COLUMN ntdi real;
update counties 
set ntdi= (dorcount-novcount)/((dorcount+novcount)*1.0)
where (dorcount+novcount)>0

--Makes ntdi have 0s instead of nulls so there are no null values in the dataset.
update counties 
set ntdi = 0
where ntdi is null
