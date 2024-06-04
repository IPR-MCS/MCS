clear all; 
close all; 
warning off; 

%% Parameters

function intersect = spheresIntersect(center1, radius1, center2, radius2)
    distance = sqrt(sum((center1 - center2).^2));
    intersect = distance < (radius1 + radius2);
end

function generateRandomSimulation(filepath, nbr_cavities, minradius, maxradius)
  radius=1;
  rho=200;
  cp=1000;
  sig=5.670367e-8;    
  eps=1;              
  k_SB=sig*3*eps/(rho*radius*cp);
  T_out=300;

  dt=2000;
  day=3600*24;
  tmax=6*day;
  tlist = [0:dt:tmax];

  bcTemp = @(location,state) -k_SB*(state.u.^4-T_out^4)*dt;

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

  % figure;
  % pdegplot(cube, "FaceLabels","off",'FaceAlpha', 0.5);
  % axis equal;

  cube.NumFaces

  %% PDE

  thermalModel = createpde('thermal','transient');
  thermalModel.Geometry=cube;
  generateMesh(thermalModel,'Hmax',0.2,"GeometricOrder","quadratic");

  thermalModel.StefanBoltzmannConstant = 5.670373E-8;
  thermalProperties(thermalModel,'ThermalConductivity',2.857, ...
      'MassDensity',2000, ...
      'SpecificHeat',1000);
  thermalIC(thermalModel,2000);
  thermalBC(thermalModel,"Face",[7:count+6],"Temperature",300, "Vectorized","on");
  thermalBC(thermalModel,"Face",1,"Emissivity",1,"AmbientTemperature",300, "Vectorized","on");



  %%
  thermalResults = solve(thermalModel,tlist);
  Tcenter = interpolateTemperature(thermalResults,[0;0;0],1:numel(tlist));

  % %% Graph
  % 
  % figure; hold on;
  % plot(thermalResults.SolutionTimes/day, Tcenter,'LineWidth',2);
  % ylim([200 2100]);
  % title({'Center Temperature', ' '});
  % xlabel('t (days)');
  % ylabel('Temperature (K)');
  % grid on;
  % plot([0,tmax/day],[300,300],'r--','LineWidth',1);
  % legend('Sphere', 'Cube', 'Torus', '');


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

% %% Comparison Radiation Condition
% 
% Tcenter_FD=load("Tcenter.txt");
% Time_FD=load("Time.txt");
% 
% figure; hold on; 
% plot(thermalResults.SolutionTimes/day, Tcenter,'LineWidth',2);
% plot(Time_FD, Tcenter_FD,'LineWidth',2);
% ylim([200 2100]);
% title({'Center Temperature', ' '});
% xlabel('t (days)');
% ylabel('Temperature (K)');
% grid on; 
% plot([0,tmax/day],[300,300],'r--','LineWidth',1);
% legend('Finite Element 3D', 'Finite Difference 1D', '');


% %% Comparison Dirichlet Condition
% 
% Tcenter_FD_Dir=load("Tcenter_Dir.txt");
% Time_FD_Dir=load("Time_Dir.txt");
% 
% figure; hold on; 
% plot(thermalResults.SolutionTimes/day, Tcenter,'LineWidth',2);
% plot(Time_FD_Dir, Tcenter_FD_Dir,'LineWidth',2);
% ylim([200 2100]);
% title({'Center Temperature', ' '});
% xlabel('t (days)');
% ylabel('Temperature (K)');
% grid on; 
% plot([0,tmax/day],[300,300],'r--','LineWidth',1);
% legend('Finite Element 3D', 'Finite Difference 1D', '');