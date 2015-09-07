using Base.Test, Astro

print("47.a Moon position")
# Calculate the geocentric longitude, latitude, distance, and equatorial horizontal parallax
# of the moon for 1992 April 12 at 0h TD

L, B, R = moon_dimension3(cal_to_jd(1992,4,12))

# longitude should be 133d.152655
# beta -3d.229126
# delta 368409.7 km
# pi 0.991990

@test_approx_eq_eps(rad2deg(L), 133.162, .1) # 0.1 degree OK?
@test_approx_eq_eps(rad2deg(B), -3.229126, 1e-6) # degrees
@test_approx_eq_eps(R, 368409.7, 0.1) # km

# the other routine:

L = moon_dimension(2448724.5, "L")
@test_approx_eq_eps(rad2deg(L), 133.162655, 0.1)

B = moon_dimension(2448724.5, "B")
@test_approx_eq_eps(rad2deg(B), -3.229126, 0.1) # degrees

R = moon_dimension(2448724.5, "R")
@test_approx_eq_eps(R, 368409.7, 0.1) # km

println(" passed")

print("47 Moon ascending node longitude")
# times when the mean ascending or descending node of the lunar orbit coincides with the vernal equinox,
# ie when it is equal to 0 or 180.
# It is 180 on 2015 Oct 10, and 0 on 2025 Jan 29
L = rad2deg(moon_mean_ascending_node_longitude(cal_to_jd(2015, 10, 10)))
@test_approx_eq_eps(L, 180, 10e-2)
L = rad2deg(moon_mean_ascending_node_longitude(cal_to_jd(2025, 1, 29)))
@test_approx_eq_eps(L, 0, 10e-2)
println(" passed")

print("48.a (1) Illuminated fraction of moon's disk (high precision)")
k, khi = moon_illuminated_fraction_high(cal_to_jd(1992, 4, 12))
@test_approx_eq_eps(k, 0.678, 0.001) # percent
@test_approx_eq_eps(rad2deg(khi), 285, 0.1) # degrees
println(" passed")

print("48.a (2) Illuminated fraction of moon's disk (low precision)")
k = moon_illuminated_fraction_low(cal_to_jd(1992, 4, 12))
@test_approx_eq_eps(k, 0.680, 0.001)
println(" passed")

print("49.a New moon")
jd = moon_nearest_phase(cal_to_jd(1977, 2, 13), 0)
yr, mo, day = jd_to_cal(jd)
@test_approx_eq_eps(yr, 1977, 1)
@test_approx_eq_eps(mo, 2, 0)
@test_approx_eq_eps(day, 18.15, 0.01)
println(" passed")

print("49.b Moon last quarter")
jd = moon_nearest_phase(cal_to_jd(2044, 1, 19), 3)
yr, mo, day = jd_to_cal(jd)
@test_approx_eq_eps(yr, 2044, 0.1)
@test_approx_eq_eps(mo, 1, 0.1)
@test_approx_eq_eps(day, 21.99, 0.01)
println(" passed")

print("50 Moon apogee")
jd, parallax = moon_apogee_perigee_time_low(cal_to_jd(1988, 10, 1), 1)
# Apogee time
@test_approx_eq_eps(jd * seconds_per_day/60, 2447442.3537 * seconds_per_day / 60, 1) # minutes
# parallax
@test_approx_eq_eps(parallax, 3240.679, 1) # seconds
println(" passed")

print("50 Moon perigee (p 361)")
jd, para = moon_apogee_perigee_time_low(cal_to_jd(1997, 12, 9), 0)
# Perigee time
@test_approx_eq_eps(jd, 2450792.2059, 0.1)
jd, para = moon_apogee_perigee_time_low(cal_to_jd(1998, 1, 3), 0)
# Perigee time"
@test_approx_eq_eps(jd, 2450816.8549, 0.1)
jd, para = moon_apogee_perigee_time_low(cal_to_jd(1990, 12, 2), 0)
# Perigee time
@test_approx_eq_eps(jd, 2448227.9505, 0.1)
jd, para = moon_apogee_perigee_time_low(cal_to_jd(1990, 12, 30), 0)
# Perigee time
@test_approx_eq_eps(jd, 2448256.4941, 0.1)
println(" passed")

