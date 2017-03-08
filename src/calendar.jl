export
    is_leap_year,
    cal_to_jd,
    date_to_jd,
    jd_to_date,
    jd_to_cal,
    cal_to_jd_m,
    cal_to_day_of_year,
    day_of_year_to_cal,
    pesach,
    jewish_new_year,
    moslem_to_christian,
    christian_to_moslem,
    easter,
    jd_to_day_of_week,
    is_dst,
    jd_to_jcent,
    lt_to_str,
    ut_to_lt

doc"""
A collection of date and time functions.

Some of these have/should be changed to use the built-in Dates module.

The functions which use Julian Day Numbers are valid only for positive values, i.e., for dates after -4712 (4713BC).

Unless otherwise specified, Julian Day Numbers are fractional values.

Numeric years use the astronomical convention of a year 0: 0 = 1BC, -1 = 2BC, etc.

Numeric months are 1-based: Jan = 1 Dec = 12.

Numeric days are the same as the calendar value.

Reference: Jean Meeus, _Astronomical Algorithms_, second edition, 1998, Willmann-Bell, Inc.

    Return True if this is a leap year in the Julian or Gregorian calendars

    Parameters:
        yr        : year
        gregorian : If True, use Gregorian calendar, else use Julian calendar (default: True)

    Return:
        True is this is a leap year, else False.

"""

function is_leap_year(yr, gregorian=true)
    yr =  floor(Integer, yr)
    if gregorian
        return (yr % 4 == 0) && ((yr % 100 != 0) || (yr % 400 == 0))
    else
        return yr % 4 == 0
    end
end

doc"""

Convert a date in the Julian or Gregorian calendars to the Julian Day Number

    Parameters:
        yr        : year
        mo        : month
        day       : day, may be fractional
        gregorian : if True, use Gregorian calendar, else use Julian calendar (default: True)

    Return:
        jd        : julian day number

presumably returns midday time, since Julian days start at noon?

"""

function cal_to_jd(yr, mo, day, gregorian=true)
    a =  floor(Integer, (14 - mo)/12)

    y = yr + 4800 - a
    m = mo + 12 * a - 3

    jdn = day +  floor(Integer, ((153 * m + 2) / 5)) + 365 * y +  floor(Integer, (y / 4)) - 32083.5
    if !gregorian
    	return jdn
    else
    	return jdn -  floor(Integer, (y/100)) +  floor(Integer, y/400) + 38
    end
end

"""
be careful with the next two as they don't take into account the current Daylight Savings Time.

"""

function date_to_jd(yr, mo, d, h, m, s, gregorian=true)
   return(cal_to_jd(yr, mo, d, gregorian) + hms_to_fday(h,m,s))
end

"""

"""

function jd_to_date(jd::Float64, gregorian=true)
    (y, month, df) = jd_to_cal(jd, gregorian)
    (f, d) = modf(df)
    (h, m, s) = fday_to_hms(f)
    return (y, month, floor(Integer, d), h, m, s)
end

"""

Convert a Julian day number to a date in the Julian or Gregorian calendars.

    Parameters:
        jd        : Julian Day number
        gregorian : if True, use Gregorian calendar, else use Julian calendar (default: True)

    Return:
        year
        month
        day (may be fractional)

    Return a tuple (year, month, day).

"""
function jd_to_cal(jd::Float64, gregorian=true)
    (F, Z) = modf(jd + 0.5)
    if gregorian
        alpha =  floor(Integer, ((Z - 1867216.25) / 36524.25))
        A = Z + 1 + alpha -  floor(Integer, alpha / 4)
    else
        A = Z
    end

    B = A + 1524
    C =  floor(Integer, (B - 122.1) / 365.25)
    D =  floor(Integer, 365.25 * C)
    E =  floor(Integer, (B - D) / 30.6001)
    day = B - D -  floor(Integer, 30.6001 * E) + F
    if E < 14
        mo = E - 1
    else
        mo = E - 13
    end

    if mo > 2
        yr = C - 4716
    else
        yr = C - 4715
    end

    return (yr, mo, day)
end

"""

Meeus' implementation of cal_to_jd - which gives the same results

"""

