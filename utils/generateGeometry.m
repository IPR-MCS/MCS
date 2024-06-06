function geometry = generateGeometry(nbr_cavities, minradius, maxradius)
    %% Generate a randomised porous cubic geometry
    geometry.structure=multicuboid(2,2,2,'Zoffset',-1);
    
    % To avoid cavity located in center of geometry
    geometry.centers = [0,0,0];
    geometry.radii = [0.2];
    geometry.porous_volume = 0; 
    geometry.porosity_fraction = 0;
    geometry.nbr_cavities = nbr_cavities;
    
    count = 0; 
    while count < nbr_cavities
      radius = randi([minradius,maxradius])/1000;
        x = (2-2*radius)*rand(1,1)-1+radius;
        y = (2-2*radius)*rand(1,1)-1+radius;
        z = (2-2*radius)*rand(1,1)-1+radius;
    
        valid = true; 
        for i=1:length(geometry.radii) 
            if spheresIntersect([x,y,z],radius,geometry.centers(i,:),geometry.radii(i)) 
               valid = false; 
               break; 
            end
        end
        
        if valid 
            geometry.radii = [geometry.radii, radius]; 
            geometry.centers = [geometry.centers; x, y, z]; 
            cavity = multisphere(radius);
            cavity = translate(cavity,[x y z]);
            geometry.structure = addVoid(geometry.structure,cavity);
            count = count+1; 
            geometry.porous_volume = geometry.porous_volume + 4/3*pi*radius^3;
            geometry.porosity_fraction = (geometry.porous_volume/(2^3))*100;
        end
    
    end
end

function intersect = spheresIntersect(center1, radius1, center2, radius2)
    distance = sqrt(sum((center1 - center2).^2));
    intersect = distance < (radius1 + radius2);
end