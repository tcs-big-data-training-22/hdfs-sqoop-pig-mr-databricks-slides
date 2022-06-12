# Provision Datalake
- Create a Datalake named - dldatabricks21
- Create Container - inputData
- Create Folder - data

# Provision Databricks, Clusters and workbook
 - Create a Databricks Workspace named - wsDataBricks
  - Its better to create Workspace in the same region in with Datalake is created.
 - Create 4-6 Node Cluster in Databricks named - cluster1

# Mount Datalake in Databricks using SP
- Create SP using CLI
```
az account set --subscription 34ea504b-f779-4be0-892d-f968f164113d
```
{
  "appId": "b9344d96-c48b-426c-8551-68ee134b70ac",
  "displayName": "spDataBricksDataLake2",
  "name": "http://spDataBricksDataLake2",
  "password": "<>",
  "tenant": "6bb2f9af-a0af-4c32-a5ec-5f7011d37551"
}

- Mount ADLS to Databricks using Secret Scope
  - Refer to the code in jupyter notebook


- Give Access to Data lake Gen 2 account we created earlier
  - In Desktop Storage Explorer, Open Data Lake - dldatabricks
  - Create blobb container - inputdata
  - Click Manage Access
    - Add SP named spDataBricksDataLake
      - Provide rights - Read, Write, Execute

- Refer the notebook for the code
