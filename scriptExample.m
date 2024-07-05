clear; 
close all; 
warning off; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Script Example %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a geometry
nbr_cavities=5;
geometry=tools.generateGeometry('ellipsoid',[1,0.5,0.5], nbr_cavities, 'full', 0.1, 0.3);
geometry.exposed_faces=1;

% Set properties of main and heterogeneous material:
% rho : density, cp : specific heat, T_0 : initial temperature, lambda : conductivity
% diffusivity D = lambda/(rho*cp)
% set cp to 8000 to have D/8 diffusivity for instance
basalt.rho=1000;
basalt.cp=1000;
basalt.T_0=2000; 
basalt.lambda="tholeiitic";  % choose "tholeiitic", "dresser", "hebei"
vaporised_basalt.rho=1000;
vaporised_basalt.cp=1000;
vaporised_basalt.T_0=2000;
vaporised_basalt.lambda="tholeiitic";  % choose "tholeiitic", "dresser", "hebei"

% Set parameters
options.material=basalt;
options.cavities_material=vaporised_basalt;
options.latent_heat=0;      % (J/kg) Latent heat of basalt = 4e5. Set to 0 for no-latent heat
options.T_latent=1373;        % (K) Crystallization temperature of basalt
options.eps=1;                % Emissivity
options.TCurie=858;           % (K) Curie temperature
options.T_out=300;            % (K) Outer space temperature
options.tmax=6*3600*24;       % (s) max integration time
options.dt=200;               % (s) time-step 

% Solve the transient heat transfer problem
simulation=Simulate(geometry, options);

% Temperature evolution at last point reaching Curie temperature
Result=tools.getThermalBarycenter(simulation, options.TCurie);
tempBar=interpolateTemperature(simulation,Result.Bar,1:numel(simulation.SolutionTimes));

% Save simulation results
results.simulation=simulation;
results.temperature = simulation.Temperature;
results.nodes = simulation.Mesh.Nodes;
results.tlist=simulation.SolutionTimes;
results.tempBar=tempBar;
results.bar=Result.Bar;
results.time=Result.Time/(3600*24);
results.nbr_cavities=geometry.nbr_cavities;
results.volume=geometry.volume;
results.porous_volume=geometry.porous_volume;
results.porosity_fraction=(results.porous_volume/results.volume)*100;
save('Example.mat','results');


% Plots
%tools.geometryView('Geometry.pdf', simulation, geometry);
%tools.isosurface("Animation.avi", simulation, options.TCurie);
%tools.heatMapSlice('Slice.pdf',simulation,'z',0);
%tools.heatMapSliceAnimation('SliceVideo.avi',simulation,'z',0);