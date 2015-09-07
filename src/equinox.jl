export
    equinox_approx,
    equinox

# Calculate the times of solstice and equinox events for Earth

# Meeus-1998 Table 27.A

equinox_approx_1000 = Dict{ASCIIString,Array{Float64,1}}(
    "spring" => [1721139.29189, 365242.13740,  0.06134,  0.00111, -0.00071],
    "summer" => [1721233.25401, 365241.72562, -0.05323,  0.00907, -0.00025],
    "autumn" => [1721325.70455, 365242.49558, -0.11677, -0.00297,  0.00074],
    "winter" => [1721414.39987, 365242.88257, -0.00769, -0.00933, -0.00006]
    )

# Meeus-1998 Table 27.B

equinox_approx_3000 = Dict{ASCIIString,Array{Float64,1}}(
    "spring" => [2451623.80984, 365242.37404,  0.05169, -0.00411, -0.00057],
    "summer" => [2451716.56767, 365241.62603,  0.00325,  0.00888, -0.00030],
    "autumn" => [2451810.21715, 365242.01767, -0.11575,  0.00337,  0.00078],
    "winter" => [2451900.05952, 365242.74049, -0.06223, -0.00823,  0.00032]
    )

# Meeus-1998 Table 27.C

equinox_terms = Array[
    [485, deg2rad(324.96),  deg2rad(  1934.136)],
    [203, deg2rad(337.23),  deg2rad( 32964.467)],
    [199, deg2rad(342.08),  deg2rad(    20.186)],
    [182, deg2rad( 27.85),  deg2rad(445267.112)],
    [156, deg2rad( 73.14),  deg2rad( 45036.886)],
    [136, deg2rad(171.52),  deg2rad( 22518.443)],
    [ 77, deg2rad(222.54),  deg2rad( 65928.934)],
    [ 74, deg2rad(296.72),  deg2rad(  3034.906)],
    [ 70, deg2rad(243.58),  deg2rad(  9037.513)],
    [ 58, deg2rad(119.81),  deg2rad( 33718.147)],
    [ 52, deg2rad(297.17),  deg2rad(   150.678)],
    [ 50, deg2rad( 21.02),  deg2rad(  2281.226)],
    [ 45, deg2rad(247.54),  deg2rad( 29929.562)],
    [ 44, deg2rad(325.15),  deg2rad( 31555.956)],
    [ 29, deg2rad( 60.93),  deg2rad(  4443.417)],
    [ 18, deg2rad(155.12),  deg2rad( 67555.328)],
    [ 17, deg2rad(288.79),  deg2rad(  4562.452)],
    [ 16, deg2rad(198.04),  deg2rad( 62894.029)],
    [ 14, deg2rad(199.76),  deg2rad( 31436.921)],
    [ 12, deg2rad( 95.39),  deg2rad( 14577.848)],
    [ 12, deg2rad(287.11),  deg2rad( 31931.756)],
    [ 12, deg2rad(320.81),  deg2rad( 34777.259)],
    [  9, deg2rad(227.73),  deg2rad(  1222.114)],
    [  8, deg2rad( 15.45),  deg2rad( 16859.074)]
    ]

"""
equinox_approx(yr, season)

Returns the approximate time of a solstice or equinox event.

    The year must be in the range -1000...3000. Within that range the
    the error from the precise instant is at most 2.16 minutes.

    Parameters:
        yr     : year -1000 ... 3000
        season : one of ("spring", "summer", "autumn", "winter")

    Returns:
        Julian Day of the event in dynamical time

"""

function equinox_approx(yr, season)
    if yr < -1000 || yr > 3000
      error("year is out of range")
    end
    yr =  floor(Integer, yr)
    if yr > -1000 && yr <= 1000
      Y = yr / 1000.0
      tbl = equinox_approx_1000
    else
      Y = (yr - 2000) / 1000.0
      tbl = equinox_approx_3000
    end
    jd = polynomial(tbl[season], Y)
    T = jd_to_jcent(jd)
    W = deg2rad(35999.373 * T - 2.47)
    delta_lambda = 1 + 0.0334 * cos(W) + 0.0007 * cos(2 * W)
    S = 0.0
    for v in equinox_terms
        S = S + v[1] * cos(v[2] + v[3] * T)
    end
    jd += (0.00001 * S) / delta_lambda
    return jd
end

equinox_circle = Dict{AbstractString, Float64}(
    "spring" => 0.0,
    "summer" => pi * 0.5,
    "autumn" => pi,
    "winter" => pi * 1.5
    )

equinox_k_sun_motion = 365.25 / (pi * 2)

"""
equinox(jd, season, delta)

    Return the precise moment of an equinox or solstice event on Earth.

    Parameters:
        jd     : Julian Day of an approximate time of the event in dynamical time
        season : one of ("spring", "summer", "autumn", "winter")
        delta  : the required precision in days. Times accurate to a second are
            reasonable when using the VSOP model.

    Returns:
        Julian Day of the event in dynamical time

"""

# TODO this fails

function equinox(jd::Float64, season, delta)

    # if we knew that the starting approximate time was close enough
    # to the actual time, we could pull nut_in_lon() and the aberration
    # out of the loop and save some calculating.

    #   calls: sun_dimension3(jd) which calls vsop87d_dimension(jd, "Earth") to get (L, B, R)
    circ = equinox_circle[lowercase(season)]

    for k in 1:20
        jd0 = jd
        L, B, R = sun_dimension3(jd)
        L += nut_in_lon(jd) + aberration_low(R)
        L, B = vsop_to_fk5(jd, L, B)
        jd += 58 * sin(circ - L)
        if abs(jd - jd0) < delta
           return jd
        end
    end
    error("bailout")
end
