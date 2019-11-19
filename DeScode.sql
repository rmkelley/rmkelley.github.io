
update planet_osm_line set width = replace(width, 'O', '0');

update planet_osm_line set width = trim(width, ' Mmetrs');

ALTER TABLE planet_osm_line ADD COLUMN nwidth float;

UPDATE planet_osm_line SET nwidth = CAST(width AS float) WHERE highway IS NOT NULL;

create table st_transform(geom, "4326")::geometry("4326", 'multipolygon') home as
SELECT building, amenity FROM planet_osm_polygon WHERE building = 'yes' AND amenity IS NULL OR building = 'residential';

select populate_geometry_columns();

UPDATE planet_osm_line SET nwidth = 0 WHERE highway IS NOT NULL AND nwidth is null;

ALTER TABLE planet_osm_line ADD COLUMN distinction integer;

UPDATE planet_osm_line SET distinction = 1 WHERE highway = 'trunk' or highway = 'trunk_link' or highway = 'primary' or highway = 'primary_link';

UPDATE planet_osm_line SET distinction = 0 WHERE  highway = 'yes'  OR highway =  'unclassified' OR  highway  =  'bridleway' OR  highway = 'construction' OR  highway = 'cycleway' OR highway = 'footway' OR  highway = 'path' OR highway = 'pedestrian' OR highway = 'residential' Or highway=  'road'  OR highway = 'secondary' OR highway = 'secondary_link' OR  highway = 'service' OR  highway = 'steps' OR highway = 'tertiary' Or highway = 'tertiary_link' OR highway = 'track'; 

CREATE TABLE buffer7 as
SELECT nwidth, distinction

CASE
WHEN distinction = 1 then ST_Buffer(Geography(way), 18+nwidth/2, 'endcap=round')
when distinction = 0 then ST_Buffer(Geography(way), 5+nwidth/2, 'endcap=round')
end  as link

FROM planet_osm_line 
WHERE highway is not null;

ALTER table home ADD COLUMN linkage float;

update buffer7 set geom = link::geometry('polygon', 4326);

UPDATE home set linkage = distinction FROM buffer7 WHERE st_intersects(way, geom);

ALTER table home ADD COLUMN subward integer;

UPDATE home
SET subward = fid
FROM subwardra
WHERE ST_Intersects(way, ST_makeValid(geom)) ;

ALTER table home add column access integer;

create table acc as 
 select subward, count(access) as acY from home
 WHERE access = 1
 group by subward;
 
 create table total as 
 select subward, count(access) as acY from home
 group by subward;

update subwardra 
set allhomes2 = acT FROM acc WHERE acc.subward = subwardra.fid;

alter table subwardra add column sherlockhomes2 float;

update subwardra 
set sherlockhomes2 = acY FROM total WHERE total.subward = subwardra.fid;

alter table home add column pctaccess float;

update subwardra
set pctaccess = (sherlockhomes/allhomes *100);

create table health as
SELECT building, amenity, way FROM planet_osm_polygon
where building = 'hospital' or amenity = 'hospital' or amenity = 'doctors' or building = 'doctors'

