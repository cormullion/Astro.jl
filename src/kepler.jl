export solve_kepler

"""
solve_kepler(mean_anomaly, eccentricity, desired_accuracy = 1e-6)

    Solves Kepler's equation for the eccentric anomaly
    using Newton's method.

    Arguments:
    mean_anomaly    -- mean anomaly in radians
    eccentricity    -- eccentricity of the ellipse defaulting to 1e-6

    Returns: eccentric anomaly in radians.

    M = E - e sin E

    to get the time, t, or position, n, in orbit.

        cos n = [cos E - e]/[1 - e cos E]

    and

        cos E = [cos n + e]/[1 + e cos n]

    will be needed.

        E = eccentric anomaly measured from perihelion about the center of the elliptical orbit
        e = eccentricity of the orbit
        M = mean anomaly = 2p t/P
        t = time since perihelion passage
        P = period of the orbit
        n = true anomaly = angle of the object in obit relative to the perihelion

"""

function solve_kepler(mean_anomaly, eccentricity, desired_accuracy = 1e-6)
    eccentric_anomaly = mean_anomaly
    while true
        difference = eccentric_anomaly - eccentricity * sin(eccentric_anomaly) - mean_anomaly
        eccentric_anomaly -= difference / (1 - eccentricity * cos(eccentric_anomaly))
        if abs(difference) <= desired_accuracy
           break
        end
    end
    return eccentric_anomaly
end
