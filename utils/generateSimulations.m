function generateSimulations(filepath, number_of_sim, mincavity, maxcavity, minradius, maxradius)
    % Generate and save random models under a "filepath" which must be configured as "Something{i}.mat" where i is the indice of the simulated object
    % Giving an example : generateSimulations('Sim%d.mat',1,5,10,200,500)
    for i = 1:1:number_of_sim
        geometry = generateGeometry(randi([mincavity, maxcavity]), minradius, maxradius);
        simulation = Simulate(geometry);
        saveSimulation(sprintf(filepath,i), simulation)
    end
end

function saveSimulation(filepath, simulation)
    save(filepath,'simulation');
end