function Results = Simulate(geometry, options)
  tlist = 0:options.dt:options.tmax;

  % Add a gaussian peak in specific heat capacity expression for latent heat
  if options.latent_heat > 0
    mu = options.T_latent; 
    sigma = 5;
    A = options.latent_heat/sqrt(2*pi*sigma^2);
    specific_heat_material=@(location,state) A*exp(-((state.u-mu).^2)/sigma^2)+options.cavities_material.cp; 
    specific_heat_cavity=@(location,state) A*exp(-((state.u-mu).^2)/sigma^2)+options.cavities_material.cp;
  elseif options.latent_heat == 0
    specific_heat_material=options.cavities_material.cp; 
    specific_heat_cavity=options.cavities_material.cp;
  else 
    error("Latent heat; must define 'latent_heat' and 'Tlatent'.");
  end

  if options.material.lambda == "dresser"
    lambda_material = @(location, state) 0.35+0.85*exp(-1.7e-3*(state.u-273)); 
  elseif options.material.lambda == "hebei"
    lambda_material = @(location, state) 0.59+0.23*exp(-4.3e-4*(state.u-273)); 
  elseif options.material.lambda == "tholeiitic"
    lambda_material = @(location, state) 0.46+0.95*exp(-2.3e-3*(state.u-273)); 
  else 
    error('Unknow material type.');
  end

  if options.cavities_material.lambda == "dresser" 
    lambda_cavities = @(location, state) 0.35+0.85*exp(-1.7e-3*(state.u-273)); 
  elseif options.cavities_material.lambda == "hebei"
    lambda_cavities = @(location, state) 0.59+0.23*exp(-4.3e-4*(state.u-273)); 
  elseif options.cavities_material.lambda == "tholeiitic"
    lambda_cavities = @(location, state) 0.46+0.95*exp(-2.3e-3*(state.u-273)); 
  else 
    error('Unknow material type.');
  end

  thermalModel = createpde('thermal','transient');
  thermalModel.Geometry=geometry.structure;
  generateMesh(thermalModel,'Hmax',0.2,"GeometricOrder","quadratic");
  thermalModel.StefanBoltzmannConstant = 5.670373E-8;

  thermalProperties(thermalModel,"Cell",1,'ThermalConductivity',lambda_material, ...
      'MassDensity',options.material.rho, ...
      'SpecificHeat',specific_heat_material);
  thermalIC(thermalModel,options.material.T_0,"Cell",1);

  if strcmp(geometry.type, 'full')
    thermalProperties(thermalModel,"Cell",2:geometry.nbr_cavities+1, 'ThermalConductivity',lambda_cavities, ...
        'MassDensity',options.cavities_material.rho, ...
        'SpecificHeat',specific_heat_cavity);
    thermalIC(thermalModel,options.cavities_material.T_0,"Cell",2:geometry.nbr_cavities+1);
  end
  
  thermalBC(thermalModel,"Face",geometry.exposed_faces,"Emissivity",@(region,state) options.eps,"AmbientTemperature",options.T_out, "Vectorized","on");

  %% Solver
  Results = solve(thermalModel,tlist);
end