export
    d_to_dms,
    diff_angle,
    dms_to_d,
    fday_to_hms,
    radianstime_to_fday,
    hangle_to_dec_deg_alt,
    hangle_to_dec_deg,
    hms_to_fday,
    interpolate_angle3,
    interpolate3,
    @polynomial_horner,
    polynomial,
    quadratic_interpolation,
    quadratic_roots,
    set_latitude,
    set_longitude

# Meeus chapter 4, quadratic curve fitting:

function quadratic_interpolation(x_list, y_list)
    (P, Q, R, S, T, U, V) = 0, 0, 0, 0, 0, 0, 0
    for (i, v) in enumerate(x_list)
    	v2 = v * v
    	v3 = v2 * v
    	v4 = v3 * v
    	P = P + v
    	Q = Q + v2
    	R = R + v3
    	S = S + v4
    	T = T + y_list[i]
    	U = U + v * y_list[i]
    	V = V + v2 * y_list[i]
    end
    N = length(x_list)
    D =  N * Q * S + 2 * P * Q * R - Q * Q * Q - P * P * S - N * R * R
    a = (N * Q * V + P * R * T + P * Q * U - Q * Q * T - P * P * V - N * R * U) / D
    b = (N * S * U + P * Q * V + Q * R * T - Q * Q * U - P * S * T - N * R * V) / D
    c = (Q * S * T + Q * R * U + P * R * V - Q * Q * V - P * S * U - R * R * T) / D
    return (a, b, c)
end

function quadratic_roots(a, b, c)
    delta = b * b - 4 * a * c
    if delta < 0
        return (false, false)
    end
    if delta == 0
        return (-b/2/a, -b/2/a)
    end
    sqd = sqrt(delta)
    return ((-b + sqd)/2/a, (-b - sqd)/2/a)
end

"""
 Convert an angle in decimal degrees to degree components.

    Return a tuple (degrees, minutes, seconds). Degrees and minutes
    will be integers, seconds may be floating.

    if the argument is negative:
        The return value of degrees will be negative.
        If degrees is 0, minutes will be negative.
        If minutes is 0, seconds will be negative.

    Parameters:
        x : degrees

    Returns:
        degrees
        minutes
        seconds

"""

function d_to_dms(x)
    if x < 0
    negative = true
    else
    negative = false
    end
    x = abs(x)
    deg =  floor(Integer, x)
    x = x-deg
    mn =  floor(Integer, x * 60)
    x = x - mn / 60.0
    second = x * 3600
    if negative
    if deg > 0
        deg = -deg
    elseif mn > 0
        mn = -mn
    else
        second = -second
    end
    end
    return (deg, mn, second)
end

"""

Return angle b - a, accounting for circular values.

    Parameters a and b should be in the range 0..pi*2. The
    result will be in the range -pi..pi.

    This allows us to directly compare angles which cross through 0:

        359 degress... 0 degrees... 1 degree... etc

    Parameters:
        a : first angle, in radians
        b : second angle, in radians

    Returns:
        b - a, in radians

"""

function diff_angle(a, b)
    if b < a
      result = (b + (2 * pi)) - a
    else
      result = b - a
    end
    return mod2pi(result)
end

"""

Convert an angle in degree components to decimal degrees.

    if any of the components are negative the result will also be negative.

    Parameters:
        deg : degrees
        min : minutes
        sec : seconds

    Returns:
        decimal degrees

"""

function dms_to_d(deg, minute, second)
    result = abs(deg) + (abs(minute) / 60) + (abs(second) / 3600)
    if deg < 0 || minute < 0 || second < 0
      result = -result
    end
    return result
end

"""

Convert an hour angle in hour, minute, seconds to decimal degrees.

     if any of the components are negative the result will also be negative.

    Parameters:
        hour : hours
        min : minutes
        sec : seconds

    Returns:
        decimal degrees

"""
function hangle_to_dec_deg(hour, minute, second)
    global seconds_per_day
    s = abs(hour) * 3600 + abs(minute) * 60 + abs(second)
    s = mod(s, seconds_per_day)
    if hour < 0 || minute < 0 || second < 0
    	s = -s
    end
    return mod(s, seconds_per_day)