function cal_to_jd_m(yr, mo, day, gregorian=true)
    if mo <= 2
        yr = yr-1
        mo = mo+12
    end
    if gregorian
        A = floor(Integer, yr / 100)
        B = 2 - A + floor(Integer, A / 4)
    else
        B = 0
    end
    return  floor(Integer, 365.25 * (yr + 4716)) +  floor(Integer, 30.6001 * (mo + 1)) + day + B - 1524.5
end

"""

Convert a date in the Julian or Gregorian calendars to day of the year (Meeus 7.1).

    Parameters:
        yr        : year
        mo        : month
        day       : day
        gregorian : if True, use Gregorian calendar, else use Julian calendar (default: True)

    Return:
        day number : 1 = Jan 1...365 (or 366 for leap years) = Dec 31.

"""
function cal_to_day_of_year(yr, mo, dy, gregorian=true)
    if gregorian == false
        gregorian = true
    end
    if is_leap_year(yr, gregorian)
        K = 1
    else
        K = 2
    end
    dy =  floor(Integer, dy)
    return  floor(Integer, 275 * mo / 9.0) - (K *  floor(Integer, (mo + 9) / 12.0)) + dy - 30
end

"""
 Convert a day of year number to a month and day in the Julian or Gregorian calendars.

    Parameters:
        yr        : year
        N        : day of year, 1..365 (or 366 for leap years)
        gregorian : if True, use Gregorian calendar, else use Julian calendar (default: True)

    Return:
        month
        day

"""

function day_of_year_to_cal(yr, N, gregorian=true)
    if is_leap_year(yr, gregorian)
        K = 1
    else
        K = 2
    end
    if (N < 32)
        mo = 1
    else
        mo =  floor(Integer, 9 * (K+N) / 275.0 + 0.98)
    end
    dy =  floor(Integer, N -  floor(Integer, 275 * mo / 9.0) + K *  floor(Integer, (mo + 9) / 12.0) + 30)
    return (mo, dy)
end

"""

Return the date of Jewish Pesach  for a year in the Julian or Gregorian calendars.

    Parameters:
        yr        : year (in the Jewish calendar)
        gregorian : if True, use Gregorian calendar, else use Julian calendar (default: True)

    Return:
        month
        day
Meeus - chapter 9

"""
function pesach(yr, gregorian=true)
    C =  floor(Integer, yr/100)
    S = 0
    if gregorian
        S =  floor(Integer, (3*C-5)/4)
    end
    A = yr - 3760
    a = (12 * yr + 12) % 19
    b = yr % 4
    Q = -1.904412361576 + 1.554241796621 * a + 0.25 * b -0.003177794022 * yr + S
    j = ( floor(Integer, Q) + 3 * yr + 5 * b + 2 - S) % 7
    r = Q- floor(Integer, Q)
    if j==2 || j==4 || j==6
        D =  floor(Integer, Q) + 23
    elseif j==1 && a > 6 && r >= 0.63287037
        D =  floor(Integer, Q)+24
    elseif j==0 && a > 11 && r >= 0.897723765
        D =  floor(Integer, Q) + 23
    else
        D =  floor(Integer, Q) + 22
    end

    if D > 31
        return (4, D-31)
    else
        return (3, D)
    end
end

function jewish_new_year(yr)
    gr_yr = yr-1-3760
    (m, d) = pesach(yr-1)
    jd = cal_to_jd(gr_yr, m, d) + 316
    return jd_to_cal(Float64)
end

"""

Converts a date in the moslem calendar to a date in the Christian calendar
Meeus - chapter 9
    Input: h - moslem yearhe christian year
           m - moslem month number
           d - moslem day
    Returns: yr, month, day in the christian calendar

    This function will return meaningless results if called with a date earlier than
    622, July 16th

"""

