export 
    moon_apogee_perigee_time_low, 
    moon_illuminated_fraction_high, 
    moon_illuminated_fraction_low, 
    lunation, 
    moon_mean_ascending_node_longitude, 
    moon_mean_perigee_longitude, 
    moon_altitude, 
    moon_constants, 
    moon_dimension, 
    moon_dimension3, 
    moon_horizontal_parallax, 
    moon_latitude, 
    moon_longitude, 
    moon_nearest_phase, 
    moon_radius, 
    moon_riseset, 
    moon_age_location, 
    moon_node, 
    moon_true_ascending_node_longitude,
    moon_rst_altitude

#=
Lunar position model ELP2000-82 of Chapront.

The resulting values are for the equinox of date and have been adjusted
for light-time.
        
This is the simplified version of Jean Meeus, _Astronomical Algorithms_, 
second edition, 1998, Willmann-Bell, Inc.

=#

# [Meeus-1998: table 47.A]
#
#    D, M, M1, F, l, r
 
moon_table_a = {
    [0,  0,  1,  0, 6288774, -20905355],
    [2,  0, -1,  0, 1274027,  -3699111],
    [2,  0,  0,  0,  658314,  -2955968],
    [0,  0,  2,  0,  213618,   -569925],
    [0,  1,  0,  0, -185116,     48888],
    [0,  0,  0,  2, -114332,     -3149],
    [2,  0, -2,  0,   58793,    246158],
    [2, -1, -1,  0,   57066,   -152138],
    [2,  0,  1,  0,   53322,   -170733],
    [2, -1,  0,  0,   45758,   -204586],
    [0,  1, -1,  0,  -40923,   -129620],
    [1,  0,  0,  0,  -34720,    108743],
    [0,  1,  1,  0,  -30383,    104755],
    [2,  0,  0, -2,   15327,     10321],
    [0,  0,  1,  2,  -12528,        0],
    [0,  0,  1, -2,   10980,     79661],
    [4,  0, -1,  0,   10675,    -34782],
    [0,  0,  3,  0,   10034,    -23210],
    [4,  0, -2,  0,    8548,    -21636],
    [2,  1, -1,  0,   -7888,     24208],
    [2,  1,  0,  0,   -6766,     30824],
    [1,  0, -1,  0,   -5163,     -8379],
    [1,  1,  0,  0,    4987,    -16675],
    [2, -1,  1,  0,    4036,    -12831],
    [2,  0,  2,  0,    3994,    -10445],
    [4,  0,  0,  0,    3861,    -11650],
    [2,  0, -3,  0,    3665,     14403],
    [0,  1, -2,  0,   -2689,     -7003],
    [2,  0, -1,  2,   -2602,        0],
    [2, -1, -2,  0,    2390,     10056],
    [1,  0,  1,  0,   -2348,      6322],
    [2, -2,  0,  0,    2236,     -9884],
    [0,  1,  2,  0,   -2120,      5751],
    [0,  2,  0,  0,   -2069,        0],
    [2, -2, -1,  0,    2048,     -4950],
    [2,  0,  1, -2,   -1773,      4130],
    [2,  0,  0,  2,   -1595,        0],
    [4, -1, -1,  0,    1215,     -3958],
    [0,  0,  2,  2,   -1110,        0],
    [3,  0, -1,  0,    -892,      3258],
    [2,  1,  1,  0,    -810,      2616],
    [4, -1, -2,  0,     759,     -1897],
    [0,  2, -1,  0,    -713,     -2117],
    [2,  2, -1,  0,    -700,      2354],
    [2,  1, -2,  0,     691,        0],
    [2, -1,  0, -2,     596,        0],
    [4,  0,  1,  0,     549,     -1423],
    [0,  0,  4,  0,     537,     -1117],
    [4, -1,  0,  0,     520,     -1571],
    [1,  0, -2,  0,    -487,     -1739],
    [2,  1,  0, -2,    -399,        0],
    [0,  0,  2, -2,    -381,     -4421],
    [1,  1,  1,  0,     351,        0],
    [3,  0, -2,  0,    -340,        0],
    [4,  0, -3,  0,     330,        0],
    [2, -1,  2,  0,     327,        0],
    [0,  2,  1,  0,    -323,      1165],
    [1,  1, -1,  0,     299,        0],
    [2,  0,  3,  0,     294,        0],
    [2,  0, -1, -2,       0,      8752]}

# [Meeus-1998: table 47.B]
#
#    D, M, M1, F, b
    
