# Fetching new geometries
[README](../readme.md)

Table of Contents
- [Fetching new geometries](#fetching-new-geometries)
  - [Import a geometry (`importGeometry`)](#import-a-geometry-importgeometry)
  - [Modify an existing geometry (`modifyGeometry`)](#modify-an-existing-geometry-modifygeometry)
  - [Generate a new geometry (`generateGeometry`)](#generate-a-new-geometry-generategeometry)
## Import a geometry (`importGeometry`)

One can import a `geometry.structure` from a STL or a STEP file using the `importGeometry` Matlab built-in function.

Example :

```matlab
geometry.structure = tools.importGeometry('Cube.stl');
geometry.exposed_faces = 6
geometry.nbr_cavities = 5
```

## Generate a new geometry (`generateGeometry`)

One can generate new cubic or ellipsoidal geometries. The function `generateGeometry` returns a `geometry` structure, with the following arguments : 

Arguments  :

*The radius of the spherical heterogenous cavities is randomized between `min_radius` and `max_radius`. Set `nbr_cavities` to `0` for homogeneous geometry.*

| Fields      |        Type         | Description |
| ----------- |     ----------      | ----------- |
| shape  |  string | 'cube' or 'ellipsoid'   |
| unit    | array (double) |  three radii of the ellipsoid or edge of the cube ($m$)
| nbr_cavities    | array (double)  | Number of cavities that must be digged |
| type            | string          | Type of cavities; must be `full` or `void` |
| min_radius      | array (double)  | Minimum radius of a cavity $(m)$|
| max_radius      | array (double)  | Maximum radius of a cavity $(m)$|

Example :

```matlab
c_geometry = tools.generateGeometry('cube',15,100,'void',0.2,1.2)
```
```matlab
e_geometry = tools.generateGeometry('ellipsoid',[1,0.5,0.5],5,'full',0.05,0.11)

```

## Modify an existing geometry (`modifyGeometry`)
One can modify a pre-existing entirely filled geometry to insert cavities or heterogeneity using the `modifyGeometry` function, that takes the following parameters : 


Arguments  :

*The radius of the cavities is randomised between `min_radius` and `max_radius`*
| Fields      |            Type             | Description |
| ----------- |          ----------         | ----------- |
| previous_geometry | pde.DiscreteGeometry  | Geometry to modify|
| shape             |  string               | 'cube' or 'ellipsoid' |
| unit              | array (double)        | three radii of the ellipsoid or edge of the cube (cm)
| nbr_cavities      | array (double)        | Number of cavities that must be digged |
| type            | string          | Type of cavities; must be `full` or `void` |
| min_radius        | array (double)        | Minimum radius of a cavity (mm)|
| max_radius        | array (double)        | Maximum radius of a cavity (mm)|

Example :

```matlab
cube = tools.importGeometry('Cube.stl');
c_geometry = tools.modifyGeometry(cube, 'cube', 2, 30, 'full', 0.1, 0.9);
```
```matlab
ellipsoid = tools.importGeometry('Ellipsoid.stl');
e_geometry = tools.modifyGeometry(ellipsoid, 'ellipsoid',[1,0.5,0.5], 30, 'void', 0.05, 0.11);

```