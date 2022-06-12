# How to setup databricks CLI
```
conda install -c conda-forge databricks-cli
```

```
databricks configure --token
```

- Enter your workspace URL, with the format https://<instance-name>.cloud.databricks.com.
  - Sample: https://adb-8190330192940305.5.azuredatabricks.net
- When prompted, specify the token
  - Sample Token: dapi83c3625d306c7199df36322dd56fb7d4

- Check the configuration on windows:
```
type %USERPROFILE%\.databrickscfg
```

- Run various databricks cli commands:
```
databricks jobs list --output JSON
databricks clusters list --output JSON
databricks jobs run-now --job-id 9 --jar-params "[\"20180505\", \"alantest\"]"
databricks workspace ls
```

## Create databricks cluster using CLI
- Create cluster:
```
databricks clusters create --json-file create-cluster.json
```

- Get details of cluster created:
```
databricks clusters get --cluster-name standard-cluster
```
- Delete Cluster
```
databricks clusters delete --cluster-id "0508-080937-43ys6d98"
```

- For more details on Databricks CLI Commands, refer:
  - https://docs.databricks.com/dev-tools/cli/clusters-cli.html
