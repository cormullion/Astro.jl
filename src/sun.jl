export 
    aberration_low,
    apparent_longitude_low,
    equation_time,
    longitude_radius_low,
    rectangular_md,
    sun_dimension3

#=
Geocentric solar position and radius, low precision.
=#

#=
Return geocentric ecliptic longitude, latitude and radius.
        
        Parameters:
            jd : Julian Day in dynamical time

        Returns:
            longitude in radians
            latitude in radians
            radius in au

=#
function sun_dimension3(jd)
    (L, B, R) = vsop87d_dimension(jd, "Earth")
    return (mod2pi(L + pi), -B, R) # was return (L, B, R)
end

#
# Constant terms
#

_kL0 = {deg2rad(280.46646),  deg2rad(36000.76983),  deg2rad( 0.0003032)}
_kM  = {deg2rad(357.52911),  deg2rad(35999.05029),  deg2rad(-0.0001537)}
_kC  = {deg2rad(  1.914602), deg2rad(   -0.004817), deg2rad(-0.000014)}

_ck3 = deg2rad( 0.019993)
_ck4 = deg2rad(-0.000101)
_ck5 = deg2rad( 0.000289)

# Return geometric longitude and radius vector. 
# Low precision. The longitude is accurate to 0.01 degree. 
# The latitude should be presumed to be 0.0. [Meeus-1998: equations 25.2 through 
# 25.5, pages 165-166
#
#    Parameters:
#        jd : Julian Day in dynamical time
#
#    Returns:
#        longitude in radians
#        radius in au

function longitude_radius_low(jd)
    T = jd_to_jcent(jd) # julian centuries from J2000.0
    L0 = polynomial(_kL0, T) # geometric mean longitude of sun for mean equinox
    M = polynomial(_kM, T) # mean anomaly of sun
    e1 = polynomial({0.016708634, -0.000042037, -0.0000001267}, T) # eccentricity of Earth's orbit
    C = (polynomial(_kC, T) * sin(M))
        + ((_ck3 - _ck4 * T) * sin(2 * M))
        + (_ck5 * sin(3 * M)) # equation of the center
    L = mod2pi(L0 + C) # true longitude
    v = M + C # true anomaly
    R = 1.000001018 * (1 - e1 * e1) / (1 + e1 * cos(v)) # radius vector
    return (L, R)
end

# Constant terms

_lk0 = deg2rad(125.04)
_lk1 = deg2rad(1934.136)
_lk2 = deg2rad(0.00569)
_lk3 = deg2rad(0.00478)

# Correct the geometric longitude for nutation and aberration.   
#    Low precision. [Meeus-1998: pg 164]
#    
#    Parameters:
#        jd : Julian Day in dynamical time
#        L : longitude in radians
#    Returns:
#        corrected longitude in radians
#
function apparent_longitude_low(jd, L)
    T = jd_to_jcent(jd)
    omega = _lk0 - _lk1 * T
    return mod2pi(L - _lk2 - _lk3 * sin(omega))
end


# Constant terms

_lk4 = deg2rad(dms_to_d(0, 0, 20.4898))

# Correct for aberration; low precision, but good enough for most uses. 
#    
#    [Meeus-1998: pg 164]
#    
#    Parameters:
#        R : radius in au
#
#    Returns:
#        correction in radians
function aberration_low(R)
    return -_lk4 / R
end

#= 
    Returns the rectangular coordinates of the sun, relative to the mean equinox of the day

=#

function rectangular_md(jd)
    L, B, R = sun_dimension3(jd)
    L, B = vsop_to_fk5(jd, L, B)
    e1 = obliquity_high(jd)
    X = R * cos(B) * cos(L)
    Y = R * (cos(B)*sin(L)*cos(e1) - sin(B)*sin(e1))
    Z = R * (cos(B)*sin(L)*sin(e1) + sin(B)*cos(e1))
    return (X, Y, Z)
end

#=
    Returns the equation of time at JD
    parameters:
    	jd: julian day in dynamic time
    	
    Returns:
    	Equation of time in minutes, can be positive or negative
=#

function equation_time(jd)
    tau = jd_to_jcent(jd)/10
    _p = {280.4664567, 360007.6982779, 0.03032028, 1/49931, -1/15300, -1/2000000}
    L0 = mod2pi(deg2rad(polynomial(_p, tau)))
    (L, B, R)  = sun_dimension3(jd)
    (L, B)     = vsop_to_fk5(jd, L, B)	
    deltaPsi   = nut_in_lon(jd)
    epsilon    = true_obliquity(jd)
    asc,decl   = ecl_to_equ(L, B, epsilon)
    eqt = L0 - deg2rad(0.0057183) - asc + deltaPsi * cos(epsilon)
    if eqt > pi/2
        eqt = -((2 * pi) - eqt)
    end
    return eqt/(2 * pi) * 1440
end
