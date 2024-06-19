function geometry = digCube(geometry)
    count = 0; 
    while count < geometry.nbr_cavities
        radius = geometry.min_radius+(geometry.max_radius-geometry.min_radius)*rand();
        x = (geometry.unit-2*radius)*rand(1)-geometry.unit/2+radius;
        y = (geometry.unit-2*radius)*rand(1)-geometry.unit/2+radius;
        z = (geometry.unit-2*radius)*rand(1)-geometry.unit/2+radius;
        valid = true; 
        for i=1:length(geometry.radii) 
            if tools.utils.spheresIntersect([x,y,z],radius,geometry.centers(i,:),geometry.radii(i)) 
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
            geometry.porosity_fraction = (geometry.porous_volume/geometry.volume)*100;
        end
    
    end
end