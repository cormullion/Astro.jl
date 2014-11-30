export
    astrology, 
    biorhythm

#=

    Some pseudoscience. Don't know where these come from, but they're quite funny.

=#

#=

    Return some biorhythm stuff
    
    Parameters:
        jd_origin
        jd_current  

    Return:
        four biorhythms

=#

function biorhythm(jd_origin, jd_current)
    pi2 = pi * 2
    
    t = jd_current - jd_origin
    physical     = round(sin(pi2 * t/23), 2)
    emotional    = round(sin(pi2 * t/28), 2)
    intellectual = round(sin(pi2 * t/33), 2)
    intuitive    = round(sin(pi2 * t/38), 2)
    
    return (physical, emotional, intellectual, intuitive)
end

#=

    Return starsign for solar system body for a particular date
    
    Parameters:
        body : "Sun" or planet, one of "Mercury", "Venus", "Earth", "Mars", 
            "Jupiter", "Saturn", "Uranus", "Neptune"

    Return:
        starsign: string of star sign

=#

function astrology(body, jd)
    global days_per_second
    signs = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", 
    "Sagittarius", "Capricorn", "Aquarius", "Pisces"]

    if body == "Sun" 
    	(L, B, R) = sun_dimension3(jd)
    	long = L
    else
        deltaPsi = nut_in_lon(jd)
        epsilon  = true_obliquity(jd)
        ra, decl = geocentric_planet(jd, body, deltaPsi, epsilon, days_per_second)
        long, lat = equ_to_ecl(ra, decl, epsilon)
    end 
    i = 1 + ifloor(rad2deg(long) / 30)
    return signs[i];
end
