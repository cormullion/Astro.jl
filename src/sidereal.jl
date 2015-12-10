#=
 Sidereal time at Greenwich

    Reference: Jean Meeus, _Astronomical Algorithms_, second edition, 1998, Willmann-Bell, Inc.

=#

export
    apparent_sidereal_time_greenwich,
    mean_sidereal_time_greenwich

"""
mean_sidereal_time_greenwich(jd)

    Return the mean sidereal time at Greenwich.

        The Julian Day number must represent Universal Time.

        Parameters:
            jd : Julian Day number

        Return:
            sidereal time in radians (2pi radians = 24 hrs)

"""

function mean_sidereal_time_greenwich(jd)
    T = jd_to_jcent(jd)
    T2 = T * T
    T3 = T2 * T
    theta0 = 280.46061837 + 360.98564736629 * (jd - 2451545.0)  + 0.000387933 * T2 - T3 / 38710000
    result = deg2rad(theta0)
    return mod2pi(result)
end

"""

apparent_sidereal_time_greenwich(jd)

    Return the apparent sidereal time at Greenwich.

    The Julian Day number must represent Universal Time.

    Parameters:
        jd : Julian Day number

    Return:
        sidereal time in radians (2pi radians = 24 hrs)

"""

function apparent_sidereal_time_greenwich(jd)
    # Nutation in right ascension should be computed from the DT julian date
    # we neglect the difference here
    return mod2pi(mean_sidereal_time_greenwich(jd) + nut_in_ra(jd))
end
