export
    nutation_constants,
    nut_in_lon,
    nut_in_obl,
    nut_in_ra,
    obliquity_high,
    obliquity,
    true_obliquity

"""
 Functions to calculate nutation and obliquity values.

    [Meeus-1998: table 22.A]

"""

#    D, M, M1, F, omega, psiK, psiT, epsK, epsT

nutation_table = Array[
    [ 0,  0,  0,  0,  1, -171996, -1742, 92025,  89],
    [-2,  0,  0,  2,  2,  -13187,   -16,  5736, -31],
    [ 0,  0,  0,  2,  2,   -2274,    -2,   977,  -5],
    [ 0,  0,  0,  0,  2,    2062,     2,  -895,   5],
    [ 0,  1,  0,  0,  0,    1426,   -34,    54,  -1],
    [ 0,  0,  1,  0,  0,     712,     1,    -7,   0],
    [-2,  1,  0,  2,  2,    -517,    12,   224,  -6],
    [ 0,  0,  0,  2,  1,    -386,    -4,   200,   0],
    [ 0,  0,  1,  2,  2,    -301,     0,   129,  -1],
    [-2, -1,  0,  2,  2,     217,    -5,   -95,   3],
    [-2,  0,  1,  0,  0,    -158,     0,     0,   0],
    [-2,  0,  0,  2,  1,     129,     1,   -70,   0],
    [ 0,  0, -1,  2,  2,     123,     0,   -53,   0],
    [ 2,  0,  0,  0,  0,      63,     0,     0,   0],
    [ 0,  0,  1,  0,  1,      63,     1,   -33,   0],
    [ 2,  0, -1,  2,  2,     -59,     0,    26,   0],
    [ 0,  0, -1,  0,  1,     -58,    -1,    32,   0],
    [ 0,  0,  1,  2,  1,     -51,     0,    27,   0],
    [-2,  0,  2,  0,  0,      48,     0,     0,   0],
    [ 0,  0, -2,  2,  1,      46,     0,   -24,   0],
    [ 2,  0,  0,  2,  2,     -38,     0,    16,   0],
    [ 0,  0,  2,  2,  2,     -31,     0,    13,   0],
    [ 0,  0,  2,  0,  0,      29,     0,     0,   0],
    [-2,  0,  1,  2,  2,      29,     0,   -12,   0],
    [ 0,  0,  0,  2,  0,      26,     0,     0,   0],
    [-2,  0,  0,  2,  0,     -22,     0,     0,   0],
    [ 0,  0, -1,  2,  1,      21,     0,   -10,   0],
    [ 0,  2,  0,  0,  0,      17,    -1,     0,   0],
    [ 2,  0, -1,  0,  1,      16,     0,    -8,   0],
    [-2,  2,  0,  2,  2,     -16,     1,     7,   0],
    [ 0,  1,  0,  0,  1,     -15,     0,     9,   0],
    [-2,  0,  1,  0,  1,     -13,     0,     7,   0],
    [ 0, -1,  0,  0,  1,     -12,     0,     6,   0],
    [ 0,  0,  2, -2,  0,      11,     0,     0,   0],
    [ 2,  0, -1,  2,  1,     -10,     0,     5,   0],
    [ 2,  0,  1,  2,  2,      -8,     0,     3,   0],
    [ 0,  1,  0,  2,  2,       7,     0,    -3,   0],
    [-2,  1,  1,  0,  0,      -7,     0,     0,   0],
    [ 0, -1,  0,  2,  2,      -7,     0,     3,   0],
    [ 2,  0,  0,  2,  1,      -7,     0,     3,   0],
    [ 2,  0,  1,  0,  0,       6,     0,     0,   0],
    [-2,  0,  2,  2,  2,       6,     0,    -3,   0],
    [-2,  0,  1,  2,  1,       6,     0,    -3,   0],
    [ 2,  0, -2,  0,  1,      -6,     0,     3,   0],
    [ 2,  0,  0,  0,  1,      -6,     0,     3,   0],
    [ 0, -1,  1,  0,  0,       5,     0,     0,   0],
    [-2, -1,  0,  2,  1,      -5,     0,     3,   0],
    [-2,  0,  0,  0,  1,      -5,     0,     3,   0],
    [ 0,  0,  2,  2,  1,      -5,     0,     3,   0],
    [-2,  0,  2,  0,  1,       4,     0,     0,   0],
    [-2,  1,  0,  2,  1,       4,     0,     0,   0],
    [ 0,  0,  1, -2,  0,       4,     0,     0,   0],
    [-1,  0,  1,  0,  0,      -4,     0,     0,   0],
    [-2,  1,  0,  0,  0,      -4,     0,     0,   0],
    [ 1,  0,  0,  0,  0,      -4,     0,     0,   0],
    [ 0,  0,  1,  2,  0,       3,     0,     0,   0],
    [ 0,  0, -2,  2,  2,      -3,     0,     0,   0],
    [-1, -1,  1,  0,  0,      -3,     0,     0,   0],
    [ 0,  1,  1,  0,  0,      -3,     0,     0,   0],
    [ 0, -1,  1,  2,  2,      -3,     0,     0,   0],
    [ 2, -1, -1,  2,  2,      -3,     0,     0,   0],
    [ 0,  0,  3,  2,  2,      -3,     0,     0,   0],
    [ 2, -1,  0,  2,  2,      -3,     0,     0,   0]]

# Constant terms.

