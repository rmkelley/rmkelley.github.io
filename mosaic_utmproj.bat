::Robert Kelley. The purpose of this batch is to automate the hydrology analysis from the previous lab section.
::set the path to your SAGA program
SET PATH=%PATH%;c:\saga6

::set the prefix to use for all names and outputs
SET pre=ASTER_

::set the directory in which you want to save ouputs. In the example below, part of the directory name is the prefix you entered above
SET od=W:\Q\Lab_2\Part2\take2\ASTER\deliv

:: the following creates the output directory if it doesn't exist already
if not exist %od% mkdir %od%

:: Run Mosaicking tool, with consideration for the input -GRIDS, the -
saga_cmd grid_tools 3 -GRIDS=ASTGTMV003_S03E037_dem.tif;ASTGTMV003_S04E037_dem.tif -NAME=%pre%Mosaic.sgrd -TYPE=9 -RESAMPLING=1 -OVERLAP=1 -MATCH=0 -TARGET_OUT_GRID=%od%\%pre%mosaic.sgrd
::SRTM option: saga_cmd grid_tools 3 -GRIDS=S03E037.hgt;S04E037.hgt -NAME=%pre%Mosaic.sgrd -TYPE=9 -RESAMPLING=1 -OVERLAP=1 -MATCH=0 -TARGET_OUT_GRID=%od%\%pre%mosaic.sgrd

:: Run UTM Projection tool
saga_cmd pj_proj4 24 -SOURCE=%od%\%pre%mosaic.sgrd -RESAMPLING=0 -KEEP_TYPE=1 -GRID=%od%\%pre%mosaicUTM.sgrd -UTM_ZONE=37 -UTM_SOUTH=1

:: Run Hillshade tool
saga_cmd ta_lighting 0 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SHADE=%od%\%pre%hillshade.sgrd

:: Run Sink Drainage Route Detection tool
saga_cmd ta_preprocessor 1 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=%od%\%pre%sinkroutes.sgrd

:: Run Sink Removal tool
saga_cmd ta_preprocessor 2 -DEM=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=%od%\%pre%sinkroutes.sgrd -DEM_PREPROC=%od%\%pre%sinkremoved.sgrd

:: Run Flow Accumulation (Top-Down) tool
saga_cmd ta_hydrology 0 -ELEVATION=%od%\%pre%sinkremoved.sgrd -SINKROUTE=%od%\%pre%sinkroutes.sgrd -FLOW=%od%\%pre%flowaccumulation.sgrd -FLOW_UNIT=0

:: Run Channel Network tool
saga_cmd ta_channels 0 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=NULL -CHNLNTWRK=%od%\%pre%networkgrid.sgrd -CHNLROUTE=%od%\%pre%networkroute.sgrd -SHAPES=%od%\%pre%networkshapes.sgrd -INIT_GRID=%od%\%pre%flowaccumulation.sgrd -INIT_VALUE=1000

::print a completion message so that uneasy users feel confident that the batch script has finished!
ECHO Processing Complete!
PAUSE