## Lab 3 continued: Batch Processing Flow Accumulation Models

This section took the processes learned in lab three and converted them into batch processes. 

We used SAGA version 6.2, inputting data from ASTER and SRTM. The ASTER data is Model V003, 2019, while the SRTM data is from NASA's Shuttle Radar Teopography Mission Global 1 arc second data set.

For the region as a whole, the SRTM data provides a mask for waterfeatures while ASTER does not. Furthermore, the channel networks rendered more completely for the SRTM data than the ASTER data and also appear to more closely fit where streams would be on an elevation model and Google imagery via an eye-check. Additionally, the ASTER Number file has large sections that are drawn from the SRTM data.

ASTER Elevation and Data Sources

![ASTER Elevation](ASTER_EL_UTM.png)
![](ASTER_EL_UTM_legend.png)

![ASTER Data Sources](ASTER_NUM_UTM.png)
![](ASTER_NUM_UTM_legend.png)

SRTM Elevation and Data Sources

![SRTM Elevation](STRM_EL_UTM.png)
![](STRM_EL_UTM_legend.png)

![SRTM Data Sources](STRM_NUM_UTM.png)
![](STRM_NUM_UTM_legend.png)

Batch Process Download

[Batch File](mosaic_utmproj.bat)

Bath Process Screen Capture

![Batch Process Example](batch_example.PNG)

The batch process is a collection of commands written out in the computer's command window. Instead of needing to go through the UI of SAGA or GQIS, batch processing runs those programs for you directly. Each tool I used to model the hydrology was found [here](http://www.saga-gis.org/saga_tool_doc/6.4.0/a2z.html). Most of my settings remained on default, but later on in the processes some changed. Running the processes one time took roughly twenty minutes, but it was possible to run different batches on several computers to preserve time.

Difference in Elevation

![Elevation Difference](Elevation_difference.jpg)
![](Elevation_difference_legend.png)

Flow Accumulation initial image

The image below is what SAGA initially put out as the difference between the flow accumulations from the different data sets. The information was there, but not in workable form.

![Flow Difference](FA_difference.png)
![](FA_difference_legend.png)

Flow Accumulation Difference with Contrast

Creating contrast between the two networks was the first step.

![Flow Accumulation Difference with Contrast](FA_diff_contrast.png)
![](FA_diff_contrast_legend.png)

This is a closeup of the product of the step prior, allowing viewers to see how the flows are very similar and have many of the same movements, but at the ground level are often slightly different.

![Flow Accumulation Closeup](dif_closeup.PNG)

SRTM Hillshade

![SRTM Hillshade](SRTM_hillshade.jpg)
![](SRTM_hillshade_legend.png)

ASTER Hillshade

![Aster Hillshade](ASTER_hillshade.png)
![](ASTER_hillshade_legend.png)

3D Renderings of the channel networks over the hillshade

ASTER

![ASTER 3D](ASTER_3D.PNG)

SRTM

![SRTM 3D](SRTM_3D.PNG)

One thing to note between the two different types of data is the water feature in the bottom right hand corner- it is different. SRTM provides a void for known water there, which is more likely to be correct than the ASTER results.

Google Satelite Basemap

While there were errors with this in QGIS, Ben Dohan and Koufre found a good workaround inside of QGIS resulting in the same idea.

![Side by side basemaps](comp_background.PNG)

One issue is that at higher elevations, the channel networks never seem to leave the ridges of the mountain. This is most likely a result of using a top-down flow accumulation processs, where the starting point was not able to sample widely enough to break out of issues like that. In this case, it would be important to sample from the bottom-upwards as well, and then average the two to minimize this error.

SRTM Error1

![Error 1](SRTM_base_zoom1.PNG)

Here, there are examples of the flows mainly following what one would expect from the imagery, but every so often they jump their tracks and go off in an unexpected direction. This seems most likely to be the result of my unit size and sampling method, either having units too broad or too specific to notice the smallest details- or to over react to them. My guess is the former.

SRTM Error2

![Steep](oops_steep.PNG)

These are examples of where there is what seems like a steep section of the mountain but little differences in terrain to guide it. One likely explanation is that the flow accululation is based on higher levels of snow and ice at the summit, which is not present in the arial photography. That exposes an underlying issue with these data sets which we have discussed in class. Because space very often can change over time, having a data set that does not match up squarely with the time frame of other parts of your analysis can create some disjointedness.

[Click here to go to Hydrology; Lab 3](saga.md)

[Click here to go to the main page](index.md)
