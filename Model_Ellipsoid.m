clear all; 
close all; 
warning off; 

%% Parameters
rho=1000;           % (kg/m**3) Density
cp=1000;            % (J/kg/K) Specific heat
T0=2000;            % (K) Initial temperature
T_out=300;          % (K) outer space temperature
eps=1;              % Emissivity
dt=200;             % (s) time-step
day=3600*24;
tmax=6*day;
tlist = [0:dt:tmax];


gm = importGeometry("Ellipsoid.stl");
figure; 
pdegplot(gm,FaceLabels="off",FaceAlpha=0.2)


%% Porosity

% Geometry
ellipsoid = importGeometry("Ellipsoid.stl");

% Semi-major axis
a = 1; b = 0.5; c = 0.5; 
ellipsoid_volume = 4/3*pi*a*b*c;

% To avoid cavity in center
centers = [0, 0, 0];
radii = [0.1];

porous_volume = 0;
porosity_fraction = 0;
count = 0;
nbr_cavities = 5; 
minradius = 100;
maxradius = 200; 

function intersect = spheresIntersect(center1, radius1, center2, radius2)
    distance = sqrt(sum((center1 - center2).^2));
    intersect = distance < (radius1 + radius2);
end


function inside = isInsideEllipsoid(x, y, z, a, b, c, radius)
    x_norm = abs(x) + radius;
    y_norm = abs(y) + radius;
    z_norm = abs(z) + radius;
    inside = (x_norm / a)^2 + (y_norm / b)^2 + (z_norm / c)^2 <= 1;
end


while count < nbr_cavities
    radius = randi([minradius,maxradius],1)/1000;
    
    valid = false;
    while ~valid
        x = 2*a*(rand(1,1)-0.5);
        y = 2*b*(rand(1,1)-0.5);
        z = 2*c*(rand(1,1)-0.5);
        if isInsideEllipsoid(x, y, z, a, b, c, radius)
            valid = true;
        end
    end
    
    for i = 1:length(radii)
        if spheresIntersect([x, y, z], radius, centers(i,:), radii(i))
            valid = false;
            break;
        end
    end
    
    if valid
        radii = [radii, radius];
        centers = [centers; x, y, z];
        
        cavity = multisphere(radius);
        cavity = translate(cavity, [x y z]);
        ellipsoid = addVoid(ellipsoid, cavity);
        
        count = count+1;
        porous_volume = porous_volume + 4/3*pi*radius^3;
        porosity_fraction = (porous_volume/ellipsoid_volume)*100;
    end
end
disp(['Ellipsoid volume: ', num2str(ellipsoid_volume), 'm**3']);
disp(['Porous volume: ', num2str(porous_volume), 'm**3']);
disp(['Porosity fraction: ', num2str(porosity_fraction), '%']);


figure; 
pdegplot(ellipsoid,FaceLabels="off",FaceAlpha=0.2)



%% Temperature dependent diffusivity

lambda = @(location,state) (0.46+0.95*exp(-2.3e-3*state.u)); 

%% Model 

thermalModel = createpde('thermal','transient');
thermalModel.Geometry=gm;
generateMesh(thermalModel,'Hmax',0.2,"GeometricOrder","quadratic");
thermalModel.StefanBoltzmannConstant = 5.670373E-8;
thermalIC(thermalModel,T0);

thermalProperties(thermalModel,'ThermalConductivity',lambda,'MassDensity',rho,'SpecificHeat',cp);

thermalBC(thermalModel,"Face",1,"Emissivity",@(region,state) eps,"AmbientTemperature",T_out, "Vectorized","on");
%thermalBC(thermalModel,"Face",2:nbr_cavities+1,"Temperature",1900, "Vectorized","on"); 

Vol = volume(thermalModel.Mesh);
mesh = thermalModel.Mesh;
numElements = size(mesh.Elements, 2);


%% Solver

tic; 
thermalResults = solve(thermalModel,tlist);
exec_time=toc;

% To solve in several steps : 
%
% chunkSize = 10; 
% numChunks = ceil(length(tlist) / chunkSize);
% thermalResults = [];
% for i = 1:numChunks
%     idxStart = (i-1)*chunkSize + 1;
%     idxEnd = min(i*chunkSize, length(tlist));
%     tlistChunk = tlist(idxStart:idxEnd);
%     thermalResultsChunk = solve(thermalModel, tlistChunk);
%     if isempty(thermalResults)
%         thermalResults = thermalResultsChunk;
%     else
%         thermalResults=[thermalResults, thermalResultsChunk];
%     end
%     fprintf('Completed chunk %d of %d\n', i, numChunks);
% end
% disp('Solving complete.');


%% Graph

Tcenter = interpolateTemperature(thermalResults,[0;0;0],1:numel(tlist));
figure; hold on; 
plot(thermalResults.SolutionTimes/day, Tcenter,'LineWidth',2);
ylim([200 2100]);
title({'Center Temperature, Non-Porous Ellipsoid', ' '});
xlabel('t (days)');
ylabel('Temperature (K)');
grid on; 
plot([0,tmax/day],[300,300],'r--','LineWidth',1);


%% Save
save('test.mat','ellipsoid','Results');
