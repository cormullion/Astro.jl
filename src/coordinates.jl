export
    ecl_to_equ, 
    equ_to_ecl, 
    equ_to_horiz, 
    equ_to_horiz1, 
    geocentric_to_topocentric 

#=
ecl_to_equ(long, lat, obliquity)

Convert ecliptic to equatorial coordinates. 
    
    [Meeus-1998: equations 13.3, 13.4]
    
    Parameters:
        long : ecliptic longitude in radians
        lat : ecliptic latitude in radians
        obliquity : obliquity of the ecliptic in radians
    
    Returns:
        Right ascension in radians (2 pi is 24 hours)
        Declination in radians
=#

function ecl_to_equ(long, lat, obliquity)
    cose = cos(obliquity)
    sine = sin(obliquity)
    sinl = sin(long)
    x = cos(long)
    y = sinl * cose - tan(lat) * sine    
    alpha1 = atan2(y, x)
    ra = mod2pi(alpha1) 
    # convert to hours
    declin = asin(sin(lat) * cose + cos(lat) * sine * sinl)
    return (ra, declin)
end

#=
equ_to_horiz(H, decl)
Convert equatorial to horizontal coordinates.
    
    [Meeus-1998: equations 13.5, 13.6]

    Note that azimuth is measured westward starting from the south.
    
    This is not a good formula for using near the poles.
    
    Parameters:
        H : hour angle in radians
        decl : declination in radians
        
    Returns:
        azimuth in radians
        altitude in radians
=#

function equ_to_horiz(H, decl)
    global latitude
    cosH = cos(H)
    sinLat = sin(latitude) 
    cosLat = cos(latitude)
    alt = asin((sinLat * sin(decl)) + (cosLat * cos(decl) * cosH))
    
    # atan2(y,x)... not the other way round
    azi = atan2((-1 * cos(decl)) * cosLat * sin(H), sin(decl) - (sinLat * sin(alt)))
    
    # Duffett-Smith says if azi positive, true azimuth is (360 - azi)
    if sin(H) > 0
    azi = mod2pi(azi)
    end
    return (azi, alt)
end

#=
equ_to_ecl(ra, declin, obliquity)
Convert equatorial to ecliptic coordinates. 
    
    [Meeus-1998: equations 13.1, 13.2]
    
    Parameters:
        ra : right accension radians
        declin : declination in radians
        obliquity : obliquity of the ecliptic in radians
        
    Returns:
        ecliptic longitude in radians
        ecliptic latitude in radians
=#

function equ_to_ecl(ra, declin, obliquity)
    cose = cos(obliquity)
    sine = sin(obliquity)
    sina = sin(ra)
    long = mod2pi(atan2(sina * cose + tan(declin) * sine, cos(ra)))
    lat = mod2pi(asin(sin(declin) * cose - cos(declin) * sine * sina))
    return (long, lat)
end

#=
geocentric_to_topocentric(phi, H, L, ra, decl, d, jd)
Convert geocentric to topocentric coordinates. 
    
    [Meeus-1998: equations 40.2, 40.3]
    
    Parameters:
        phi: geocentric radius in radians
        H : observer's altitude (above sea level) in meters
        L ; observer longitude (in radians)
        ra : body right ascension
        decl : body declination in radians
        d : body distance (in AU)
        jd : observer's hour angle in radian
        
    Returns:
        topocentric right ascension in radians
        topocentric declination in radians
 =#

function geocentric_to_topocentric(phi, H, L, ra, decl, d, jd)
     sinparallax = sin(deg2rad(8.794/3600))/d
     ha    = mod2pi(apparent_sidereal_time_greenwich(jd) - L - deg2rad(ra* 15))
     (p1, psinp1, pcosp1) = geographical_to_geocentric_lat(phi, H)
     tmp   = cos(decl)-pcosp1*sinparallax*cos(ha)
     da    = atan2(-pcosp1*sinparallax*sin(ha), tmp)
     tdecl = atan2((sin(decl)-psinp1*sinparallax)*cos(da), tmp)
    return (ra+da, tdecl)
end
