function geometry = modifyGeometry(previous_geometry, shape, unit, nbr_cavities, min_radius, max_radius)
    geometry.structure = previous_geometry;
    geometry.unit = unit;
    geometry.min_radius = min_radius;
    geometry.max_radius = max_radius;
    geometry.nbr_cavities = nbr_cavities;
    geometry.centers = [0,0,0];
    geometry.porous_volume = 0; 
    geometry.porosity_fraction = 0;
    geometry.radii = 0.1;
    if strcmp(shape, 'cube')
        geometry.volume = geometry.unit^3;
        geometry = tools.utils.digCube(geometry);
    elseif strcmp(shape, 'ellipsoid')
        geometry.volume = 4/3*pi*unit(1)*unit(2)*unit(3);
        geometry = tools.utils.digEllipsoid(geometry);
    else
        error("modifyGeometry : Invalid shape argument")
    end
end