print("51.a Moon ascending node time")
# node()
#    	- jd: julian date
#    	- desc_not_asc: 0 for the ascending node, 1 for the descending node
# returns jd of the closer passage
jd = moon_node(cal_to_jd(1987, 5, 15), 0)
@test_approx_eq_eps(jd, 2446938.76, 0.01)
println(" passed")

print("Lunation")
jd = cal_to_jd(2014,10,14)
lunationnumber = lunation(jd, "brown")
@test_approx_eq_eps(lunationnumber, 1135.0, .1)
println(" passed")

print("Nearest moon phase to a specific day")
# NASA, at http://eclipse.gsfc.nasa.gov/phase/phase2001gmt.html,
# give New: Oct 23  21:57  FirstQ: Oct 31  02:48  Full:Nov  6  22:23  Last Quarter: Nov 14  15:16
jd = cal_to_jd(2014, 10, 15)
nearest_new = moon_nearest_phase(jd, 0)
nearest_first = moon_nearest_phase(jd, 1)
nearest_full  = moon_nearest_phase(jd + 10, 2) # get next, not nearest
nearest_last  = moon_nearest_phase(jd + 10, 3)

@test_approx_eq_eps(nearest_new, date_to_jd(2014,10,23,21,57, 0), .001) # within about 2 minutes
@test_approx_eq_eps(nearest_first, date_to_jd(2014,10,31,2,48, 0), .001)
@test_approx_eq_eps(nearest_full, date_to_jd(2014,11,6,22,23, 0), .001)
@test_approx_eq_eps(nearest_last, date_to_jd(2014,11,14,15,16, 0), .001)
println(" passed")

print("Moon position")
# Duffett-Smith: what was the position of the Moon on Feb 26 1979 at 16h 00 m UT
# Should be ra 22 33 29s decl -8 02 42s
jd = date_to_jd(1979,2,26,16,0,0)
geoecl_long, geoecl_lat, rad = moon_dimension3(jd)
ra_rad, dec_rad = ecl_to_equ(geoecl_long, geoecl_lat, obliquity(jd))
ra_deg = ra_rad / (2 * pi) |> fday_to_hms
@test(ra_deg[1] == 22)
@test(ra_deg[2] == 33)
@test_approx_eq_eps(ra_deg[3], 28, 30) # within 30 seconds OK?
# long and lat do the same job as moon_dimension3
@test_approx_eq_eps(moon_longitude(jd), moon_dimension3(jd)[1], 0.01)
@test_approx_eq_eps(moon_latitude(jd), moon_dimension3(jd)[2], 0.01)
println(" passed")

println("Moon rise and moon set")
# Duffett-Smith what were the times of moonrise and moonset on Sept 6 1979
# as observed from longitude 0N and latitude 52N
# ephemeris says 18h46m and 04h58m
latitude = deg2rad(52)
longitude = deg2rad(0)
jd = cal_to_jd(1979,9,6)
r,s = moon_riseset(jd)
d1, d2 = map(jd_to_date, (r,s))
hr, mn, sc = fday_to_hms(r - jd)
@test(hr == 18)
@test_approx_eq_eps(mn, 46, 30) # TODO moon_riseset test within 30 minutes???

hr, mn, sc = fday_to_hms(s - jd)
@test_approx_eq_eps(hr,4, 1) #
@test_approx_eq_eps(mn, 58, 300)  # within 240 minutes (4 hours) ???

println()

"""
 TODO moon-tests.jl more still to be tested:
moon_horizontal_parallax(jd::Float64)
moon_mean_ascending_node_longitude(jd)
moon_mean_perigee_longitude(jd::Float64)
moon_node(jd::Float64, desc_not_asc)
moon_radius(jd::Float64)
moon_true_ascending_node_longitude(jd::Float64)

"""
