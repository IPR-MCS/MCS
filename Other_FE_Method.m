clear all; 
close all; 
warning off; 


%% Parameters
radius=1;           % (m) Droplet radius
%lam=2.857;          % (W/m/K) Thermal conductivity
rho=2000;           % (kg/m**3) Density
cp=1000;            % (J/kg/K) Specific heat
T0=2000;            % (K) Initial temperature
T_out=300;          % (K) outer space temperature

day=24*3600;    
tmax=6*day;
dt=2000;
tlist = [0:dt:tmax];
sig=5.670367e-8;    % (W/m**2/K**4) Stefan-Boltzmann constant
eps=1;              % Emissivity > 0.9 opaque material
k_SB=sig*3*eps/(rho*radius*cp);     % (1/s/K**3) coefficient of radiative heat transfer equation

bcTemp = @(region,state) -eps*sigma*(state.u.^4-T_out^4)*dt;  % Surface Temperature boundary condition


lam = @(location,state) (0.46+0.95*exp(-2.3e-3*(state.u-273)))*1e-6;




%% Thermal model
gm = multisphere(radius);
model = femodel(AnalysisType="thermalTransient", Geometry=gm);
model = generateMesh(model,Hmax=0.2);
model.StefanBoltzmann = 5.670367e-8;
model.MaterialProperties.ThermalConductivity = lam;
model.MaterialProperties.MassDensity=1;
model.MaterialProperties.SpecificHeat=1;
model.CellIC = cellIC(Temperature=T0);
model.FaceLoad(1) = faceLoad(AmbientTemperature=T_out, Emissivity=eps);



%faceLoad(AmbientTemperature=T_out, Emissivity=eps);
%faceLoad(Temperature=T_out, AmbientTemperature=T_out, Emissivity=eps);
%faceLoad(Temperature=bcTemp, AmbientTemperature=T_out, Emissivity=eps);


%% Mesh Figure
figure
pdemesh(model);
view(100,15)
title('Maillage');






%% Solver
R = solve(model,tlist);
Tmin = T0;
Tmax = max(R.Temperature(:,end));




%% Center Temperature Plot

Tcenter = interpolateTemperature(R,[0;0;0],1:numel(tlist));

figure; hold on; 
plot(R.SolutionTimes/day, Tcenter,'LineWidth',2);
ylim([200 2100]);
title({'Center Temperature', ' '});
xlabel('t (days)');
ylabel('Temperature (K)');
grid on; 
plot([0,tmax/day],[T_out,T_out],'r--','LineWidth',1);




%% Comparison

Tcenter_FD=load("Tcenter.txt");
Time_FD=load("Time.txt");

figure; hold on; 
plot(R.SolutionTimes/day, Tcenter,'LineWidth',2);
plot(Time_FD, Tcenter_FD,'LineWidth',2);
ylim([200 2100]);
title({'Center Temperature', ' '});
xlabel('t (days)');
ylabel('Temperature (K)');
grid on; 
plot([0,tmax/day],[300,300],'r--','LineWidth',1);
legend('Finite Element 3D', 'Finite Difference 1D', '');
