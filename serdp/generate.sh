#!/bin/bash

# Set to the extracted ZIP of the AICC management options file geodatabase.
# Tested with AlaskaWildlandFire_IA_Management_Options_2022.zip
# Download current version from here: https://fire.ak.blm.gov/predsvcs/maps.php
AICC_FMO_GDB='input/Alaska_IA_FireManagementOptions.gdb'

if [ ! -e $AICC_FMO_GDB ]
then
  echo "$AICC_FMO_GDB does not exist."
  echo "Download fire management options file geodatabase from AICC:"
  echo "https://fire.ak.blm.gov/predsvcs/maps.php"
  echo "Then extract it into $AICC_FMO_GDB"
  exit 1
fi

mkdir -p tmp output/NoFMO output/FMO output/AltFMO

# First step: Extract and rasterize relevant fire management options polygons
# from AICC file geodatabase.

# Separate and rasterize Critical level polygons
ogr2ogr -t_srs EPSG:3338 -sql "SELECT * FROM fire_management_options WHERE PROT = 'C'" tmp/reprojected.shp $AICC_FMO_GDB
gdal_rasterize tmp/reprojected.shp tmp/AICC_FMO_C.tif -a_nodata 0 -a_srs EPSG:3338 -burn 210 -ts 5528 2223 -te -1725223.205807 321412.933 3802776.794 2544412.932644 -ot Float32
rm tmp/reprojected.*

# Separate and rasterize Full level polygons
ogr2ogr -t_srs EPSG:3338 -sql "SELECT * FROM fire_management_options WHERE PROT = 'F'" tmp/reprojected.shp $AICC_FMO_GDB
gdal_rasterize tmp/reprojected.shp tmp/AICC_FMO_F.tif -a_nodata 0 -a_srs EPSG:3338 -burn 235 -ts 5528 2223 -te -1725223.205807 321412.933 3802776.794 2544412.932644 -ot Float32
rm tmp/reprojected.*

# Separate and rasterize Modified level polygons
ogr2ogr -t_srs EPSG:3338 -sql "SELECT * FROM fire_management_options WHERE PROT = 'M'" tmp/reprojected.shp $AICC_FMO_GDB
gdal_rasterize tmp/reprojected.shp tmp/AICC_FMO_M.tif -a_nodata 0 -a_srs EPSG:3338 -burn 260 -ts 5528 2223 -te -1725223.205807 321412.933 3802776.794 2544412.932644 -ot Float32
rm tmp/reprojected.*

# Second step: Merge extracted fire management options with extent mask and DOD
# AltFMO areas in various ways to produce ALFRESCO fire management input
# rasters. Pre-1950 and NoFMO ignition rasters have a max value fof 0.000016,
# whereas 1950+ FMO and AltFMO ignition rasters have a max value of 0.000018.
# Pre-1950 and NoFMO sensitivity rasters have a max value of 380, whereas 1950+
# FMO and AltFMO sensitivity rasters have a max value of 355. 

# Create NoFMO rasters
gdal_calc.py -A input/extent_mask.tif --outfile=output/NoFMO/Ignition1.tif --cal="0.000016*(A>0)"
ln -s Ignition1.tif output/NoFMO/Ignition2.tif
ln -s Ignition1.tif output/NoFMO/Ignition3.tif
gdal_calc.py -A input/extent_mask.tif --outfile=output/NoFMO/Sensitivity1.tif --cal="380*(A>0)"
ln -s Sensitivity1.tif output/NoFMO/Sensitivity2.tif
ln -s Sensitivity1.tif output/NoFMO/Sensitivity3.tif

# Create FMO rasters
gdal_calc.py -A input/extent_mask.tif --outfile=output/FMO/Ignition1.tif --cal="0.000016*(A>0)"
gdal_calc.py -A input/extent_mask.tif --outfile=output/FMO/Ignition2.tif --cal="0.000018*(A>0)"
ln -s Ignition2.tif output/FMO/Ignition3.tif
gdal_calc.py -A input/extent_mask.tif --outfile=output/FMO/Sensitivity1.tif --cal="380*(A>0)"
gdal_merge.py -ot Float32 -of GTiff -o output/FMO/Sensitivity2.tif input/extent_mask.tif tmp/AICC_FMO_C.tif tmp/AICC_FMO_F.tif tmp/AICC_FMO_M.tif
ln -s Sensitivity2.tif output/FMO/Sensitivity3.tif

# Create AltFMO rasters
gdal_calc.py -A input/extent_mask.tif --outfile=output/AltFMO/Ignition1.tif --cal="0.000016*(A>0)"
gdal_calc.py -A input/extent_mask.tif --outfile=output/AltFMO/Ignition2.tif --cal="0.000018*(A>0)"
ln -s Ignition2.tif output/AltFMO/Ignition3.tif
gdal_calc.py -A input/extent_mask.tif --outfile=output/AltFMO/Sensitivity1.tif --cal="380*(A>0)"
gdal_merge.py -ot Float32 -of GTiff -o output/AltFMO/Sensitivity2.tif input/extent_mask.tif tmp/AICC_FMO_C.tif tmp/AICC_FMO_F.tif tmp/AICC_FMO_M.tif
gdal_merge.py -ot Float32 -of GTiff -o output/AltFMO/Sensitivity3.tif input/extent_mask.tif tmp/AICC_FMO_C.tif tmp/AICC_FMO_F.tif input/dod_alt_fmo_areas.tif tmp/AICC_FMO_M.tif
