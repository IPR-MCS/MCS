function simulation = Simulate(geometry)
  simulation.rho=1000;
  simulation.cp=1000;
  simulation.eps=1;
  simulation.TCurie=858;              
  simulation.T_out=300;
  simulation.T_0=2000;
  simulation.dt=200;
  simulation.tmax=6*3600*24;
  simulation.tlist = [0:simulation.dt:simulation.tmax];
  simulation.geometry = geometry;
  lambda = @(location,state) (0.46+0.95*exp(-2.3e-3*state.u)); 
  
  thermalModel = createpde('thermal','transient');
  thermalModel.Geometry=geometry.structure;
  generateMesh(thermalModel,'Hmax',0.2,"GeometricOrder","quadratic");

  thermalModel.StefanBoltzmannConstant = 5.670373E-8;
  thermalProperties(thermalModel,'ThermalConductivity',lambda, ...
      'MassDensity',simulation.rho, ...
      'SpecificHeat',simulation.cp);
  thermalIC(thermalModel,simulation.T_0);
  thermalBC(thermalModel,"Face",7:geometry.nbr_cavities+6,"Temperature",simulation.T_out, "Vectorized","on");
  thermalBC(thermalModel,"Face",1:6,"Emissivity",@(region,state) simulation.eps,"AmbientTemperature",simulation.T_out, "Vectorized","on");

  %% Solver
  simulation.thermalResults = solve(thermalModel,simulation.tlist);
  simulation.Tcenter = interpolateTemperature(simulation.thermalResults,[0;0;0],1:numel(simulation.tlist));

  %% Time to get to Curie Temperature
  [~,indice] = min(abs(simulation.Tcenter-simulation.TCurie));
  simulation.time_to_Curie = simulation.tlist(indice)/(3600*24);
end