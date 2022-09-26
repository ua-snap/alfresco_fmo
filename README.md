# ALFRESCO FMO

This repository contains scripts and input files needed to generate the fire management options (FMO) GeoTIFFs that are used as inputs for ALFRESCO simulations. FMO inputs can differ between projects, so each project gets its own subdirectory in this repo.

## Setup

This repo depends on the `gdal_calc.py` script that was introduced in GDAL 3.0. If you are running this on a system that does not have GDAL 3.0 or above installed globally, or if you encounter numpy import errors, install GDAL via conda like this:

```
conda create --name fmo "gdal>=3.0"
```

To generate FMO files for a particular project, view the `README.md` file in the corresponding project sub-folder (e.g., `serdp` for the SERDP Fish and Fire project)