moon_table_b = {
    [0,  0,  0,  1, 5128122],
    [0,  0,  1,  1,  280602],
    [0,  0,  1, -1,  277693],
    [2,  0,  0, -1,  173237],
    [2,  0, -1,  1,   55413],
    [2,  0, -1, -1,   46271],
    [2,  0,  0,  1,   32573],
    [0,  0,  2,  1,   17198],
    [2,  0,  1, -1,    9266],
    [0,  0,  2, -1,    8822],
    [2, -1,  0, -1,    8216],
    [2,  0, -2, -1,    4324],
    [2,  0,  1,  1,    4200],
    [2,  1,  0, -1,   -3359],
    [2, -1, -1,  1,    2463],
    [2, -1,  0,  1,    2211],
    [2, -1, -1, -1,    2065],
    [0,  1, -1, -1,   -1870],
    [4,  0, -1, -1,    1828],
    [0,  1,  0,  1,   -1794],
    [0,  0,  0,  3,   -1749],
    [0,  1, -1,  1,   -1565],
    [1,  0,  0,  1,   -1491],
    [0,  1,  1,  1,   -1475],
    [0,  1,  1, -1,   -1410],
    [0,  1,  0, -1,   -1344],
    [1,  0,  0, -1,   -1335],
    [0,  0,  3,  1,    1107],
    [4,  0,  0, -1,    1021],
    [4,  0, -1,  1,     833],
    [0,  0,  1, -3,     777],
    [4,  0, -2,  1,     671],
    [2,  0,  0, -3,     607],
    [2,  0,  2, -1,     596],
    [2, -1,  1, -1,     491],
    [2,  0, -2,  1,    -451],
    [0,  0,  3, -1,     439],
    [2,  0,  2,  1,     422],
    [2,  0, -3, -1,     421],
    [2,  1, -1,  1,    -366],
    [2,  1,  0,  1,    -351],
    [4,  0,  0,  1,     331],
    [2, -1,  1,  1,     315],
    [2, -2,  0, -1,     302],
    [0,  0,  1,  3,    -283],
    [2,  1,  1, -1,    -229],
    [1,  1,  0, -1,     223],
    [1,  1,  0,  1,     223],
    [0,  1, -2, -1,    -220],
    [2,  1, -1, -1,    -220],
    [1,  0,  1,  1,    -185],
    [2, -1, -2, -1,     181],
    [0,  1,  2,  1,    -177],
    [4,  0, -2, -1,     176],
    [4, -1, -1, -1,     166],
    [1,  0,  1, -1,    -164],
    [4,  0,  1, -1,     132],
    [1,  0, -1, -1,    -119],
    [4, -1,  0, -1,     115],
    [2, -2,  0,  1,     107]}

# Meeus 47.6

function eccent_E(T)
    E = polynomial({1.0, -0.002516, -0.0000074}, T)
    E2 = E*E    
    return (E, E2)
end 

# Calculate values required by several other functions

function moon_constants(T)

    # Constant terms.
      
    _kL1 = [deg2rad(218.3164477), deg2rad(481267.88123421), deg2rad(-0.0015786), deg2rad( 1.0/  538841), deg2rad(-1.0/ 65194000)]
    _kD  = [deg2rad(297.8501921), deg2rad(445267.1114034),  deg2rad(-0.0018819), deg2rad( 1.0/  545868), deg2rad(-1.0/113065000)]
    _kM  = [deg2rad(357.5291092), deg2rad( 35999.0502909),  deg2rad(-0.0001536), deg2rad( 1.0/24490000)]
    _kM1 = [deg2rad(134.9633964), deg2rad(477198.8675055),  deg2rad( 0.0087414), deg2rad( 1.0/   69699), deg2rad(-1.0/ 14712000)]
    _kF  = [deg2rad( 93.2720950), deg2rad(483202.0175233),  deg2rad(-0.0036539), deg2rad(-1.0/ 3526000), deg2rad( 1.0/863310000)]

    _kA1 = [deg2rad(119.75), deg2rad(   131.849)]
    _kA2 = [deg2rad( 53.09), deg2rad(479264.290)]
    _kA3 = [deg2rad(313.45), deg2rad(481266.484)]

    L1 = mod2pi(polynomial(_kL1, T))
    D  = mod2pi(polynomial(_kD,  T))
    M  = mod2pi(polynomial(_kM,  T))
    M1 = mod2pi(polynomial(_kM1, T))
    F  = mod2pi(polynomial(_kF,  T))

    A1 = mod2pi(polynomial(_kA1, T))
    A2 = mod2pi(polynomial(_kA2, T))
    A3 = mod2pi(polynomial(_kA3, T))
    
    (E, E2) = eccent_E(T)
    
    return (L1, D, M, M1, F, A1, A2, A3, E, E2)
end

# ELP2000 lunar position calculations

#= 

Return geocentric ecliptic longitude, latitude and radius.
        
        When we need all three dimensions it is more efficient to combine the 
        calculations in one routine.
        
        Parameters:
            jd : Julian Day in dynamical time

        Returns:
            geocentric longitude in radians
            geocentric latitude in radians
            radius in km, Earth's center to Moon's center
 =#     

function moon_dimension3(jd::Float64)
    T = jd_to_jcent(jd)
    L1, D, M, M1, F, A1, A2, A3, E, E2 = moon_constants(T)

    # longitude and radius

    lsum = 0.0
    rsum = 0.0
    for v in moon_table_a
        (tD, tM, tM1, tF, tl, tr) = v
        arg = tD * D + tM * M + tM1 * M1 + tF * F
        if abs(tM) == 1 
            tl = tl*E
            tr = tr*E
        elseif abs(tM) == 2
            tl = tl*E2
            tr = tr*E2
        end
        lsum = lsum + tl * sin(arg)
        rsum = rsum + tr * cos(arg)
    end
    #
    # latitude
    #
    bsum = 0.0
    for v in moon_table_b
        (tD, tM, tM1, tF, tb) = v
        arg = tD * D + tM * M + tM1 * M1 + tF * F
        if abs(tM) == 1 
         tb = tb*E
        elseif abs(tM) == 2 
         tb = tb*E2
        end
        bsum = bsum + tb * sin(arg)
    end

    lsum = lsum + 3958 * sin(A1) +       
            1962 * sin(L1 - F) +   
             318 * sin(A2)

    bsum = bsum - 2235 * sin(L1) +      
            382 * sin(A3) +      
            175 * sin(A1 - F) +  
            175 * sin(A1 + F) +  
            127 * sin(L1 - M1) - 
            115 * sin(L1 + M1)
                 
    long = L1 + deg2rad(lsum / 1000000)    
    lat = deg2rad(bsum / 1000000)         
    dist = 385000.56 + rsum / 1000
    return (long, lat, dist)
end

#=

