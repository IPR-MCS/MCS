import matlab.engine

eng = matlab.engine.start_matlab()

geo = eng.tools.generateGeometry('ellipsoid', matlab.double([1.0,0.5,0.5]), 3.0, 0.1, 0.3)

geo['exposed_faces']=1

basalt = {'rho': 1000.0,"cp": 100.0,"T_0": 2000.0}

vaporised_basalt = {"rho": 1000.0,"cp": 500.0,"T_0": 2000.0}

options = {"material": basalt,"cavities_material": vaporised_basalt, "eps": 1.0,"TCurie": 858.0,"T_out": 300.0,"tmax": float(6*3600*24),"dt": 200.0}

thermalResults = eng.Simulate(geo,options)

print(thermalResults)

results = eng.tools.getThermalBarycenter(thermalResults, 858)

results = eng.interpolateTemperature(thermalResults, results['Bar'], matlab.double([i for i in range(1,int(options['tmax']/options['dt'])+1)]))

print(results)

eng.workspace['results']=results

eng.save("test.mat","results")