# Python API (`pymatapi`)
[README](../readme.md)

Table of Contents
- [Python API (`pymatapi`)](#python-api-pymatapi)
  - [Installation \& Implementation](#installation--implementation)
    - [Prerequisites :](#prerequisites-)
    - [Using it](#using-it)
  - [API Functions](#api-functions)
    - [`double`](#double)
    - [`workspace`](#workspace)
    - [`save`](#save)

It is possible to directly call the functions of this model from Python (<=3.11) using a bridge that we developped by embedding the matlabengine package. For more information, please consult [the official documentation](https://fr.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html).

## Installation & Implementation

### Prerequisites :

Python <= 3.11

MATLAB Desktop with the PDE Toolbox installed

MATLAB Runtime standalone soon available (compilation needed)

```
$ pip install matlabengine
```

### Using it

You need import the pymatapi bridge, being on the root folder of MCS, you can then use all the module function, simply by calling them the same way you would do in MATLAB.

Giving a simple example :
```
import pymatapi
geo = pymatapi.generateGeometry('ellipsoid',[1,0.5,0.5], 3, 0.1, 0.3)
geo['exposed_faces']=1
options = {'rho': 1000,"cp":1000,"T_0":2000,"eps":1,"TCurie":858,"T_out":300,"tmax":6*3600*24,"dt":200}
results = pymatapi.Simulate(geo,options)
pymatapi.workspace("results",results)
pymatapi.save("hello.m","results")
```

## API Functions 

### `double`

A lot of MATLAB built in functions need arrays to work properly. This function allows a python integer or a list to be converted to a MATLAB array

| Fields      |        Type         | Description |
| ----------- |     ----------      | ----------- |
| struct  |  integer or list  | structure to convert |

### `workspace`

To make MATLAB consider variables, you need to add them to the MATLAB Workspace. This function allow do do so

| Fields      |        Type         | Description |
| ----------- |     ----------      | ----------- |
| var |  integer or list  | name of the variable inside the MATLAB Workspace |
| value  | any type  | variable to send to the MATLAB Workspace  |

### `save`

Used to save MATLAB workspace variables under a given `filepath`. Output file can only be saved under a `.mat` extension

| Fields      |        Type         | Description |
| ----------- |     ----------      | ----------- |
| filepath |  string | filepath under which to save the variable|
| var  | string | MATLAB Workspace variable ame |