function moslem_to_christian(h, m, d)
    N = d +  floor(Integer, 29.5001*(m-1)+0.99)
    Q  =  floor(Integer, h/30)
    R  = h%30
    A =  floor(Integer, (11 * R + 3)/30)
    W = 404*Q + 354*R+208 + A
    Q1 =  floor(Integer, W/1461)
    Q2 = W % 1461
    G  = 621 + 4 *  floor(Integer, 7 * Q + Q1)
    K =  floor(Integer, Q2/365.2422)
    E =  floor(Integer, K*365.2422)
    J = Q2-E+N-1
    X = G+K

    if J > 366 && X%4 == 0
        X = X+1
        J = J - 366
    elseif J > 365 && X%4 > 0
        X = X+1
        J = J - 365
    end

    # X is the year, J is the day in the julian calendar
    # Convert to MJD
    jd =  floor(Integer, 365.25*(X-1)) + 1721423 + J
    alpha =  floor(Integer, (jd-1867216.25)/36524.25)
    if jd < 2299161
        # Before 1582, Oct 15th
        bbeta = jd
    else
        bbeta = jd+ 1 + alpha -  floor(Integer, (alpha/4))
    end
    b = bbeta+1524
    c =  floor(Integer, (b-122.1)/365.25)
    d =  floor(Integer, 365.25*c)
    e1 =  floor(Integer, (b-d)/30.6001)
    D = b-d- floor(Integer, 30.6001*e1)
    if e1 < 14
        M = e1 - 1 else M = e1 - 13
    end
    if M > 2
        X = c - 4716 else X = c - 4715
    end
    return (X, M, D)
end

function christian_to_moslem(X, M, D, gregorian=true)
    # first convert the gregorian date to a julian date
    if gregorian
        if M < 3
            X = X-1
            M = M+12
        end
        alpha =  floor(Integer, X/100)
        bbeta  = 2-alpha+ floor(Integer, alpha/4)
        b =  floor(Integer, 365.25 * X) +  floor(Integer, 30.6001*(M+1)) + D + 1722519 + bbeta
        c =  floor(Integer, (b-122.1)/365.25)
        d =  floor(Integer, 365.25 * c)
        e1 =  floor(Integer, (b - d)/30.6001)
        D = b-d- floor(Integer, 30.6001 * e1)
        if e1 < 14
            M = e1 - 1 else M = e1 - 13
        end
        if M > 2
            X = c-4716
        else
            X = c-4715
        end
    end
    if X % 4 == 0
        W = 1
    else
        W = 2
    end
    N =  floor(Integer, 275 * M / 9) - W *  floor(Integer, (M + 9) / 12) + D - 30
    A = X - 623
    B =  floor(Integer, A/4)
    C = A % 4
    C1 = 365.2501 * C
    C2 =  floor(Integer, C1)
    if C1 - C2 > 0.5
        C2 = C2 + 1
    end
    Dp = 1461 * B + 170 + C2
    Q =  floor(Integer, Dp/10631)
    R = Dp % 10631
    J =  floor(Integer, R/354)
    K = R % 354
    O =  floor(Integer, (11 * J + 14)/30)
    H = 30 * Q + J + 1
    JJ = K - O + N - 1

    if JJ > 354
        CL = H % 30
        DL = (11 * CL + 3) % 30
        if DL < 19
           JJ = JJ - 354
           H=H + 1
        else
           JJ = JJ - 355
           H=H + 1
        end
        if JJ == 0
           JJ = 355
           H = H - 1
        end
    end
    S =  floor(Integer, (JJ - 1)/29.5)
    m = 1 + S
    d =  floor(Integer, JJ - 29.5 * S)
    if JJ == 355
        m = 12
        d = 30
    end
    return (H, m, d)
end

"""

Return the date of Western ecclesiastical Easter for a year in the Julian or Gregorian calendars.

    Parameters:
        yr        : year
        gregorian : if True, use Gregorian calendar, else use Julian calendar (default: True)

    Return:
        month
        day

     Julian formula found in Meeus.
     Gregorian formula taken from Wikipedia (for the formula published in Nature, April 20th, 1876)

"""

function easter(yr, gregorian=true)
    yr =  floor(Integer, yr)
    if gregorian
        a = yr % 19
        b =  floor(Integer, yr / 100)
        c = yr % 100
        d =  floor(Integer, b / 4)
        e1 = b % 4
        f =  floor(Integer, (b + 8) / 25)
        g =  floor(Integer, (b - f + 1) / 3)
        h = (19 * a + b - d - g + 15) % 30
        i =  floor(Integer, c / 4)
        k = c % 4
        l = (32 + 2 * e1 + 2 * i - h - k) % 7
        m =  floor(Integer, (a + 11 * h + 22 * l) / 451)
        tmp = h + l - 7 * m + 114
    else
        a = yr % 4
        b = yr % 7
        c = yr % 19
        d = (19 * c + 15) % 30
        e1 = (2 * a + 4 * b - d + 34) % 7
        tmp = d + e1 + 114
    end
    mo =  floor(Integer, tmp / 31)
    dy = (tmp % 31) + 1
    return (mo, dy)
