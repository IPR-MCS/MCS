function heatMapSlice(filename,thermalResults,view_type,value)

% Parameters for figure customization
set(groot,'defaultAxesTickLabelInterpreter','latex'); 
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');


Mesh = thermalResults.Mesh;
x = linspace(min(Mesh.Nodes(1,:)), max(Mesh.Nodes(1,:)), 200);
y = linspace(min(Mesh.Nodes(2,:)), max(Mesh.Nodes(2,:)), 200);
z = linspace(min(Mesh.Nodes(3,:)), max(Mesh.Nodes(3,:)), 200); 

if view_type == 'x' 
    [Y,Z] = meshgrid(y,z); 
    X = value*ones(size(Y));
elseif view_type == 'y'
    [X,Z] = meshgrid(x,z); 
    Y = value*ones(size(X));
elseif view_type == 'z'
    [X,Y] = meshgrid(x,y);
    Z = value*ones(size(X));
else 
    error('Invalid view type. Use ''z'', ''x'', or ''y''.');
end


day = 24*3600;
tIndex = [100, 300, 500, 700, 900, 1100];
Temp = interpolateTemperature(thermalResults, X, Y, Z, tIndex);

figure("Position",[10,10,1000,550]); 
hold on; 
for i = 1:numel(tIndex)
    subplot(2, 3, i)

    if view_type == 'x'
        TempInterp = interp2(y, z, reshape(Temp(:, i), size(Y)), Y, Z, 'bicubic');
        surf(Y, Z, TempInterp);
        xlabel("y (m)");
        ylabel("z (m)");
    elseif view_type == 'y'
        TempInterp = interp2(x, z, reshape(Temp(:, i), size(X)), X, Z, 'bicubic');
        surf(X, Z, TempInterp);
        xlabel("x (m)");
        ylabel("z (m)");
    elseif view_type == 'z'
        TempInterp = interp2(x, y, reshape(Temp(:, i), size(X)), X, Y, 'bicubic');
        surf(X, Y, TempInterp);
        xlabel("x (m)");
        ylabel("y (m)");
    end

    title(sprintf('t = %1.2f days', thermalResults.SolutionTimes(tIndex(i))/day));
    view(0,90);
    shading interp; 
    colormap("jet");
    grid off; 
    clim([300,2000]);
end
c = colorbar('Position', [0.93, 0.11, 0.02, 0.815]);
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';


% Save figure in file
set(gcf, 'PaperOrientation', 'landscape');
print(gcf, '-dpdf', '-r500', '-bestfit', filename);
end