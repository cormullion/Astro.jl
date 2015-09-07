export
    geodesic_distance,
    geographical_to_geocentric_lat

"""

    Computes the geodesic distance between two points on the Earth with a ~50 meters precision
    
    Parameters:
    L1, B1 : longitude and latitude of the first point (in radians)
    L2, B2 : longitude and latitude of the second point (in radians)
        
    Returns:
        distance in km

"""

function geodesic_distance(L1, B1, L2, B2)
    global earth_equ_radius, earth_flattening
    F = (B1+B2)/2
    G = (B1-B2)/2
    lambda = (L1-L2)/2
    sF = sin(F)
    cF = cos(F)
    sG = sin(G)
    cG = cos(G)
    sl = sin(lambda)
    cl = cos(lambda)
    
    S = sG*sG*cl*cl+cF*cF*sl*sl
    C = cG*cG*cl*cl+sF*sF*sl*sl
    
    omega = atan(sqrt(S/C))
    R = sqrt(S*C)/omega
    H1 = (3*R - 1)/2/C
    H2 = (3*R + 1)/2/S
    D  = 2*omega*earth_equ_radius
    
    return D * (1 + earth_flattening * (H1 * sF * sF * cG * cG - H2 * cF * cF * sG *sG))
end

"""
Convert geographical latitude to geocentric latitude
    
    [Meeus-1998: chapter 11]
    
    Parameters:
        phi : geographical latitude in radians
        H   : altitude of the observer above sea level
          
    Returns:
        phi1: geocentric latitude in radians
        rho*sin(phi1)
        rho*cos(phi1)

"""

function geographical_to_geocentric_lat(phi, H)
    global earth_flattening
    ratio = (1-earth_flattening)
    u = atan2(ratio*sin(phi), cos(phi))
    r = H/6378140
    rhosinphi1 = ratio*sin(u) + r*sin(phi)
    rhocosphi1 = cos(u) + r*cos(phi)
    phi1 = atan2(rhosinphi1, rhocosphi1)
    return (phi1, rhosinphi1, rhocosphi1)
end
