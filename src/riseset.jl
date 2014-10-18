export 
    object_rts_low
#=

    Compute rise, set, and transit times with low accuracy.

    Requires equatorial coordinates for the object in question for today at 0hr UT.

    Return the Julian Days of the rise/transit/set times of an object.
    
    Parameters:
        jd      : Julian Day number of the day in question, at 0 hr UT
        raList  : right ascension value, in radians, for jd
        decList : declination value, in radians, for jd
        h0      : the standard altitude in radians; the 'standard' altitude is
                  deg2rad(-0.5667) for stars/planets, deg2rad(-0.8333) for the sun
        rise/set: boolean flag to calculate Rise (true) or Set (false)    

    Returns:
        tuple of Julian Day rise/transit/set times

This is the low accuracy part of Meeus' method from chapter 15. The high accuracy interpolation routine is still to be done.

=#

function object_rts_low(jd, ra, decl, h0)
    pi2 = pi * 2
    THETA0 = mean_sidereal_time_greenwich(jd)
    deltaT_days = deltaT_seconds(jd) / seconds_per_day    
    cosH0 = (sin(h0) - sin(latitude) * sin(decl)) / (cos(latitude) * cos(decl))

    # TODO object_rts_low: return some indicator when the 
    # object is circumpolar or always below the horizon.
    #
    
    if cosH0 < -1.0 # circumpolar
        println("circumpolar")
        return (false, false, false)
    end	
    if cosH0 > 1.0  # never rises
        println("never rises")
        return (false, false, false)
    end
    
    H0 = acos(cosH0)
    # transit
    m0 = (ra + longitude - THETA0) / pi2
    # must be between 0 and 1
    # rise    
    m0 = mod(m0, 1)
    m1 = mod(m0 - (H0 / pi2),1)    
    # set
    m2 = mod(m0 + (H0 / pi2),1)    
    return(m1, m0, m2) 
end