Return the geocentric ecliptic longitude in radians.       

A subset of the logic in moon_dimension3()

=#

function moon_longitude(jd::Float64)
    T = jd_to_jcent(jd)
    L1, D, M, M1, F, A1, A2, A3, E, E2 = moon_constants(T)
    lsum = 0.0
    for v in moon_table_a
        (tD, tM, tM1, tF, tl, tr) = v
        arg = tD * D + tM * M +tM1 * M1 + tF * F
        if abs(tM) == 1 
            tl = tl*E
        elseif abs(tM) == 2 
            tl = tl*E2
        end
        lsum = lsum + tl * sin(arg)
    end

    lsum = lsum + 3958 * sin(A1) +     
                  1962 * sin(L1 - F) + 
                   318 * sin(A2)

    longitude = L1 + deg2rad(lsum / 1000000)    
    return longitude
end

#=

Return the geocentric ecliptic latitude in radians.       
 A subset of the logic in moon_dimension3()

=#

function moon_latitude(jd::Float64)
    T = jd_to_jcent(jd)
    L1, D, M, M1, F, A1, A2, A3, E, E2 = moon_constants(T)

    bsum = 0.0
    for v in moon_table_b
        tD, tM, tM1, tF, tb = v
        arg = tD * D + tM * M + tM1 * M1 + tF * F
        if abs(tM) == 1 
            tb = tb*E
        elseif abs(tM) == 2 
            tb = tb*E2
        end
        bsum = bsum + tb * sin(arg)
    end

    bsum = bsum - 2235 * sin(L1) +      
                   382 * sin(A3) +      
                   175 * sin(A1 - F) +  
                   175 * sin(A1 + F) +  
                   127 * sin(L1 - M1) - 
                   115 * sin(L1 + M1)
          
    lat = deg2rad(bsum / 1000000)         
    return lat
end

#=

 Return the geocentric radius in km.

 A subset of the logic in moon_dimension3()

=#

function moon_radius(jd::Float64)
    T = jd_to_jcent(jd)
    (L1, D, M, M1, F, A1, A2, A3, E, E2) = moon_constants(T)

    rsum = 0.0
    for v in moon_table_a
        (tD, tM, tM1,tF, tl, tr) = v
        arg = tD * D + tM * M + tM1 * M1 + tF * F
        if abs(tM) == 1 
          tr = tr*E
        elseif abs(tM) == 2 
          tr = tr*E2
        end
        rsum = rsum + tr * cos(arg)
    end
    dist = 385000.56 + rsum / 1000
    return dist
end

#=

