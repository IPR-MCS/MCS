# Python Bridge
[README](../readme.md)

Table of Contents
- [Python Bridge](#python-bridge)
  - [MATLAB Engine (`matlabengine`)](#matlab-engine-matlabengine)
    - [Installation](#installation)
      - [Prerequisites :](#prerequisites-)
    - [Starting the engine](#starting-the-engine)
    - [Calling Functions](#calling-functions)
    - [Handling data types](#handling-data-types)
      - [Arrays and Integers](#arrays-and-integers)
      - [Structures](#structures)
      - [Extract from the official documentation](#extract-from-the-official-documentation)
      - [Using the API](#using-the-api)
    - [API documentation](#api-documentation)
      - [`matlab.double`](#matlabdouble)
      - [`eng.workspace`](#engworkspace)
      - [`eng.load`](#engload)
      - [`eng.save`](#engsave)
  - [SciPy Integration](#scipy-integration)
    - [Load MAT Files](#load-mat-files)
  
By calling the `matlabengine` package, you can directly start a MATLAB session and call seamlessly the model functions.

For more information and advanced use, please consult [the official documentation](https://fr.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html).

## MATLAB Engine (`matlabengine`)
### Installation

#### Prerequisites :

Python <= 3.11

MATLAB Desktop with the PDE Toolbox installed

```
$ pip install matlabengine
````
### Starting the engine

One need to start or connect to a MATLAB session before doing anything.

```matlab
eng = matlab.engine.start_matlab()
```

The MATLAB Engine should detect the appropriate version automatically but in some edge cases, in could not work. In this case, please consult [the official documentation](https://fr.mathworks.com/help/matlab/matlab_external/start-the-matlab-engine-for-python.html) on the subject.
### Calling Functions
Calling the model functions with the MATLAB Engine is simple : it's the exact same way you would do in MATLAB. The only difference is that you need to add the `eng` prefix when calling them. Example :

```matlab
geo = eng.tools.generateGeometry('ellipsoid', matlab.double([1.0,0.5,0.5]), 3.0, 0.1, 0.3)

```

**Be careful !**

When calling a function that does not return one value, you need to add a `nargout=nbr_objects_returned` parameter to precise how many objects will be returned
### Handling data types
#### Arrays and Integers

Python and MATLAB Data types are not equivalent : therefore `matlabengine` translate them.

The majority of this model functions are expecting MATLAB `double` array type. But Python `int` type is translated as MATLAB `int64` type, leading to errors.

Hence, **you need to be sure to pass `float` types to the MATLAB engine functions**. Python `float` is the only type converted as a MATLAB `double`

#### Structures

To create a MATLAB structure (`geometry`, `options`, `material`), you need to pass a Python dictionnary containing fields name (`string`) as keys and the data to transmit as values. For example:

```python
basalt = {'rho': 1000.0,"cp": 100.0,"T_0": 2000.0}
```

#### Extract from the official documentation

| Python type      |       MATLAB Type             
| -----------      |          ----------    | 
| `float`          |   `double`             |
| `complex`        |   Complex `double`     |
| `int`            |   `int64`              | 
| `float(nan)`     |   `NaN`                |
| `float(inf)`     |   `inf`                | 
| `bool`           |   `logical`            | 
| `str`            |   `char`               | 
| `dict`           |   `structure`          | 
| `list`           |   `cell array`         | 
| `set`            |   `cell array`         | 
| `tuple`          |   `cell array`         | 


### API documentation

From [the official documentation](https://fr.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)

#### `matlab.double`

A lot of MATLAB built in functions need arrays to work properly. This function allows a python integer, a float or a list to be converted to a MATLAB `double` array

| Fields      |        Type          | Description |
| ----------- |     ----------      | ----------- |
| struct  |  `int, list or dict | structure to convert |

#### `eng.workspace`

To make MATLAB consider variables (and save them), you need to add them to the MATLAB Workspace. In Python, the MATLAB Workspace is represented as a dictionary, you can add variables to the Workspace the same way you would add a new field to a Python dictionnary, for example:
```python
eng.workspace['results']=results
```
#### `eng.load`

Load MATLAB variables from a given `filepath`. Can only import `.mat` files.
| Fields      |        Type         | Description |
| ----------- |     ----------      | ----------- |
| filepath    |       string        | file to load |

#### `eng.save`

Used to save MATLAB workspace variables under a given `filepath`. Output file can only be saved under a `.mat` extension.

| Fields      |        Type         | Description |
| ----------- |     ----------      | ----------- |
| filepath |  string | file under which to save the variable|
| var  | string | MATLAB Workspace variable ame |

Example :

```python
eng.save("test.mat", "results", nargout=0)
```

## Script Example

## SciPy Integration

### Load MAT Files

MATLAB `.mat` files can be loaded in Python using `scipy.io.loadmat`.
They are then loaded as dictionnaries containing `numpy.ndarray`

Example :
```python
results = scipy.io.loadmat("file.mat")
```