# How to Create and upload a dataset on Geonetwork

##  Steps to follow

1. create standardized yaml file (view scripts for that)
2. generate xml files from yaml (`parse` command) -> dump a csv with a list of all files generated
3. upload xml files on geonetwork (`upload` method) -> auto-update of uuid values in the csv file with geonetwork responses
4. if any postponed values, update them on geonetwork records (`update-postponed-values` values method)

## Example : how to create the theoretical verniquet records

### Move to your destination folder
First, you need to go in the `verniquet` folder, located in `geonetwork-resources`.
So, if you are in the `catalog` folder, enter :

```sh
cd geonetwork-resources/verniquet
```

### Generate the yaml file

Here, you can generate a standardized yaml file with the script `create_records.py`

```sh
python create_records.py
```

### Generate the xml files from the yaml file

You can use the parse command from the soduco_geonetwork_cli packages

```sh
soduco_geonetwork_cli parse verniquet_records.yaml
```

This function also generates a file named `yaml_list.csv` with the informations of the xml files created.
Those informations are : the yaml identifier, the xml file path and the postponed values (if any) to edit after upload.
Those postponed values are links between xml files to create after an uuid has been attributed by geonetwork

### Upload the xml files on geonetwork

You can upload all your xml files from your csv with the `upload` command.
Each xml file will correspond to a dataset on geonetwork.

```sh
soduco_geonetwork_cli upload yaml_list.csv
```

Your yaml_list.csv will be updated with the uuid attributed by geonetwork to each dataset.

### Update postponed values (if any)

You can update postponed values on geonetwork's records with the `update-postponed-values` command
Any "postponed value" in your yaml_list.csv will be updated based on the yaml identifier.

```sh
soduco_geonetwork_cli update-postponed-values yaml_list.csv
```

And that's all.

You can repeat those steps for another group of datasets, like `verniquet_bnf` or `verniquet_stanford`
