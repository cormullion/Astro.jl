export
    geocentric_planet, 
    planet_dimension, 
    vsop_to_fk5, 
    vsop87d_dimension,
    planet_data 
    
#=

    The VSOP87d planetary position model

    L is ecliptic longitude
    B is ecliptic latitude
    R is radius vector from sun

=#

# This global dict will contain any vsop planet data loaded from file...

global planet_data = (String => Any)[] 

function load_planet_data(planet) 
    # if data for planet hasn't been loaded before, load some from file
    global planet_data, dname

    datapath = join([dname, "/data/"])
    
    if !haskey(planet_data, planet)
        planet_data[planet] = include("$(datapath)/$(lowercase(planet))_vsop_data.jl")
        # println("loaded data")
    else
        # println("$planet data already loaded")
    end
    return planet_data[planet]
end

#=

    Return one of heliocentric ecliptic longitude, latitude and radius.
        [Meeus-1998: pg 218]
        
        Parameters:
            jd : Julian Day in dynamical time
            planet_data_dim: a slice of the data for L, B, or R

        Returns:
            longitude in radians, or
            latitude in radians, or
            radius in au
=#

function planet_dimension(jd, planet_data_dim)
    X = 0.0
    tauN = 1.0
    tau = jd_to_jcent(jd) / 10.0
    c = planet_data_dim
    for series in c
        seriesSum = 0
        for s in series
           (A, B, C) = s
           seriesSum = seriesSum + (A * cos(B + C * tau))
        end
        X = X + seriesSum * tauN
        tauN = tauN*tau # last one is wasted
    end
   
    return X 
end

#=

    Return heliocentric ecliptic longitude, latitude and radius.
        
        Parameters:
            jd : Julian Day in dynamical time
            planet : must be one of ("Mercury", "Venus", "Earth", "Mars", 
                "Jupiter", "Saturn", "Uranus", "Neptune")
            
        Returns:
            longitude in radians
            latitude in radians
            radius in au
=#

function vsop87d_dimension(jd, planet)
    planet_data = load_planet_data(planet)
    L = planet_dimension(jd, planet_data["L"])
    L = mod2pi(L)
    B = planet_dimension(jd, planet_data["B"])
    R = planet_dimension(jd, planet_data["R"])
    return (L, B, R)
end

# Constant terms

_k0 = deg2rad(-1.397)
_k1 = deg2rad(-0.00031)
_k2 = deg2rad(dms_to_d(0, 0, -0.09033))
_k3 = deg2rad(dms_to_d(0, 0,  0.03916))

#=   

    Convert VSOP to FK5 coordinates. 
    
    This is required only when using the full precision of the 
    VSOP model.
    
    [Meeus-1998: pg 219]
    
    Parameters:
        jd : Julian Day in dynamical time
        L : longitude in radians
        B : latitude in radians
        
    Returns:
        corrected longitude in radians
        corrected latitude in radians
=#
  
function vsop_to_fk5(jd, L, B)
    T = jd_to_jcent(jd)
    L1 = polynomial({L, _k0, _k1}, T)
    cosL1 = cos(L1)
    sinL1 = sin(L1)
    deltaL = _k2 + _k3 * (cosL1 + sinL1) * tan(B)
    deltaB = _k3 * (cosL1 - sinL1)
    return (mod2pi(L + deltaL), B + deltaB)
end

#=

    Calculate the equatorial coordinates of a planet
    
    The results will be geocentric, corrected for light-time and
    aberration.
    
    Parameters:
        jd : Julian Day in dynamical time
        planet : must be one of ("Mercury", "Venus", "Earth", "Mars", 
            "Jupiter", "Saturn", "Uranus", "Neptune")
        deltaPsi : nutation in longitude, in radians
        epsilon : True obliquity (corrected for nutation), in radians
        delta : desired accuracy, in days
        
    Returns:
        right accension, in radians
        declination, in radians
=#

function geocentric_planet(jd, planet, deltaPsi, epsilon, delta)
    t = jd
    l0 = -100.0 # impossible value
    # We need to iterate to correct for light-time and aberration.
    # At most three passes through the loop always nails it.
    # Note that we move both the Earth and the other planet during
    # the iteration.
    trial = 1
    for bailout = 1:20
    	# heliocentric geometric ecliptic coordinates of the Earth
        (L0, B0, R0) = vsop87d_dimension(t, "Earth")

        # heliocentric geometric ecliptic coordinates of the planet
        (L, B, R) = vsop87d_dimension(t, planet)

        # rectangular offset
        cosB0 = cos(B0)
        cosB = cos(B)
        x = R * cosB * cos(L) - R0 * cosB0 * cos(L0)
        y = R * cosB * sin(L) - R0 * cosB0 * sin(L0)
        z = R * sin(B)        - R0 * sin(B0)

        # geocentric geometric ecliptic coordinates of the planet
        x2 = x*x
        y2 = y*y
        l = atan2(y, x)
        b = atan2(z, sqrt(x2 + y2))

        # distance to planet in AU
        dist = sqrt(x2 + y2 + z*z)

        # light time in days
        tau = 0.0057755183 * dist

        if abs(diff_angle(l, l0)) < (pi * 2) * delta 
            break 
        end

        # adjust for light travel time and try again
        l0 = l
        t = jd - tau
    end
    if trial > 19
        error("Failed - too many tries")
    end

    # transform to FK5 ecliptic and equinox
    (l, b) = vsop_to_fk5(jd, l, b)

    # nutation in longitude
    l = l + deltaPsi

    # equatorial coordinates
    (ra, declin) = ecl_to_equ(l, b, epsilon)

    return (ra, declin)
end
