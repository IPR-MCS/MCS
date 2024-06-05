clear all; 
close all; 
warning off; 

%% Parameters

function intersect = spheresIntersect(center1, radius1, center2, radius2)
    distance = sqrt(sum((center1 - center2).^2));
    intersect = distance < (radius1 + radius2);
end

function generateRandomSimulation(filepath, nbr_cavities, minradius, maxradius)
  rho=2000;
  cp=1000;
  eps=1;              
  T_out=300;
  T_0=2000;
  dt=200;
  day=3600*24;
  tmax=6*day;
  tlist = [0:dt:tmax];
  %% Porous Geometry
  cube=multicuboid(2,2,2,'Zoffset',-1);
  
  % To avoid cavity located in center of geometry
  centers = [0,0,0];
  radii = [0.2];
  
  porous_volume = 0; 
  porosity_fraction = 0; 
  
  count = 0; 
  while count < nbr_cavities
    radius = randi([minradius,maxradius])/1000;
      x = (2-2*radius)*rand(1,1)-1+radius;
      y = (2-2*radius)*rand(1,1)-1+radius;
      z = (2-2*radius)*rand(1,1)-1+radius;
  
      valid = true; 
      for i=1:length(radii) 
          if spheresIntersect([x,y,z],radius,centers(i,:),radii(i)) 
             valid = false; 
             break; 
          end
      end
      
      if valid 
          radii = [radii, radius]; 
          centers = [centers; x, y, z]; 
          cavity = multisphere(radius);
          cavity = translate(cavity,[x y z]);
          cube = addVoid(cube,cavity);
          count = count+1; 
          porous_volume = porous_volume + 4/3*pi*radius^3;
          porosity_fraction = (porous_volume/(2^3))*100;
      end
  
  end

  thermalModel = createpde('thermal','transient');
  thermalModel.Geometry=cube;
  generateMesh(thermalModel,'Hmax',0.2,"GeometricOrder","quadratic");

  thermalModel.StefanBoltzmannConstant = 5.670373E-8;
  thermalProperties(thermalModel,'ThermalConductivity',2.857, ...
      'MassDensity',rho, ...
      'SpecificHeat',cp);
  thermalIC(thermalModel,T_0);
  thermalBC(thermalModel,"Face",7:count+6,"Temperature",T_out, "Vectorized","on");
  thermalBC(thermalModel,"Face",1:6,"Emissivity",@(region,state) eps,"AmbientTemperature",T_out, "Vectorized","on");

  %% Solver
  thermalResults = solve(thermalModel,tlist);
  Tcenter = interpolateTemperature(thermalResults,[0;0;0],1:numel(tlist));


  %% Time to get to Curie Temperature
  TCurie=858;
  [~,indice] = min(abs(Tcenter-TCurie));
  time_to_Curie = tlist(indice)/day;


  % Save
  save(filepath,'centers','count','indice','nbr_cavities','porosity_fraction','porous_volume',...
      'radii','Tcenter','time_to_Curie','tlist');
end

function generateSimulations(filepath,number_of_sim, mincavity, maxcavity, minradius, maxradius)
    % Generate and save random models under a "filepath" which must be configured as "Something{i}.mat" where i is the indice of the simulated object
    % Giving an example : generateSimulations('Sim%d.mat',1,5,10,200,500)
    for i = 1:1:number_of_sim
        generateRandomSimulation(sprintf(filepath,i),randi([mincavity, maxcavity]), minradius, maxradius);
    end
end