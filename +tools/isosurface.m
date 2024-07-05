function isosurface(filepath, thermalResults, temperature)
    %% Loading Data
    
    Mesh = thermalResults.Mesh; 
    
    %% Animation
    figure('Visible','off');

    % Export to video file
    video = VideoWriter(filepath);
    video.FrameRate = 10; 
    open(video);

    hold on;
    axis off
    pdeplot3D(Mesh.Nodes, Mesh.Elements, 'FaceAlpha', 0.1, 'EdgeColor', 'none');
    for t = 1:size(thermalResults.SolutionTimes,2)
        temp = thermalResults.Temperature(:, t);
        F = scatteredInterpolant(Mesh.Nodes(1,:)', Mesh.Nodes(2,:)', Mesh.Nodes(3,:)', temp, 'linear', 'none');
        [x, y, z] = meshgrid(linspace(min(Mesh.Nodes(1,:)), max(Mesh.Nodes(1,:)), 50), ...
            linspace(min(Mesh.Nodes(2,:)), max(Mesh.Nodes(2,:)), 50), ...
                linspace(min(Mesh.Nodes(3,:)), max(Mesh.Nodes(3,:)), 50));
                         
                v = F(x, y, z);
                axis equal 
        %axis vis3d  % rotate the 3D animation
        p = patch(isosurface(x, y, z, v, temperature));
        p.FaceColor = 'blue';
        p.EdgeColor = 'none'; 
        p.FaceAlpha = 0.2; % opacity
        view(3)
        colormap copper
        camlight; lighting phong;
        pause(0.1);
        frame = getframe(gcf);
        writeVideo(video, frame);
        if t < size(thermalResults.SolutionTimes,2)
            delete(p);
        end
    end
    close(video);
    hold off;