# Code Hierachy and MATLAB Structures

[README](../readme.md)

Table of Contents
- [Code Hierachy and MATLAB Structures](#code-hierachy-and-matlab-structures)
  - [Code Hierarchy](#code-hierarchy)
  - [MATLAB Structures](#matlab-structures)
      - [Input Structures](#input-structures)
        - [Geometry](#geometry)
      - [Material](#material)
        - [Options](#options)
    - [Output Structure](#output-structure)
      - [Results](#results)
## Code Hierarchy

The `tools` folder contains the tools used to generate or import geometries and those used to exploit the simulation results
* `generateGeometry`
* `modifyGeometry`
* 
The `tools/utils` folder contains utilitaries useful to the `tools` folder functions.
  
* `digCube`
* `digEllipsoid`
* `spheresIntersect`

## MATLAB Structures
#### Input Structures
##### Geometry

A `geometry` structure is composed of the following **mandatory** fields :`
| Fields          |        Type          | Description |
| -----------     | -------------------- |----------- |
| structure       | pde.DiscreteGeometry | Geometry|
| exposed_faces   |      array (double)  | ID of the faces exposed to the radiation flow |
| nbr_cavities_faces   | array (double)  | Number of faces in all the cavities |

Matlab counts the faces in the following order :

- planar external faces
- curved/modified external faces
- faces inside the cavities

Giving an example : `geometry.exposed_faces = [1:3,5:7]`.

This model allows several ways to import, modify or generate geometries. You can find them below.

#### Material

A `material` structure is composed of the following mandatory fields :

| Fields      |        Type          | Description |
| ----------- |     ----------       | ----------- |
| rho         | array (double)       | Density of the object ($kg \cdot m^3$)|
| cp          | array (double)       | Specific heat ($J \cdot kg^{-1} \cdot K^{-1})$)
| T_0         | array (double)       | Initial temperature of the object ($K$)|

##### Options

An `options` structure is composed of the following mandatory fields :`

| Fields            |        Type        | Description |
| -----------       |     ----------     | ----------- |
| material          |  `material`        | The properties of the material composing the main geometry |   
| cavities_material |  `material`        | The properties of the material composing the cavities  | 
| T_out             | array (double)     | Temperature outside the object ($K$)|
| eps               | array (double)     | Emissivity of the object (no dimension) |
| dt                | array (double)     | Simulation time step $(s)$|
| tmax              | array (double)     | Duration of the simulation ($s$)|
### Output Structure

#### Results

The `Simulate` function returns a `TransientThermalResults` built-in structure containing the following properties (fetched from [the MATLAB documentation](https://fr.mathworks.com/help/pde/ug/pde.transientthermalresults.html))

| Fields      |        Type          | Description |
| ----------- |     ----------       | ----------- |
| Temperature | array (double)       | Temperature values at nodes, returned as a matrix|
| SolutionTimes        | array (double)       | Solution times, returned as a real vector|
| XGradients         | array (double)       | x-component of the temperature gradient at nodes, returned as a matrix|
| YGradients         | array (double)       | y-component of the temperature gradient at nodes, returned as a matrix|
| ZGradients         | array (double)       | z-component of the temperature gradient at nodes, returned as a matrix|
| Mesh       | FEMesh| Finite element mesh, returned as an FEMesh Properties object.|