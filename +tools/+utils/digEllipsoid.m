function geometry = digEllipsoid(geometry)
    count = 0;
    while count < geometry.nbr_cavities
        radius = geometry.min_radius+(geometry.max_radius-geometry.min_radius)*rand();       
        valid = false;
        while ~valid
            x = 2*geometry.unit(1)*(rand(1)-0.5);
            y = 2*geometry.unit(2)*(rand(1)-0.5);
            z = 2*geometry.unit(3)*(rand(1)-0.5);
            if isInsideEllipsoid(x, y, z, geometry.unit(1), geometry.unit(2), geometry.unit(3), radius)
                valid = true;
            end
        end
        
        for i = 1:length(geometry.radii)
            if tools.utils.spheresIntersect([x, y, z], radius, geometry.centers(i,:), geometry.radii(i))
                valid = false;
                break;
            end
        end
        
        if valid
            geometry.radii = [geometry.radii, radius];
            geometry.centers = [geometry.centers; x, y, z];
            
            cavity = multisphere(radius);
            cavity = translate(cavity, [x y z]);
            geometry.structure = addCell(geometry.structure, cavity);
            count = count+1;
            geometry.porous_volume = geometry.porous_volume + 4/3*pi*radius^3;
            geometry.porosity_fraction = (geometry.porous_volume/geometry.volume)*100;
        end
    end
end

function inside = isInsideEllipsoid(x, y, z, a, b, c, radius)
    x_norm = abs(x) + radius;
    y_norm = abs(y) + radius;
    z_norm = abs(z) + radius;
    inside = (x_norm / a)^2 + (y_norm / b)^2 + (z_norm / c)^2 <= 1;
end