_kD  = [deg2rad(297.85036), deg2rad(445267.111480), deg2rad(-0.0019142), deg2rad( 1.0/189474)]
_kM  = [deg2rad(357.52772), deg2rad( 35999.050340), deg2rad(-0.0001603), deg2rad(-1.0/300000)]
_kM1 = [deg2rad(134.96298), deg2rad(477198.867398), deg2rad( 0.0086972), deg2rad( 1.0/ 56250)]
_kF  = [deg2rad( 93.27191), deg2rad(483202.017538), deg2rad(-0.0036825), deg2rad( 1.0/327270)]
_ko  = [deg2rad(125.04452), deg2rad( -1934.136261), deg2rad( 0.0020708), deg2rad( 1.0/450000)]

# Return some values needed for both nut_in_lon() and nut_in_obl()

function nutation_constants(T)
    D     = mod2pi(polynomial(_kD,  T))
    M     = mod2pi(polynomial(_kM,  T))
    M1    = mod2pi(polynomial(_kM1, T))
    F     = mod2pi(polynomial(_kF,  T))
    omega = mod2pi(polynomial(_ko,  T))
    return (D, M, M1, F, omega)
end

"""
Return the nutation in longitude.

    High precision. [Meeus-1998: pg 144]

    Parameters:
        jd : Julian Day in dynamical time

    Returns:
        nutation in longitude, in radians

"""

function nut_in_lon(jd)

    # TODO nut_in_lon() factor the /1e5 and /1e6 adjustments into the table.

    T = jd_to_jcent(jd)
    D, M, M1, F, omega = nutation_constants(T)
    deltaPsi = 0.0
    for v in nutation_table
        (tD, tM, tM1, tF, tomega, tpsiK, tpsiT, tepsK, tepsT) = v
        arg = D*tD + M*tM + M1*tM1 + F*tF + omega*tomega
        deltaPsi = deltaPsi + (tpsiK/10000.0 + tpsiT/100000.0 * T) * sin(arg)
    end
    return deg2rad(deltaPsi/3600)
end

"""
Return the nutation in obliquity.

    High precision. [Meeus-1998: pg 144]

    Parameters:
        jd : Julian Day in dynamical time

    Returns:
        nutation in obliquity, in radians

"""

function nut_in_obl(jd)
    #
    # Future optimization: factor the /1e5 and /1e6 adjustments into the table.
    #
    # Could turn the loop into a generator expression. Too messy?
    #
    T = jd_to_jcent(jd)
    D, M, M1, F, omega = nutation_constants(T)
    deltaEps = 0.0;
    for v in nutation_table
    		tD, tM, tM1, tF, tomega, tpsiK, tpsiT, tepsK, tepsT = v
      arg = D*tD + M*tM + M1*tM1 + F*tF + omega*tomega
      deltaEps = deltaEps + (tepsK/10000.0 + tepsT/100000.0 * T) * cos(arg)
    end
    return deg2rad(deltaEps/3600)
end

# Constant terms

 _el0 = Array([deg2rad(dms_to_d(23, 26,  21.448)),
              deg2rad(dms_to_d( 0,  0, -46.8150)),
              deg2rad(dms_to_d( 0,  0,  -0.00059)),
              deg2rad(dms_to_d( 0,  0,   0.001813))])

"""

 Return the mean obliquity of the ecliptic.

    Low precision, but good enough for most uses. [Meeus-1998: equation 22.2].

    Accuracy is 1" over 2000 years and 10" over 4000 years.

    Parameters:
        jd : Julian Day in dynamical time

    Returns:
        obliquity, in radians

"""

function obliquity(jd)
    T = jd_to_jcent(jd)
    return polynomial(_el0, T)
end

# Constant terms

_el1 = Array([deg2rad(dms_to_d(23, 26,    21.448)),
        deg2rad(dms_to_d( 0,  0, -4680.93)),
        deg2rad(dms_to_d( 0,  0,    -1.55)),
        deg2rad(dms_to_d( 0,  0,  1999.25)),
        deg2rad(dms_to_d( 0,  0,   -51.38)),
        deg2rad(dms_to_d( 0,  0,  -249.67)),
        deg2rad(dms_to_d( 0,  0,   -39.05)),
        deg2rad(dms_to_d( 0,  0,     7.12)),
        deg2rad(dms_to_d( 0,  0,    27.87)),
        deg2rad(dms_to_d( 0,  0,     5.79)),
        deg2rad(dms_to_d( 0,  0,     2.45))])

"""
Return the mean obliquity of the ecliptic.

    High precision [Meeus-1998: equation 22.3].

    Accuracy is 0.01" between 1000 and 3000, and "a few arc-seconds
    after 10,000 years".

    Parameters:
        jd : Julian Day in dynamical time

    Returns:
        obliquity, in radians

"""

function obliquity_high(jd)
    U = jd_to_jcent(jd) / 100
    return polynomial(_el1, U)
end

function true_obliquity(jd)
    return obliquity_high(jd) + nut_in_obl(jd)
end

"""

Return the nutation in right ascension (also called equation of the equinoxes.)

    Meeus-1998: page 88.

    Parameters:
        jd : Julian Day in dynamical time

    Returns:
        nutation, in radians

"""

function nut_in_ra(jd)
    global days_per_second
    deltapsi = rad2deg(nut_in_lon(jd)) * 3600     # deltapsi in seconds
    epsilon  = true_obliquity(jd)                 # Epsilon kept in radians
    c = deltapsi * cos(epsilon)/15                # result in seconds...
    return (c * (pi * 2) * days_per_second)       # converted radians
end
