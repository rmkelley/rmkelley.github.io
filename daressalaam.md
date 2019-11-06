## Dar es Salaam

The purpose of this lab was to use skills in SQL and database management to run vulnurability analyses on open street map data of Dar es Salaam. Inspired by Resiliance Acadamy, a local educational data-based organization, our work focused on writing scripts and using data that could be accessable to anyone, anywhere. The same goes for our results, which we made into an online leaflet map.

To access the final product, follow the link below.
[Leaflet map of road access to hospitals in Dar es Salaam](dsmap/index.html)

General notes to anyone attempting analysis with large amounts of features.

-Make sure that your dataformats fit whatever you are trying to do to them. For example, we had a situation where we wanted to determine the width of the streets, but the column was a string. We had to remove text, remove nulls, and only then could we convert it into float. The CAST function is useful for converting data types. We used CAST to take string data in one column and then CAST it into the float type in another column that we made.
  
-Make sure that your datasets are not too large to run analysis on. We wanted to upload all the road files into leaflet, but it would not upload them because it was too large. That prompted us to rethink what exactly we wanted to show in our analysis. One tip for when you're running spatial analysis is to index the geometries. It means that your computer will not have to go through every single entry to find what it is looking for and instead will conduct a spatially refined and much quicker search.

-ALWAYS visualy check your results. If something does not look right, it probably isn't. We had a point where half of our major roads were going to be missing from the buffer, because we were not inclusive enough in our selection process. It was an easy fix, but if we had not caught it then half of Dar es Salaam would seem to have no access to anywhere.

Our steps:
1. FIgure out what we were interested, and then determine what data we needed. Can the question be simplified? In our case, road access to hospitals.
2. We had to trip the data pulled from OSM. We made three datasets. Hospitals, houses, and roads. Roads had to have a width and a road distinction in the "highway" column. Homes had to have the Amenity column be "residential" and hospital had to be hospital or doctor.
3. Extract the width of each road. We had to convert our datatypes.
4. Create a buffer around the roads to give area. They were originally lines with their width not represented. We tested multiple different buffers, adding 5 meters for most roads and 18 meters for the trunk roads to encapsulate the road width and the building setbacks.
5. Intersect the building layer with the buffer. How many houses are actually in proximity to the road? The buffer was our proxy for ease of access. If your residence is set too far back from a road, it is unlikely to have easy or official access. Especially for medical personel in an informal settlment. 
6. Once we determined intersection, we had to get that data into a subwards feature. We made a table that took data from homes and subwards, and then took the agglomerated data from that and added it into our subwards feature.
