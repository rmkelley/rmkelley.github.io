# Twitter and SharpieGate

Click [here](index.md) to return to the main page.

## Introduction

Over the past several years, big data has taken the world by storm. Whether it is 

![trump](sharpie.jpg)

### Data and code

An important note about twitter data is that users are more likely to be technologically competant, younger, and able to afford a mobile or web connected device. When thinking about who is in the most danger from extreme events or other disasters, it is not people who have the means or capacity to act for themselves who are at risk.

[Dorian tweet status ids](dorianScrub.csv)

[November tweet status ids](novemberScrub.csv)

[R code for text anaylsis and data creation](twitterForLab.r)

[This SQL code](dorian.sql) was used in PostGIS for QGIS analysis.

### Methods

'''sql
--This gives november a geometry.
select addgeometrycolumn('november', 'geom', 102004, 'point',2);
UPDATE november
SET geom = st_transform(st_setsrid(st_makepoint(lng,lat),4326), 102004)

--This changes the geometry to 102004
UPDATE counties
SET geometry = st_transform(geometry,102004);
SELECT populate_geometry_columns('counties'::regclass);

--This deletes the counties in states that were not imacted by Dorian.
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

--This adds a column to Novemebr that is its total tweets.
ALTER TABLE november ADD COLUMN novtweet integer;
select count(status_id) as novtweet, geoid
FROM november
GROUP BY geoid

--This adds a column to my counties that is equal to the total november tweets, seperated by county.
ALTER TABLE counties ADD COLUMN novcount integer;
update counties 
set novcount= a
from (select count(status_id) as a, geoid
from november where geoid is not null 
group by geoid) as nc
where counties."GEOID" = nc.geoid

--This adds a column to my counties that is equal to the total november tweets, seperated by county.
ALTER TABLE counties ADD COLUMN dorcount integer;
update counties 
set dorcount= a
from (select count(status_id) as a, geoid
from dorian where geoid is not null 
group by geoid) as nc
where counties."GEOID" = nc.geoid

--This normalizes the dorian tweets by poulation (for every 10,000 people).
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
'''sql

### Results

![freqword](dorword.png)

![netword](dornet.png)

![where](dortweetlocals.PNG)

![yes_no](occurnce_map.PNG)	
![sig](significance_map.PNG)
![Q](base_heat.png) 

### Conclution

What is facinating about this lab is that anyone with the technelogical know-how could have developed this problem and executed it. All of the data was available, and as far as open source software goes, RStudio and QGIS are relativly accessable. This brings up the question of what can research look like in this modern age of big data? 

Each individual in this class found and contributed an article to a literature on twitter-based research, and a large proportion of the articles sourced were inductive- i.e. they took data, began working with it, and then figured out what stuck. Twitter has a history of inspiring and enabling such research because of the sheer amount of data available to researchers. From social networks to geographic location to likes to the actual body of the tweet itself and beyond, there is so much data within just a single tweet. Twitter is of course more than a research tool, however. It is only useful for academics because people in society take to the platform to express themselves, share information, have conversations, and more. It is a freeflowing conversation. Elwood et al. (2012) describe how voulnteered geographic information is changing the academic field of geography and beyond. VGI is not limited to tweets, but can be anything from a geotagged photo to a forum like OpenStreetMap.

Oh- and it is also good to know that a statistically significant amount of people in the places that Trump lied about being in danger were not stupid or blind enough to belive him. This time, at least.


### Citations

Sarah Elwood , Michael F. Goodchild & Daniel Z. Sui (2012) Researching
Volunteered Geographic Information: Spatial Data, Geographic Research, and New Social
Practice, Annals of the Association of American Geographers, 102:3, 571-590, DOI:
10.1080/00045608.2011.595657

Click [here](index.md) to return to the main page.
