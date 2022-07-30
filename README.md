# ALFRESCO FMO

This repository contains scripts and input files needed to generate the fire management options (FMO) GeoTIFFs that are used as inputs for ALFRESCO simulations. FMO inputs can differ between projects, so each project gets its own subdirectory in this repo.

## Setup

Install the pipenv dependencies:

```
pipenv install
```

## Running

To generate FMO files for a particular project, first check the comments in the project's `generate.sh` script to see if any files need to be downloaded or if variables need to be set to local paths. Then run the script like this:

```
pipenv run ./generate.sh
```

Outputs will appear in the `output` subdirectory. These outputs should consist of a set of `Ignition*.tif` and `Sensitivity*.tif` files for each FMO scenario. For example:

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