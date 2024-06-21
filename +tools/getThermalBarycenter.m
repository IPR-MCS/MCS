function [Bar,Time] = getThermalBarycenter(thermalResults, Temperature)
    A=thermalResults.Temperature;
    lastPointIndex=-1;
    lastTimeIndex=-1;
    for t=size(A,2):-1:1
        pointIndices = find(A(:,t) >= Temperature);
        if ~isempty(pointIndices)
            lastPointIndex=pointIndices(1);
            lastTimeIndex=t;
            break;
        end
    end
    Bar = thermalResults.Mesh.Nodes(:,lastPointIndex);
    Time = thermalResults.SolutionTimes(1,lastTimeIndex);
end