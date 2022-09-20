# ALFRESCO FMO

This repository contains scripts and input files needed to generate the fire management options (FMO) GeoTIFFs that are used as inputs for ALFRESCO simulations. FMO inputs can differ between projects, so each project gets its own subdirectory in this repo.

## Setup

This repo depends on the `gdal_calc.py` script that was introduced in GDAL 3.0. If you are running this on a system that does not have GDAL 3.0 or above installed globally, or if you encounter numpy import errors, install GDAL via conda like this:

```
conda create --name fmo "gdal>=3.0"
```

## Running

To generate FMO files for a particular project, first check the comments in the project's `generate.sh` script to see if any files need to be downloaded or if variables need to be set to local paths.

If you installed GDAL 3.0+ into a conda environment, make sure to activate that first. For example:

```
conda activate fmo
```

Then run the script like this:

```
./generate.sh
```

This will output some performance and field truncation warnings that can be ignored. Outputs will appear in the `output` subdirectory. These outputs should consist of a set of `Ignition*.tif` and `Sensitivity*.tif` files for each FMO scenario. For example:

```
$ ls output/FMO
Ignition1.tif		Ignition3.tif		Sensitivity2.tif
Ignition2.tif		Sensitivity1.tif	Sensitivity3.tif
```

Each file in the `Ignition*.tif` and `Sensitivity*.tif` series corresponds to a fire transition year in the ALFRESCO configuration. The file sequence generally corresponds to these transition years:

| FMO Files                           | Fire Transition Year |
| ----------------------------------- | -------------------- |
| `Ignition1.tif`, `Sensitivity1.tif` | 1000                 |
| `Ignition2.tif`, `Sensitivity2.tif` | 1950                 |
| `Ignition3.tif`, `Sensitivity3.tif` | Present Year         |

Currently, all `Ignition*.tif` files are identical by design. This may change in the future. `Sensitivity2.tif` and `Sensitivity3.tif` may be the same, as well, depending on whether changes to the past vs. future FMO scenarios are being simulated.

Once the GeoTIFFs are generated, include them in the `Spatial.IgnitionFactor` and `Spatial.Sensitivity` sections of the JSON configuration for an ALFRESCO run, as seen in the [example JSON configuration](https://github.com/ua-snap/alfresco/blob/main/examples/alfresco.json).