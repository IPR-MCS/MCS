# MCS : Magma Cooling Simulator
**WIP**

By Tom Chauveau and Noé Busson, Interns at the Physical Institute of Rennes,

Supervised by Mariko and Kevin Dunseath, Professors at the University of Rennes, researchers at the Physical Institute of Rennes, 2024
## Purpose

This model simulates the natural cooling of magma-composed particles of different geometries.

The original purpose for this code is to observe the cooling of the leftovers resulting from a potential collision between Mars and a protoplanet four billions years ago.

In this context, the particles simulated are part of the accretion disk which ended forming Phobos and Deimos *(P. Rosenblatt et al., Accretion of Phobos and Deimos in an extended debris disc stirred by transient moons. Nat. Geosci. 9, 581–583 (2016)*.

This model focuses on the resolution of the heat transfer equation and uses MATLAB (PDE Toolbox) as its main support. Netherveless, a Python bridge should soon become available (using [this software](https://github.com/arokem/python-matlab-bridge)).

## Documentation

| Page            |   Description        |
| -----------     | -------------------- |
| [Structure](doc/structure.md)          | [Code Hierarchy](doc/structure.md#code-hierarchy) and [MATLAB Structures](doc/structure.md#matlab-structures)|
| [Geometries](doc/geometries.md)        | Fetching new geometries |
| [Exploitation](doc/exploitation.md)    | Result exploitation tools (WIP) |
| [Bridge](doc/bridge.md)                | Python-MATLAB bridge (WIP)  

## Project
### Abstract
This model [takes a geometry](doc/geometries.md) (which can be imported, modfied, generated), associates it the physical properties defined by the user, simulate the temperature evolution in the object according to the given boundary conditions (solving the heat transfer equation) and returns a MATLAB `TransientThermalResults` object.

### `Simulate`
| Fields      |        Type          |     Description    |
| ----------- |     ----------       |     -----------    |
| geometry    | pde.DiscreteGeometry | Simulated geometry |
| options     | structure with field | Model options      |

Returns `TransientThermalResults`

### Results Exploitation

Several tools are available to exploit the simulation results. You can find them listed in [the related part of the documentation]().
## Licence

The project being private, no licence is currently defined.

