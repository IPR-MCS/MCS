clear; 
close all; 
warning off; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Script Example %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a geometry
nbr_cavities=5;
geometry=tools.generateGeometry('ellipsoid',[1,0.5,0.5], nbr_cavities, 0.1, 0.3);
geometry.exposed_faces=1;

% Plot the geometry
figure;
pdegplot(geometry.structure, "FaceAlpha",0.2, "CellLabels", "on");
delete(findobj(gca,'type','Text'));
delete(findobj(gca,'type','Quiver'));
axis off;

% Set properties of main and heterogeneous material
basalt.rho=1000;
basalt.cp=1000;
basalt.T_0=2000; 
vaporised_basalt.rho=1000;
vaporised_basalt.cp=1000;
vaporised_basalt.T_0=2000;

% Set parameters
options.material=basalt;
options.cavities_material=vaporised_basalt;
options.eps=1;            % Emissivity
options.TCurie=858;       % (K) Curie temperature
options.T_out=300;        % (K) Outer space temperature
options.tmax=6*3600*24;   % (s) max integration time
options.dt=200;           % (s) time-step 

% Solve the transient heat transfer problem
simulation=Simulate(geometry, options);

% Plot temperature evolution at specific node
[Bar, Time]=tools.getThermalBarycenter(simulation, options.TCurie);
tempBar=interpolateTemperature(simulation,Bar,1:numel(simulation.SolutionTimes));
figure; 
plot(simulation.SolutionTimes, tempBar, '-b');
xlabel("t (days)");
ylabel("T (K)");
title("Thermal evolution at last point reaching Curie temperature");
grid on; 

% Save simulation results
results.simulation=simulation;
results.tlist=simulation.SolutionTimes;
results.tempBar=tempBar;
results.bar=Bar;
results.nbr_cavities=geometry.nbr_cavities;
results.time=Time/(3600*24);
results.volume=geometry.volume;
results.porous_volume=geometry.porous_volume;
results.porosity_fraction=(results.porous_volume/results.volume)*100;
%save('Example.mat','results');

% Render Animations 
%tools.createAnimation("Animation.avi", simulation, options.TCurie);
%tools.heatMapSlice('Slice.pdf',simulation,'z',0);
%tools.heatMapSliceAnimation('SliceVideo.avi',simulation,'z',0);