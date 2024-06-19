# Fetching new geometries
[README](../readme.md)

Table of Contents
- [Fetching new geometries](#fetching-new-geometries)
  - [Import a geometry (`importGeometry`)](#import-a-geometry-importgeometry)
  - [Modify an existing geometry (`modifyGeometry`)](#modify-an-existing-geometry-modifygeometry)
  - [Generate a new geometry (`generateGeometry`)](#generate-a-new-geometry-generategeometry)
## Import a geometry (`importGeometry`)

You can import a geometry.structure from a STL or a STEP file using the `importGeometry` Matlab built-in function.

Example :

```
geometry.structure = importGeometry('Cube.stl');
geometry.exposed_faces = 6
geometry.nbr_cavities = 5
```
## Modify an existing geometry (`modifyGeometry`)
You can modify to some extent an existing **entirely filled** geometry. You can only use this tool to dig spherical cavities inside your geometry.

Arguments  :

*The radius of the cavities is randomised between `min_radius` and `max_radius`*
| Fields      |            Type             | Description |
| ----------- |          ----------         | ----------- |
| previous_geometry | pde.DiscreteGeometry  | Geometry to modify|
| shape             |  string               | 'cube' or 'ellipsoid' |
| unit              | array (double)        | three radii of the ellipsoid or edge of the cube (cm)
| nbr_cavities      | array (double)        | Number of cavities that must be digged |
| min_radius        | array (double)        | Minimum radius of a cavity (mm)|
| max_radius        | array (double)        | Maximum radius of a cavity (mm)|

Example :

```
cube = importGeometry('Cube.stl');
c_geometry = modifyGeometry(cube, 'cube', 2, 30, 0.1, 0.9);
```
```
ellipsoid = importGeometry('Ellipsoid.stl');
e_geometry = modifyGeometry(ellipsoid, 'ellipsoid',[1,0.5,0.5], 30, 0.05, 0.11);

```

## Generate a new geometry (`generateGeometry`)

You can generate new cubic and ellipsoidal geometries. The function returns a `geometry` structure).

Arguments  :

*The radius of the cavities is randomised between `min_radius` and `max_radius`*

| Fields      |        Type         | Description |
| ----------- |     ----------      | ----------- |
| shape  |  string | 'cube' or 'ellipsoid'   |
| unit    | array (double) |  three radii of the ellipsoid or edge of the cube ($m$)
| nbr_cavities    | array (double)  | Number of cavities that must be digged |
| min_radius      | array (double)  | Minimum radius of a cavity $(m)$|
| max_radius      | array (double)  | Maximum radius of a cavity $(m)$|

Example :

```
c_geometry = generateGeometry('cube',15,100,0.2,1.2)
```
```
e_geometry = generateGeometry('ellipsoid',[1,0.5,0.5],5,0.05,0.11)

```