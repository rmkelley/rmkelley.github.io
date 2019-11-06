## Dar es Salaam

The purpose of this lab was to use skills in SQL and database management to run vulnurability analyses on open street map data of Dar es Salaam. Inspired by Resiliance Acadamy, a local educational data-based organization, our work focused on writing scripts and using data that could be accessable to anyone, anywhere. The same goes for our results, which we made into an online leaflet map.

To access the final product, follow the link below.
[Leaflet map of road access to hospitals in Dar es Salaam](dsmap/index.html)

General notes to anyone attempting analysis with large amounts of features.
  -Make sure that your dataformats fit whatever you are trying to do to them. For example, we had a situation where we wanted    to determine the width of the streets, but the column was a string. We had to remove text, remove nulls, and only then        could we convert it into float. The CAST function is useful for converting data types.
  -Make sure that your datasets are not too large to run analysis on. We wanted to upload all the road files into leaflet, but    it would not upload them because it was too large. That prompted us to rethink what exactly we wanted to show in our          analysis. One tip for when you're running spatial analysis is to index the geometries. It means that your computer will not    have to go through every single entry to find what it is looking for and instead will conduct a spatially refined and much    quicker search.
