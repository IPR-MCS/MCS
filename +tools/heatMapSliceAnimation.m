function heatMapSliceAnimation(filename,thermalResults,view_type,value)

% Parameters for figure customization
set(groot,'defaultAxesTickLabelInterpreter','latex'); 
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');


Mesh = thermalResults.Mesh;
x = linspace(min(Mesh.Nodes(1,:)), max(Mesh.Nodes(1,:)), 400);
y = linspace(min(Mesh.Nodes(2,:)), max(Mesh.Nodes(2,:)), 400);
z = linspace(min(Mesh.Nodes(3,:)), max(Mesh.Nodes(3,:)), 400); 

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
timestep = 5; % to accelerate rendering
Temp = interpolateTemperature(thermalResults, X, Y, Z, [1:size(thermalResults.SolutionTimes,2)]);

figure('Visible', 'off'); 
hold on; 
video = VideoWriter(filename);
video.FrameRate = 10; 
open(video);
for i = 1:timestep:size(thermalResults.SolutionTimes,2) 
    if view_type == 'x'
        TempInterp = interp2(y, z, reshape(Temp(:, i), size(Y)), Y, Z, 'bicubic');
        p = surf(Y, Z, TempInterp);
        xlabel("$y$ $(m)$");
        ylabel("$z$ $(m)$");
    elseif view_type == 'y'
        TempInterp = interp2(x, z, reshape(Temp(:, i), size(X)), X, Z, 'bicubic');
        p = surf(X, Z, TempInterp);
        xlabel("$x$ $(m)$");
        ylabel("$z$ $(m)$");
    elseif view_type == 'z'
        TempInterp = interp2(x, y, reshape(Temp(:, i), size(X)), X, Y, 'bicubic');
        p = surf(X, Y, TempInterp);
        xlabel("$x$ $(m)$");
        ylabel("$y$ $(m)$");
    end

    title(sprintf('t = %1.2f hours\n', thermalResults.SolutionTimes(i)/3600), 'FontSize', 16);
    view(0,90);
    shading interp; 
    colormap("jet");
    grid off; 
    clim([300,2000]);
    c = colorbar; 
    c.Label.Interpreter = 'latex';
    c.TickLabelInterpreter = 'latex';
    ylabel(c, 'T (K)', 'FontSize', 10, 'Interpreter', 'latex');
    c.Label.Position(1) = c.Label.Position(1) + 1;

    pause(0.01);
    frame = getframe(gcf);
    writeVideo(video, frame);
    if i < size(thermalResults.SolutionTimes,2)
        delete(p);
    end

end
close(video);
end