end

"""
Return the day of week for a Julian Day Number.

    The Julian Day Number must be for 0h UT.

    Parameters:
        jd : Julian Day number

    Return:
        day of week: 0 = Sunday...6 = Saturday.

"""
function jd_to_day_of_week(jd::Float64)
    i = jd + 1.5
    return  floor(Integer, i) % 7
end

"""

Is this instant within the Daylight Savings Time period

# for Europe: last sunday of march 1:00UTC to last sunday of october 1:00UTC

    if daylight_timezone_name is false, the function always returns false.

    Parameters:
        jd : Julian Day number representing an instant in Universal Time

    Return:
        True if Daylight Savings Time is in effect, False otherwise.

"""
function is_dst(jd::Float64)
    global daylight_timezone_name
    if daylight_timezone_name == ""
        return false
    end
    #  What year is this?
    (yr, mon, day) = jd_to_cal(jd)
    # Last day of march
    starting = cal_to_jd(yr, 3, 31)
    # Back to last sunday
    dow = jd_to_day_of_week(starting)
    if dow >=0
        starting = starting - dow
    end
    # Advance to 1AM
    starting = starting + 1.0 / 24
    # Before the beginning of the period ?
    if jd < starting
        return false
    end
    # Last day in October
    stop = cal_to_jd(yr, 10, 31)
    # Backup to the last Sunday
    dow = jd_to_day_of_week(stop)
    stop = stop - dow
    #  Advance to 1AM
    stop = stop + 1.0 / 24
    # Before the end of the period ?
    if jd < stop
        return true
    end
    # After the end of the period
    return false
end

"""

Return the number of Julian centuries since J2000.0

    Parameters:
        jd : Julian Day number

    Return:
        Julian centuries

"""
function jd_to_jcent(jd::Float64)
    return (jd - 2451545.0) / 36525.0
end

"""
This now uses Julia Dates module. Timezones are currently not done - everything's in UTC.

Convert time in Julian Days to a formatted string.

    The general format is:

        YYYY-MMM-DD HH:MM:SS ZZZ

    Truncate the time value to seconds, minutes, hours or days as
    indicated. if level = "day", don't print the time zone string.

    Pass an empty string ("", the default) for zone if you want to do
    your own zone formatting in the calling module.

    Parameters:
        jd    : Julian Day number
        zone  : Time zone string (default = "")
        level : "day" or "hour" or "minute" or "second" (default = "second")

    Return:
        formatted date/time string

"""

function lt_to_str(jd::Float64, zone="", level="second")
    (yr, mon, day) = jd_to_cal(jd)
    (fday, iday) = modf(day)
    iday =  floor(Integer, iday)
    (hr, mn, second) = fday_to_hms(fday)
    second =  floor(Integer, second)

    if level == "second"
        return Dates.format(DateTime(yr, mon, iday, hr, mn, second), Dates.DateFormat("e, dd u yyyy HH:MM:SS"))
    end

    if level == "minute"
        return Dates.format(DateTime(yr, mon, iday, hr, mn), Dates.DateFormat("e, dd u yyyy HH:MM"))
    end

    if level == "day"
        return Dates.format(DateTime(yr, mon, iday), Dates.DateFormat("e, dd u yyyy"))
    end

    error("Unknown time level = $level")
end

"""

Convert universal time in Julian Days to a time.

    Include Daylight Savings Time offset, if any.

    Parameters:
        jd : Julian Day number, universal time

    Return:
        Julian Day number, time
        zone string of the zone used for the conversion

not yet doing time zones... :(

"""
function ut_to_lt(jd::Float64)
    global daylight_timezone_name, daylight_timezone_offset, standard_timezone_name, standard_timezone_offset
    if is_dst(jd)
        zone   = daylight_timezone_name
        offset = daylight_timezone_offset
    else
        zone   = standard_timezone_name
        offset = standard_timezone_offset
    end
    return (jd - offset/24, zone)
end
