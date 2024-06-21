function Results = Simulate(geometry, options)
  tlist = 0:options.dt:options.tmax;
  lambda = @(location,state) (0.46+0.95*exp(-2.3e-3*state.u)); 
  
  thermalModel = createpde('thermal','transient');
  thermalModel.Geometry=geometry.structure;
  generateMesh(thermalModel,'Hmax',0.2,"GeometricOrder","quadratic");
  thermalModel.StefanBoltzmannConstant = 5.670373E-8;

  thermalProperties(thermalModel,'ThermalConductivity',lambda, ...
      'MassDensity',options.rho, ...
      'SpecificHeat',options.cp);
  thermalIC(thermalModel,options.T_0);
  thermalBC(thermalModel,"Face",geometry.exposed_faces,"Emissivity",@(region,state) options.eps,"AmbientTemperature",options.T_out, "Vectorized","on");

  %% Solver
  Results = solve(thermalModel,tlist);
end