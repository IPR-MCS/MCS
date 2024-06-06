clear all; close all; 


% Paramètres du modèle
radii = [1/3 2/3 1];  % Rayons
lam = 0.5;   % Conductivité thermique
rho = 1000;  % Densité de masse
cp = 1000;   % Chaleur spécifique
T0 = 2000;   % Température initiale
T_out = 300; % Température extérieure
eps = 1;     % Émissivité


model = createpde;
gm = importGeometry(model,"Torus.stl");
scale(gm, 0.01.*[1 1 1]);
rotate(gm, 180);
mesh = generateMesh(model, 'Hmax', 0.1, 'Hmin', 0.05); 


figure; 
pdegplot(model);
view(20,15)
axis off


figure
pdemesh(model);
%view(160,10)
view(20,15)
axis off