Return one of geocentric ecliptic longitude, latitude and radius.
        
        Parameters:
            jd : Julian Day in dynamical time
            dim : "L" (longitude") or "B" (latitude) or "R" (radius)

        Returns:
            longitude in radians or
            latitude in radians or
            radius in km, Earth's center to Moon's center
        
=#
    
function moon_dimension(jd::Float64, dim)
    if dim == "L" 
        return moon_longitude(jd) 
    end
    if dim == "B" 
        return moon_latitude(jd) 
    end
    if dim == "R" 
        return moon_radius(jd) 
    end
    error("unknown dimension = $dim")
end

#=    
    Simple moon phase calculator adapted from the basic program found at 
    http://www.skyandtelescope.com/resources/software/3304911.html.
    This function helps anyone who needs to know the Moon's 
    phase (age), distance, and position along the ecliptic on
    any date within several thousand years in the past or future.
    To illustrate its application, Bradley Schaefer applied it 
    to a number of famous events influenced by the Moon in 
    World War II.  His article appeared in Sky & Telescope for
    April 1994, page 86.

           Parameters:
                jd : Julian Day 
           Returns :
                moon's age from new in days
                distance from  anomalistic phase
                ecliptic latitude
                ecliptic longitude

=#

function moon_age_location(jd::Float64)
    v  = (jd - 2451550.1) / 29.530588853
    ip = v-ifloor(v)
    ag = ip * 29.530588853   # Moon's age from new moon in days
    ip = ip * (pi * 2)       # Converts to radian
    
    # Calculate distance from anomalistic phase
    v= (jd - 2451562.2) / 27.55454988
    dp = v-ifloor(v) 
    dp = dp * (pi * 2)
    di = 60.4-3.3 * cos(dp)-.6 * cos(2 * ip - dp) - .5 * cos(2 * ip)
    
    # Calculate ecliptic latitude from nodal (draconic) phase
    v = (jd - 2451565.2) /27.212220817
    np = v-ifloor(v)
    np = np * (pi * 2)
    la = 5.1*sin(np)
    
    # Calculate ecliptic longitude from sidereal motion
    v=(jd - 2451555.8) / 27.321582241
    rp = v - ifloor(v)
    lo = 360 * rp + 6.3 * sin(dp) + 1.3 * sin(2 * ip - dp) + .7 * sin(2 * ip)

    return (ag, di * earth_equ_radius, deg2rad(la), deg2rad(lo))
end

#=
    Find the Julian Date of the nearest moon phase (new, 1st quarter, full, last quarter) to the given Julian date.
           Parameters:
                jd : the required Julian Day in dynamical time
                phase: integer between 0 and 3: 0-> new moon, 1-> first quarter, 2-> full moon, 3-> second quarter
                  defaulting to 0, new moon
           Returns :
                the Julian Date for the type of moon phase asked
        
    [Meeus - chapter 49]
=#

function moon_nearest_phase(jd::Float64, phase=0)
     _kMean =   [2451550.09766,  29.530588861*1236.85,  0.00015437, -0.000000150, 0.00000000073]
     _kM    =   [      2.55340,  29.105356700*1236.85, -0.0000014,  -0.00000011]
     _kM1   =   [    201.56430, 385.816935280*1236.85,  0.0107582,   0.00001238, -0.000000058]
     _kF    =   [    160.7108,  390.670502848*1236.85, -0.0016118,  -0.00000227, -0.000000011]
     _kO    =   [    124.7746,   -1.563755880*1236.85,  0.0020672,  -0.00000215]
     _cor   =   { 
               [0.000325, [299.77,  0.107408*1236.85, -0.009173]],
               [0.000165, [251.88,  0.016321*1236.85]],
               [0.000164, [251.83, 26.651886*1236.85]],
               [0.000126, [349.42, 36.412478*1236.85]],
               [0.000110, [ 86.66, 18.206239*1236.85]],
               [0.000062, [141.74, 53.303771*1236.85]],
               [0.000060, [207.14,  2.453732*1236.85]],
               [0.000056, [154.84,  7.306860*1236.85]],
               [0.000047, [ 34.52, 27.261239*1236.85]],
               [0.000042, [207.19,  0.121824*1236.85]],
               [0.000040, [291.34,  1.844379*1236.85]],
               [0.000037, [161.72, 24.198154*1236.85]],
               [0.000035, [239.56, 25.513099*1236.85]],
               [0.000023, [331.55,  3.592518*1236.85]]
               }
    (yr, mo, d) = jd_to_cal(jd)
    n = cal_to_day_of_year(yr, mo, d)
    
    if is_leap_year(yr) 
        f = n/366 else f = n/365 
    end
    
    k = (yr+f-2000)*12.3685
    # Round to the nearest multiple of 0.25 according to the needed phase
    k = round(k-0.25*phase)+0.25*phase
    T = k/1236.85
    mean_phase = polynomial(_kMean, T)

    (E, E2) = eccent_E(T)
    # M, M1, F, O, new moon, full moon
    _nf_cor = {
               [ 0, 1, 0, 0, -0.40720,    -0.40614],
               [ 1, 0, 0, 0,  0.17241*E,   0.17302*E],
               [ 0, 2, 0, 0,  0.01608,     0.01614],
               [ 0, 0, 2, 0,  0.01039,     0.01043],
               [-1, 1, 0, 0,  0.00739*E,   0.00734*E],
               [ 1, 1, 0, 0, -0.00514*E,  -0.00515*E],
               [ 2, 0, 0, 0,  0.00208*E2,  0.00209*E2],
               [ 0, 1,-2, 0, -0.00111,    -0.00111],
               [ 0, 1, 2, 0, -0.00057,    -0.00057],
               [ 1, 2, 0, 0,  0.00056*E,   0.00056*E],
               [ 0, 3, 0, 0, -0.00042,    -0.00042],
               [ 1, 0, 2, 0,  0.00042*E,   0.00042*E],
               [ 1, 0,-2, 0,  0.00038*E,   0.00038*E],
               [-1, 2, 0, 0, -0.00024*E,  -0.00024*E],
               [ 0, 0, 0, 1, -0.00017,    -0.00017],
               [ 2, 1, 0, 0, -0.00007,    -0.00007],
               [ 0, 2,-2, 0,  0.00004,     0.00004],
               [ 3, 0, 0, 0,  0.00004,     0.00004],
               [ 1, 1,-2, 0,  0.00003,     0.00003],
               [ 0, 2, 2, 0,  0.00003,     0.00003],
               [ 1, 1, 2, 0, -0.00003,    -0.00003],
               [-1, 1, 2, 0,  0.00003,     0.00003],
               [-1, 1,-2, 0, -0.00002,    -0.00002],
               [ 1, 3, 0, 0, -0.00002,    -0.00002],
               [ 0, 4, 0, 0,  0.00002,     0.00002]
           }

    # M, M1, F, O, first and last quarters
    _qq_cor = {
               [ 0, 1, 0, 0, -0.62801],
               [ 1, 0, 0, 0,  0.17172*E],
               [ 1, 1, 0, 0, -0.01183*E],
               [ 0, 2, 0, 0,  0.00862],
               [ 0, 0, 2, 0,  0.00804],
               [-1, 1, 0, 0,  0.00454*E],
               [ 2, 0, 0, 0,  0.00204*E2],
               [ 0, 1,-2, 0, -0.00180],
               [ 0, 1, 2, 0, -0.00070],
               [ 0, 3, 0, 0, -0.00040],
               [-1, 2, 0, 0, -0.00034*E],
               [ 1, 0, 2, 0,  0.00032*E],
               [ 1, 0,-2, 0,  0.00032*E],
               [ 2, 1, 0, 0, -0.00028*E2],
               [ 1, 2, 0, 0,  0.00027*E],
               [ 0, 0, 0, 1, -0.00017],
               [-1, 1,-2, 0, -0.00005],
               [ 0, 2, 2, 0,  0.00004],
               [ 1, 1, 2, 0, -0.00004],
               [-2, 1, 0, 0,  0.00004],
               [ 1, 1,-2, 0,  0.00003],
               [ 3, 0, 0, 0,  0.00003],
               [ 0, 2,-2, 0,  0.00002],
               [-1, 1, 2, 0,  0.00002],
               [ 1, 3, 0, 0, -0.00002]
            }
    
    M  = mod2pi(deg2rad(polynomial(_kM,  T)))
    M1 = mod2pi(deg2rad(polynomial(_kM1, T)))
    F  = mod2pi(deg2rad(polynomial(_kF, T)))
    O  = mod2pi(deg2rad(polynomial(_kO, T)))

    if phase == 0 
    # New moon
        for (kM, kM1, kF, kO, coefn) in _nf_cor
           s = sin(kM*M+kM1*M1+kF*F+kO*O)
           mean_phase = mean_phase + s*coefn
      end
    end

    if phase == 2 
    # Full moon
        for (kM, kM1, kF, kO, coefn, coeff) in _nf_cor
           s = sin(kM*M+kM1*M1+kF*F+kO*O)
           mean_phase = mean_phase + s*coeff
        end
    end
    
    if phase == 1 || phase == 3 
    # first or last quarters
        for (kM, kM1, kF, kO, coef) in _qq_cor
           s = sin(kM*M+kM1*M1+kF*F+kO*O)
           mean_phase = mean_phase + s*coef
        end
        
        W =  0.00306 
         - 0.00038*E*cos(M) 
                + 0.00026*cos(M1)
                - 0.00002*cos(M1-M)
                + 0.00002*cos(M1+M)
                + 0.00002*cos(2*F)
        if phase == 3 
            W = -W 
        end
        mean_phase = mean_phase +W
    end
    
    for (c, poly) in _cor
        mean_phase = mean_phase + c * sin(mod2pi(deg2rad(polynomial(poly, T))))
    end
    return mean_phase
end

#=
    Compute the moon illuminated fraction and position's angle of the moon's bright limb

    Parameters:
                jd : Julian Day in dynamical time

    Returns :
                f, a (fraction, angle)
        
    [Meeus - chapter 48 or 49 depending on edition]
=#

function moon_illuminated_fraction_high(jd::Float64)
    (lambda, bbeta, delta) = moon_dimension3(jd)  # Moon's geocentric longitude, latitude and radius
    (lambda0, bbeta0, R)   = sun_dimension3(jd)   # Sun's geocentric longitude, latitude and radius
    
    R = R * km_per_au
    psi = acos(cos(bbeta) * cos(lambda - lambda0))
    i = atan2(R * sin(psi), delta - R * cos(psi))
    k = (1+cos(i))/2
    
    o = true_obliquity(jd)
    (asc,  decl)  = ecl_to_equ(lambda, bbeta, o)
    (asc0, decl0) = ecl_to_equ(lambda0, bbeta0, o)
    khi = atan2(cos(decl0) * sin(asc0 - asc), sin(decl0) * cos(decl) - cos(decl0) * sin(decl) * cos(asc0 - asc))
    return (k, mod2pi(khi))
end

#=
    Same as above - lower precision. Simpler algorithm. Does not return the angle of the bright limb
=#

function moon_illuminated_fraction_low(jd::Float64)
    T = jd_to_jcent(jd)
    (L1, D, M, M1) = moon_constants(T)
    
    i = (180 - rad2deg(D) 
            - 6.289*sin(M1)
            + 2.100 * sin(M)
            - 1.274 * sin(2 * D - M1)
            - 0.658 * sin(2 * D)
            - 0.214 * sin(2 * M1)
            - 0.110 * sin(D))
    k = (1 + cos(deg2rad(i)))/2
    return (round(k, 2))
end
#=
    Returns the longitude of the mean ascending node and of the mean perigee of the moon
    Parameters:
        jd: Julian day (dynamical time)
        
    Returns
        mean ascending node or mean perigee longitude in radians

=#

function moon_mean_ascending_node_longitude(jd)
    _O = {125.0445479, -1934.1362891, 0.0020754, 1/467441, -1/60616000}
    T = jd_to_jcent(jd)
    return mod2pi(deg2rad(polynomial(_O, T)))
end

function moon_true_ascending_node_longitude(jd::Float64)
    m = moon_mean_ascending_node_longitude(jd)
    T = jd_to_jcent(jd)
    (L1, D, M, M1, F) = moon_constants(T)
    return mod2pi(
          - deg2rad(1.4979)*sin(2*(D-F))
          - deg2rad(0.1500)*sin(M)
          - deg2rad(0.1226)*sin(2*D)
          + deg2rad(0.1176)*sin(2*F)
          - deg2rad(0.0801)*sin(2*(M1-F))
          + m)
end

function moon_mean_perigee_longitude(jd::Float64)
    _P = {83.3532465, 4096.0137287, -0.01032, -1/80053, -1/189999000}
    T = jd_to_jcent(jd)
    return mod2pi(deg2rad(polynomial(_P, T)))
end

#=

    Returns the jd for apogee of perigee, and the corresponding equatorial horizontal parallax
    Parameters:
        jd: Julian day (dynamical time)
        apo_nperi : 1 for an apogee, 0 for a perigee
        
    Returns
        jd for apogee or perigee
        parallax in seconds

=#

function moon_apogee_perigee_time_low(jd::Float64, apo_nperi)
    (yr, mo, d) = jd_to_cal(jd)
    n = cal_to_day_of_year(yr, mo, d)
    if is_leap_year(yr) 
        f = n/366 
    else
        f = n/365 
    end
    k = (yr + f - 1999.97) * 13.2555
    # Round to the nearest multiple of 0.5 according to apogee or perigee
    k = round(k - 0.5 * apo_nperi) + 0.5 * apo_nperi

    T = k/1325.55
    # k = T*1325.55 
    _mT = [ 2451534.6698,  27.55454989*1325.55, -0.0006691, -0.0000001098, 0.0000000052]
    _mD = [ 171.9179,     335.91060460*1325.55, -0.0100383, -0.00001156,   0.000000055]
    _mM = [ 347.3477,      27.15777210*1325.55, -0.0008130, -0.0000010 ]
    _mF = [ 316.6109,     364.52879110*1325.55, -0.0125053, -0.0000148 ]
    # D, M, F, coef - for apogee
    _mA = { 
         [ 2, 0, 0,  0.4392 ],
         [ 4, 0, 0,  0.0684 ],
         [ 0, 1, 0,  0.0456-0.00011*T ],
         [ 2,-1, 0,  0.0426-0.00011*T ],
         [ 0, 0, 2,  0.0212 ],
         [ 1, 0, 0, -0.0189 ],
         [ 6, 0, 0,  0.0144 ],
         [ 4,-1, 0,  0.0113 ],
         [ 2, 0, 2,  0.0047 ],
         [ 1, 1, 0,  0.0036 ],
         [ 8, 0, 0,  0.0035 ],
         [ 6,-1, 0,  0.0034 ],
         [ 2, 0,-2, -0.0034 ],
         [ 2,-2, 0,  0.0022 ],
         [ 3, 0, 0, -0.0017 ],
         [ 4, 0, 2,  0.0013 ],
         [ 8,-1, 0,  0.0011 ],
         [ 4,-2, 0,  0.0010 ],
         [10, 0, 0,  0.0009 ],
         [ 3, 1, 0,  0.0007 ],
         [ 0, 2, 0,  0.0006 ],
         [ 2, 1, 0,  0.0005 ],
         [ 2, 2, 0,  0.0005 ],
         [ 6, 0, 2,  0.0004 ],
         [ 6,-2, 0,  0.0004 ],
         [10,-1, 0,  0.0004 ],
         [ 5, 0, 0, -0.0004 ],
         [ 4, 0,-2, -0.0004 ],
         [ 0, 1, 2,  0.0003 ],
         [12, 0, 0,  0.0003 ],
         [ 2,-1, 2,  0.0003 ],
         [ 1,-1, 0, -0.0003 ]
         }
    # D, M, F, coef - for perigee
    _mP = { 
           [ 2, 0, 0, -1.6769 ],
           [ 4, 0, 0,  0.4589 ],
           [ 6, 0, 0, -0.1856 ],
           [ 8, 0, 0,  0.0883 ],
           [ 2,-1, 0, -0.0773 + 0.00019*T ],
           [ 0, 1, 0,  0.0502 - 0.00013*T ],
           [10, 0, 0, -0.0460 ],
           [ 4,-1, 0,  0.0422 - 0.00011*T ],
           [ 6,-1, 0, -0.0256 ],
           [12, 0, 0,  0.0253 ],
           [ 1, 0, 0,  0.0237 ],
           [ 8,-1, 0,  0.0162 ],
           [14, 0, 0, -0.0145 ],
           [ 0, 0, 2,  0.0129 ],
           [ 3, 0, 0, -0.0112 ],
           [10,-1, 0, -0.0104 ],
           [16, 0, 0,  0.0086 ],
           [12,-1, 0,  0.0069 ],
           [ 5, 0, 0,  0.0066 ],
           [ 2, 0, 2, -0.0053 ],
           [18, 0, 0, -0.0052 ],
           [14,-1, 0, -0.0046 ],
           [ 7, 0, 0, -0.0041 ],
           [ 2, 1, 0,  0.0040 ],
           [20, 0, 0,  0.0032 ],
           [ 1, 1, 0, -0.0032 ],
           [16,-1, 0,  0.0031 ],
           [ 4, 1, 0, -0.0029 ],
           [ 9, 0, 0,  0.0027 ],
           [ 4, 0, 2,  0.0027 ],
           [ 2,-2, 0, -0.0027 ],
           [ 4,-2, 0,  0.0024 ],
           [ 6,-2, 0, -0.0021 ],
           [22, 0, 0, -0.0021 ],
           [18,-1, 0, -0.0021 ],
           [ 6, 1, 0,  0.0019 ],
           [11, 0, 0, -0.0018 ],
           [ 8, 1, 0, -0.0014 ],
           [ 4, 0,-2, -0.0014 ],
           [ 6, 0 ,2, -0.0014 ],
           [ 3, 1, 0,  0.0014 ],
           [ 5, 1, 0, -0.0014 ],
           [13, 0, 0,  0.0013 ],
           [20,-1, 0,  0.0013 ],
           [ 3, 2, 0,  0.0011 ],
           [ 4,-2, 2, -0.0011 ],
           [ 1, 2, 0, -0.0010 ],
           [22,-1, 0, -0.0009 ],
           [ 0, 0, 4, -0.0008 ],
           [ 6, 0,-2,  0.0008 ],
           [ 2, 1,-2,  0.0008 ],
           [ 0, 2, 0,  0.0007 ],
           [ 0,-1, 2,  0.0007 ],
           [ 2, 0, 4,  0.0007 ],
           [ 0,-2, 2, -0.0006 ],
           [ 2, 2,-2, -0.0006 ],
           [24, 0, 0,  0.0006 ],
           [ 4, 0,-4,  0.0005 ],
           [ 2, 2, 0,  0.0005 ],
           [ 1,-1, 0, -0.0004 ]
        }

    _pA =  {
           [ 2, 0, 0, -9.147 ],
           [ 1, 0, 0, -0.841 ],
           [ 0, 0, 2,  0.697 ],
           [ 0, 1, 0, -0.656 + 0.0016*T ],
           [ 4, 0, 0,  0.355 ],
           [ 2,-1, 0,  0.159 ],
           [ 1, 1, 0,  0.127 ],
           [ 4,-1, 0,  0.065 ],
           [ 6, 0, 0,  0.052 ],
           [ 2, 1, 0,  0.043 ],
           [ 2, 0, 2,  0.031 ],
           [ 2, 0,-2, -0.023 ],
           [ 2,-2, 0,  0.022 ],
           [ 2, 2, 0,  0.019 ],
           [ 0, 2, 0, -0.016 ],
           [ 6,-1, 0,  0.014 ],
           [ 8, 0, 0,  0.010 ]}
                
    _pP =  {
           [ 2, 0, 0, 63.224 ],
           [ 4, 0, 0, -6.990 ],
           [ 2,-1, 0,  2.834-0.0071*T ],
           [ 6, 0, 0,  1.927 ],
           [ 1, 0, 0, -1.263 ],
           [ 8, 0, 0, -0.702 ],
           [ 0, 1, 0,  0.696-0.0017*T ],
           [ 0, 0, 2, -0,690 ],
           [ 4,-1, 0, -0.629+0.0016*T ],
           [ 2, 0, 2, -0.392 ],
           [10, 0, 0,  0.297 ],
           [ 6,-1, 0,  0.260 ],
           [ 3, 0, 0,  0.201 ],
           [ 2, 1, 0, -0.161 ],
           [ 1, 1, 0,  0.157 ],
           [12, 0, 0, -0.138 ],
           [ 8,-1, 0, -0.127 ],
           [ 2, 0,-2,  0.104 ],
           [ 5, 0, 0, -0.079 ],
           [14, 0, 0,  0.068 ],
           [10,-1, 0,  0.067 ],
           [ 4, 1, 0,  0.054 ],
           [12,-1, 0, -0.038 ],
           [ 4,-2, 0, -0.038 ],
           [ 7, 0, 0,  0.037 ],
           [ 4, 0, 2, -0.037 ],
           [16, 0, 0, -0.035 ],
           [ 3, 1, 0, -0.030 ],
           [ 1,-1, 0,  0.029 ],
           [ 6, 1, 0, -0.025 ],
           [ 0, 2, 0,  0.023 ],
           [14,-1, 0,  0.023 ],
           [ 2, 2, 0, -0.023 ],
           [ 6,-2, 0,  0.022 ],
           [ 2,-1,-2, -0.021 ],
           [ 9, 0, 0, -0.020 ],
           [18, 0, 0,  0.019 ],
           [ 6, 0, 2,  0.017 ],
           [ 0,-1, 2,  0.014 ],
           [16,-1, 0, -0.014 ],
           [ 4, 0,-2,  0.013 ],
           [ 8, 1, 0,  0.012 ],
           [11, 0, 0,  0.011 ],
           [ 5, 1, 0,  0.010 ],
           [20, 0, 0, -0.010 ]}                
    
    mean_pa = polynomial(_mT, T)
    D = polynomial(_mD, T)
    M = polynomial(_mM, T)
    F = polynomial(_mF, T)

    if apo_nperi == 1 
        _m = _mA
        _p = _pA
        parallax = 3245.251 # In arcseconds: 3245".251 according to Meeus table 50.B
    else 
        _m = _mP
        _p = _pP
        parallax = 3629.215  # 3629".215 according to Meeus table 50.B
    end
    
    c = 0
    for (aD, aM, aF, coef) in _m
        c = c+coef*sin(deg2rad(aD*D+aM*M+aF*F))
    end
    mean_pa = mean_pa + c
    
    for (pD, pM, pF, coef) in _p
        parallax = parallax + coef * cos(deg2rad(pD * D + pM * M + pF * F))
    end
    
    return (round(mean_pa, 4), round(parallax, 3))
end

function moon_horizontal_parallax(jd::Float64)
    R = moon_dimension(jd, "R")
    return asin(deg2rad(earth_equ_radius/R))
end

#=

    Passage of the moon through the nodes
    Parameter
        - jd: julian date
        - desc_not_asc: 0 for the ascending node, 1 for the descending node
    Returns
        - julian day of the closer passage through the node

=#

function moon_node(jd::Float64, desc_not_asc)
    (yr, mo, d) = jd_to_cal(jd)
    n = cal_to_day_of_year(yr, mo, d)
    if is_leap_year(yr) 
        f = n/366 
    else 
        f = n/365 
    end
    k = (yr + f - 2000.05) * 13.4223
    # Round to the nearest multiple of 0.5 according to ascending or descending node
    k = round(k - 0.5 * desc_not_asc) + 0.5 * desc_not_asc
    T = k/1342.33
    # k = T*1342.33 ? 
    _mD  = [183.6380, 331.73735682*1342.33, 0.0014852, 0.00000209, -0.00000001  ]
    _mM  = [ 17.4006,  26.82037250*1342.33, 0.0001186, 0.00000006              ]
    _mM1 = [ 38.3776, 355.52747313*1342.33, 0.0123499, 0.000014627,-0.000000069 ]
    _mO  = [123.9767,  -1.44098956*1342.33, 0.0020608, 0.00000214, -0.000000016 ]
    _mV  = [299.7500, 132.85,             -0.009173                         ]
    D =  polynomial(_mD, T)
    M =  polynomial(_mM, T)
    M1 = polynomial(_mM1, T)
    O =  polynomial(_mO, T)
    V =  polynomial(_mV, T)
    P =  O + 272.75 - 2.3 * T

    E, E2 = eccent_E(T)
    
    _mN = {
        [ 0, 0, 1, -0.4721  ],
        [ 2, 0, 0, -0.1649  ],
        [ 2, 0,-1, -0.0868  ],
        [ 2, 0, 1,  0.0084  ],
        [ 2,-1, 0, -0.0083*E],
        [ 2,-1,-1, -0.0039*E],
        [ 0, 0 ,2,  0.0034  ],
        [ 2, 0,-2, -0.0031  ],
        [ 2, 1, 0,  0.0030*E],
        [ 0, 1,-1,  0.0028*E],
        [ 0, 1, 0,  0.0026*E],
        [ 4, 0, 0,  0.0025  ],
        [ 1, 0, 0,  0.0024  ],
        [ 0, 1, 1,  0.0022*E],
        [ 4, 0,-1,  0.0014  ],
        [ 2, 1,-1,  0.0005*E],
        [ 2,-1, 1,  0.0004*E],
        [ 2,-2, 0, -0.0003*E],
        [ 4,-1, 0,  0.0003*E]
    }
    
    node = polynomial( {2451565.1619, 27.212220817 * 1342.33, 0.0002762, 0.000000021, -0.000000000088}, T )
    node = node + 0.0017 * sin(deg2rad(O)) + 0.0003 * sin(deg2rad(V)) + 0.0003 * sin(deg2rad(P))
    
    for (nD, nM, nM1, coef) in _mN
        c = coef * sin(deg2rad(nD * D + nM * M+ nM1 * M1))
        node = node + c
    end
    return node
end

#=

    Returns the lunation number
        Parameters
           - JD julian date (DT or UTC)
           - System can be "brown" (from the first 1923 new moon), "meeus" ( from the first 2000 new moon)
              "islamic" (from the beginning of islamic calendar) or "goldstein" (Goldstein system)
        Returns
           - The lunation number
=#

function lunation(jd::Float64, system=false)
    if system == false 
        system = "brown" 
    end
    # moon_nearest_phase will not always return the closest full moon if we are close to a new moon.
    # So we take the next and previous full moon, as well as the new moon in between, and determine
    # the lunation from these three values
    jdf1 = moon_nearest_phase(jd, 2) # Full moon preceding or following jd
    if jdf1 <= jd 
        # jdf1 is the previous full moon
        jdf2 = moon_nearest_phase(jdf1 + 29, 2) # jdf2 is the next full moon
    else
        jdf2 = moon_nearest_phase(jdf1 - 29, 2)
        (jdf1, jdf2) = (jdf2, jdf1)
    end
    # now jdf1 is the previous full moon, and jdf2 the next. Find the new moon between jdf1 and jdf2
    jdn = moon_nearest_phase(jdf1 + 14, 0)
    # Compute n in the brown system
    if jd < jdn 
        n = ceil((jdf1 - 2423436.6120014)/29.53058853)
    else
        n = ceil((jdf2 - 2423436.6120014)/29.53058853)
    end

    if system == "brown"     
        return n 
    end
    if system == "meeus"     
        return n - 953 
    end
    if system == "islamic"   
        return n + 17038 
    end
    if system == "goldstein" 
        return n + 37105 
    end
    error("unknown lunation system")
end

#=

    Returns the moon's altitude at time JD 
        Parameters
           - JD julian date
        Returns
           - altitude in radians

=#

function moon_altitude(jd::Float64)
    (l, b, r)   = moon_dimension3(jd) # geocentric longitude in radians, geocentric latitude in radians, radius in km
    o           = true_obliquity(jd)
    (ra, de)    = ecl_to_equ(l, b, o)
    H           = apparent_sidereal_time_greenwich(jd) - longitude - ra
    (A, h)      = equ_to_horiz(H, de) # azi/alt
    # h = h + 0.7275 * moon_horizontal_parallax(jd) - deg2rad(34/60) -- Semi-diameter of the moon
    # TODO moon_altitude() - add effect of atmospheric refraction
    return h
end

# Rising and setting time of the moon for julian day JD
# TODO moon_riseset() get this function working
# TODO moon_riseset() why does this return k
# TODO moon_riseset() document this function

function moon_riseset(jd::Float64)
    (moonrise, moonset, k, nsteps, uroot) = (false, false, 0, 24, false)
    (jd_list, v_list) = ({0, 1, 2}, {0,0,0})
    
    for (i, v) in enumerate(jd_list)
        v_list[i] = moon_altitude(jd + v/nsteps) 
    end

    for i in 1:nsteps
        (a, b, c) = quadratic_interpolation(jd_list, v_list)
        s1, s2 = quadratic_roots(a, b, c)
                 
        if s2 == false || s1 == false  
            uroot = true 
        end # Very unlikely to ever happen due to the precision used
        
        if s1 >= 0 && s1 <= 2 
            slope = a * s1 + b
            j = jd + (i - 1 + s1) / nsteps


            # Convert Julian Day from dynamical to terrestrial universal time            
            ut = dt_to_ut(j)
            
            println("j $j $(jd_to_date(j)) ut $ut \n slope $slope $(jd_to_date(ut))")
            
            if slope > 0 
                moonrise = ut 
            else 
                moonset = ut 
            end
            if uroot 
                k = i
                break 
            end
        end
        
        if s2 >= 0 && s2 <= 2 
            slope = a * s2 + b
            j = jd + (i - 1 + s2) / nsteps
            ut = dt_to_ut(j)
            if slope > 0
                moonrise = ut 
            else 
                moonset = ut 
            end 
        end 

        if moonrise != false && moonset != false  # TODO is this right?
            k = i
            break 
        end
        
        v_list[1], v_list[2] = v_list[2], v_list[3]
        v_list[3] = moon_altitude(jd + (i + 2) / nsteps)
    end
    if uroot 
        if moonrise != false
            moonset = moonrise 
        else 
            moonrise = moonset 
        end 
    end
    return (moonrise, moonset, k)
end

#=

Return the standard altitude of the Moon.
    
    Parameters:
        r : Distance between the centers of the Earth and Moon, in km.
            
    Returns:
        Standard altitude in radians.
    
=#

function moon_rst_altitude(r)
    # horizontal parallax
    parallax = asin(earth_equ_radius / r)
    return 0.7275 * parallax + standard_rst_altitude
end

