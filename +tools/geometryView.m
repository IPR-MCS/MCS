function geometryView(filename, thermalResults, geometry)
    % Parameters for figure customization
    set(groot,'defaultAxesTickLabelInterpreter','latex'); 
    set(groot,'defaulttextinterpreter','latex');
    set(groot,'defaultLegendInterpreter','latex');
    
    tempFigure = figure('Visible', 'off');
    
    pdeplot3D(thermalResults.Mesh,ColorMapData=thermalResults.Temperature(:,end));
    title({sprintf("Solution plot at %0.2f days", thermalResults.SolutionTimes(end)/(24*3600)), " "}, 'FontSize', 15);
    exportgraphics(tempFigure, filename, 'ContentType', 'vector', 'Resolution', 700); 
    
    clf(tempFigure);
    
    pdegplot(geometry.structure, "FaceAlpha", 0.2);
    title({"Geometry representation", " "}, 'FontSize', 15);
    exportgraphics(tempFigure, filename, 'ContentType', 'vector', 'Resolution', 700, 'Append', true); 
    
    clf(tempFigure);
    
    pdemesh(thermalResults.Mesh);
    title({"Mesh representation", " "}, 'FontSize', 15);
    exportgraphics(tempFigure, filename, 'ContentType', 'vector', 'Resolution', 700, 'Append', true); 
    
end