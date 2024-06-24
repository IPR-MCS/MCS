import matlab.engine

eng = matlab.engine.start_matlab()

def generateGeometry(shape, unit, nbr_cavities, min_radius, max_radius):
    unit = double(unit)
    return eng.tools.generateGeometry(shape, unit, nbr_cavities,  min_radius, max_radius)

def modifyGeometry(previous_geometry, shape, unit, nbr_cavities, min_radius, max_radius):
    unit = double(unit)
    return eng.tools.modifyGeometry(previous_geometry, shape, unit, nbr_cavities, min_radius, max_radius)

def getThermalBarycenter(thermalResults, Temperature):
    return eng.tools.getThermalBarycenter(thermalResults, Temperature)

def Simulate(geometry, options):
    for option in options.keys():
        options[option] = double(options[option])
    return eng.Simulate(geometry, options)

def double(struct):
    return matlab.double(struct)

def workspace(var, value):
    eng.workspace[var]=value

def save(filepath, var):
    return eng.save(filepath, var, nargout=0)