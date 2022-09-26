# SERDP Fish and Fire

## Setup

This script depends on the `Alaska_IA_FireManagementOptions.gdb` geodatabase, distributed by the AICC, in the `serdp/inputs` directory. The current version can be downloaded at [https://fire.ak.blm.gov/predsvcs/maps.php](https://fire.ak.blm.gov/predsvcs/maps.php). Unzip the download and place the `.gdb` file in `serdp/input`:

```
cd serdp/input
curl -o fmo.zip https://fire.ak.blm.gov/content/maps/aicc/Data/Data%20\(zipped%20filegeodatabases\)/AlaskaWildlandFire_IA_Management_Options_2022.zip
unzip fmo.zip
```

## Running

If you installed GDAL 3.0+ into a conda environment, make sure to activate that first. For example:

```
conda activate fmo
```

Then run the script like this:

```
cd serdp
./generate.sh
```

This will output some performance and field truncation warnings that can be ignored. Outputs will appear in the `output` subdirectory. These outputs should consist of a set of `Ignition*.tif` and `Sensitivity*.tif` files for each FMO scenario. For example:

```
$ ls output/FMO
Ignition1.tif		Ignition3.tif		Sensitivity2.tif
Ignition2.tif		Sensitivity1.tif	Sensitivity3.tif
```

Each file in the `Ignition*.tif` and `Sensitivity*.tif` series corresponds to a fire transition year in the ALFRESCO configuration. The file sequence corresponds to these transition years:

| FMO Files                           | Fire Transition Year |
| ----------------------------------- | -------------------- |
| `Ignition1.tif`, `Sensitivity1.tif` | 1000                 |
| `Ignition2.tif`, `Sensitivity2.tif` | 1950                 |
| `Ignition3.tif`, `Sensitivity3.tif` | Present Year         |

Currently, all `Ignition*.tif` files/symlinks are identical by design. This may change in the future. `Sensitivity2.tif` and `Sensitivity3.tif` may be the same, as well, depending on whether changes to the past vs. future FMO scenarios are being simulated.

Once the GeoTIFFs are generated, include them in the `Spatial.IgnitionFactor` and `Spatial.Sensitivity` sections of the JSON configuration for an ALFRESCO run, as seen in the [example JSON configuration](https://github.com/ua-snap/alfresco/blob/main/examples/alfresco.json).