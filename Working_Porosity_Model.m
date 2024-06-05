clear all; 
close all; 
warning off; 

%% Parameters

function intersect = spheresIntersect(center1, radius1, center2, radius2)
    distance = sqrt(sum((center1 - center2).^2));
    intersect = distance < (radius1 + radius2);
end

function geometry = importGeometry(filepath)
    % Import structure geometry from a STL or a STEP file
    geometry = importGeometry(filepath);
end

function geometry = generateGeometry(nbr_cavities, minradius, maxradius)
  %% Generate a randomised porous cubic geometry
  geometry.structure=multicuboid(2,2,2,'Zoffset',-1);
  
  % To avoid cavity located in center of geometry
  geometry.centers = [0,0,0];
  geometry.radii = [0.2];
  geometry.porous_volume = 0; 
  geometry.porosity_fraction = 0;
  geometry.nbr_cavities = nbr_cavities;
  
  count = 0; 
  while count < nbr_cavities
    radius = randi([minradius,maxradius])/1000;
      x = (2-2*radius)*rand(1,1)-1+radius;
      y = (2-2*radius)*rand(1,1)-1+radius;
      z = (2-2*radius)*rand(1,1)-1+radius;
  
      valid = true; 
      for i=1:length(geometry.radii) 
          if spheresIntersect([x,y,z],radius,geometry.centers(i,:),geometry.radii(i)) 
             valid = false; 
             break; 
          end
      end
      
      if valid 
          geometry.radii = [geometry.radii, radius]; 
          geometry.centers = [geometry.centers; x, y, z]; 
          cavity = multisphere(radius);
          cavity = translate(cavity,[x y z]);
          geometry.structure = addVoid(geometry.structure,cavity);
          count = count+1; 
          geometry.porous_volume = geometry.porous_volume + 4/3*pi*radius^3;
          geometry.porosity_fraction = (geometry.porous_volume/(2^3))*100;
      end
  
  end
end

function simulation = Simulate(geometry)
  simulation.rho=2000;
  simulation.cp=1000;
  simulation.eps=1;
  simulation.TCurie=858;              
  simulation.T_out=300;
  simulation.T_0=2000;
  simulation.dt=200;
  simulation.tmax=6*3600*24;
  simulation.tlist = [0:simulation.dt:simulation.tmax];
  simulation.geometry = geometry;
  
  thermalModel = createpde('thermal','transient');
  thermalModel.Geometry=geometry.structure;
  generateMesh(thermalModel,'Hmax',0.2,"GeometricOrder","quadratic");

  thermalModel.StefanBoltzmannConstant = 5.670373E-8;
  thermalProperties(thermalModel,'ThermalConductivity',2.857, ...
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

function saveSimulation(filepath, simulation)
    save(filepath,'simulation');
end

function generateSimulations(filepath, number_of_sim, mincavity, maxcavity, minradius, maxradius)
    % Generate and save random models under a "filepath" which must be configured as "Something{i}.mat" where i is the indice of the simulated object
    % Giving an example : generatesimulations('Sim%d.mat',1,5,10,200,500)
    for i = 1:1:number_of_sim
        geometry = generateGeometry(randi([mincavity, maxcavity]), minradius, maxradius);
        simulation = Simulate(geometry);
        saveSimulation(sprintf(filepath,i), simulation)
    end
end