end

function hangle_to_dec_deg(hour, minute, second)
    t = dms_to_d(hour, minute, second)
    return mod((t * 15), 360)
end

"""

Convert fractional day (0.0..1.0) to integral hours, minutes, seconds.

    Parameters:
        day : a fractional day in the range 0.0..1.0

    Returns:
        hour : 0..23
        minute : 0..59
        seccond : 0..59

"""

function fday_to_hms(day)
    global seconds_per_day
    tsec = day * seconds_per_day
    tmin = tsec / 60
    thour = tmin / 60
    hour = thour % 24
    minutes = tmin % 60
    seconds = tsec % 60
    return ( floor(Integer, hour),  floor(Integer, minutes), seconds)
end

"""

Convert hours-minutes-seconds into a fractional day 0.0..1.0.

    Parameters:
        hr : hours, 0..23
        mn : minutes, 0..59
        sec : seconds, 0..59

    Returns:
        fractional day, 0.0..1.0

"""
function hms_to_fday(hr, mn, seconds)
    global minutes_per_day, seconds_per_day
    return ((hr / 24.0) + (mn / minutes_per_day) + (seconds / seconds_per_day))
end

"""
Convert a time of day in radians to fractional day 0 through 1

"""

function radianstime_to_fday(tr)
    return (tr / (2 * pi))
end

"""

Interpolate from three equally spaced tabular values.

    [Meeus-1998 equation 3.3]

    Parameters:
        n : the interpolating factor, must be between -1 and 1
        y : a sequence of three values

    Results:
        the interpolated value of y

"""
function interpolate3(n, y)
    if (n < -1) || (n > 1)
    	error("Interpolating factor out of range: $n")
    end
    a = y[2] - y[1]
    b = y[3] - y[2]
    c = b - a
    return y[2] + n/2 * (a + b + n*c)
end

"""

Interpolate from three equally spaced tabular angular values.

    [Meeus-1998 equation 3.3]

    This version is suitable for interpolating from a table of
    angular values which may cross the origin of the circle,
    for example: 359 degrees...0 degrees...1 degree.

    Parameters:
        n : the interpolating factor, must be between -1 and 1
        y : a sequence of three values

    Results:
        the interpolated value of y

"""
function interpolate_angle3(n, y)
    if (n < -1) || (n > 1)
    	error("Interpolating factor $n out of range")
    end
    a = diff_angle(y[1], y[2])
    b = diff_angle(y[2], y[3])
    c = diff_angle(a, b)
    return y[2] + n/2 * (a + b + n*c)
end

"""

Evaluate a simple polynomial.

    Where: terms[0] is constant, terms[1] is for x, terms[2] is for x^2, etc.

    Example:
        y = polynomial((1.1, 2.2, 3.3, 4.4), t)

        returns the value of:

            1.1 + 2.2 * t + 3.3 * t^2 + 4.4 * t^3

    Parameters:
        terms : sequence of coefficients
        x : variable value

    Results:
        value of the polynomial

"""
function polynomial(coefficients, x)
    result = 0
    for (power, coefficient) in enumerate(coefficients)
        result += (x ^ (power - 1)) * coefficient
    end
    return result
end

"""

alternatively use this from math.jl

     Example
        y = @horner(x, p1, p2, p3)

        evaluates p[1] + x     *      (p[2] + x * (....)),

    notice the arguments are differently ordered from polynomial() above

    Parameters:
        x : variable value
        term1 : coefficient 1
        ...

    Results:
        value of the polynomial

"""

macro polynomial_horner(x, p...)
    ex = esc(p[end])
    for i = length(p)-1:-1:1
        ex = :($(esc(p[i])) + t * $ex)
    end
    Expr(:block, :(t = $(esc(x))), ex)
end

function set_latitude(lat)
     global latitude
     latitude = lat
end

function set_longitude(long)
     global longitude
     longitude = long
end
