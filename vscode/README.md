# VSCode Setup and Runing

## Install ECL plugin
https://marketplace.visualstudio.com/items?itemName=hpcc-systems.ecl

## Create workspace
- You can save a opened folder as workspace from File -> Save a workspace as
- You also can create a <name>.workspace file and list the folders:
```code
{
  "folders": [
  {
     "path": "model"
  },
  {
     "path": "C:\\Users\\wangxi01\\AppData\\Roaming\\HPCCSystems\\bundles"
  }
  ]
}
This workspace include two directories: one is local "model" which has all our GNN ECL code. The other is ML bundles including GNN packaage
### Settings
Settings can be accessed from File -> Preferences -> Settings. There are "User", "Workspace" and current opened foler. Usually you select "Extensions"-> ECL. You can modify any of these. Click "Edit in settings.json" will open or create a .vscode/settings.json file. You can edit settings, for example,
```code
{
    "ecl.eclccPath": "C:\\Program Files\\HPCCSystems\\8.0.2\\clienttools\\bin\\eclcc",
    "ecl.includeFolders": ["."]
}
You also can put settins to workspace file:
```code
{
  "folders": [
  ],
  "settings": {
  }
}
```
As always .vscode/settings.json overwrite workspace wich overwrite user settings.
#### Configuration
You can create a new configuration file .vscode/launch.json by click "Run" -> "Add configuration" -> ECL. It will create a standard configuration list:
```code
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [

        {
            "name": "GNN",
            "type": "ecl",
            "request": "launch",
            "protocol": "http",
            "serverAddress": "localhost",
            "port": 8010,
            "targetCluster": "hthor",
            "rejectUnauthorized": false,
            "resultLimit": 100,
            "timeoutSecs": 60,
            "user": "",
            "password": ""
        }
    ]
}
```
As settings you can put configuration in workspace file also:
```code
{
  "folders": [
  ],
  "settings": {
  },
  "configuration": {
  }
}
```
Again, .vscode/launch.json overwrite workspace configuration

## Develop and Run ECL code

### Develop ECL code
For development reference  [GNN ECL Code](../HPCC/GNN/Development.md)

### Update ECLWatch ip
For every new HPCC deployment you need update eclwatch ip in the ./vscode/launch.json:
```code
"serverAddress": <eclwatch ip> 
```

### Run ECL code
1. Open the Ecl Code you want to run:
2. From "View" select "Command Palette"
3. Select "ECL:Submit"

For AHS GNN code here is the files to run:
1. AHS_Images.ecl  # You only need to run once unless Dataset or logic file changed
2. AHS_GNN_TL3.ecl # This will create and train the model and predict with test image files

You may want to tweak some configuration to improve accuracy and prediction, etc.
Such as number epochs

### Check Results
You can either check the results from VSCode OUTPUT, workunit at bottom or from eclwatch
