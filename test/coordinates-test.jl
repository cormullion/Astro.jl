using Base.Test, Astro

print("13.a Equatorial to ecliptical coordinates")
# convert RA/Dec to celestial longitude and latitude
# equ_to_ecl(ra, declin, obliquity)
# ra is usually in hours, so convert to radians
# Calculate the ecliptical coordinate the star Pollux whose equatorial coordinates are
# ra = a2000 = 7h 45m 12.946s = 116.328942deg, dec = d2000 = +28d01m34.26
# L should be 113.21563 degrees2radians
# B should be +6.68417 degrees

L, B = equ_to_ecl(hms_to_fday(7,45,12.946) * 2 * pi, deg2rad(dms_to_d(28,1,34.26)), deg2rad(23.4392911))
# L = longitude
@test_approx_eq_eps(rad2deg(L), 113.21563, 0.1)
# B = latitude
@test_approx_eq_eps(rad2deg(B), 6.68417, 0.1)
println(" passed")

print("13.a1  Ecliptic to Equatorial")
ra, decl = ecl_to_equ(L, B, deg2rad(23.4392911))
# ra is right ascension in radians
ra_deg, decl_deg = map(rad2deg, (ra,decl))
@test_approx_eq_eps(ra_deg, 116.328942, 0.1)
@test_approx_eq_eps(decl_deg, 28.026183, 0.1)
ra_day = fday_to_hms(ra_deg)
ra_hms =  fday_to_hms(rad2deg(ra)/360)
@test ra_hms[1:2] == (7.0,45.0)
@test_approx_eq_eps(ra_hms[3], 12.946, 0.1)
println(" passed")

print("13.a2 Ecliptical to equatorial coordinates")
# what are the right ascension and declination of a planet whose ecliptic coordinates are
# ecl longitude 139-41-10 and ecl latitude 4-52-31"
# RA should be 09h34m53.6s
# decl should be 10d32m14,2s
ra, decl = ecl_to_equ(deg2rad(dms_to_d(139, 41, 10)), deg2rad(dms_to_d(4,52,31)), deg2rad(23.4392911))
ra_deg, decl_deg = map(rad2deg,(ra, decl))
@test_approx_eq_eps(ra_deg/15, 9.581551, 0.01)
@test_approx_eq_eps(decl_deg, dms_to_d(19,32,14.2), 0.01)
println(" passed")

print("13 supplemental Ecliptical to equatorial coordinates (RA, decl)")
ra, decl = ecl_to_equ(deg2rad(dms_to_d(139,41,10)), deg2rad(dms_to_d(4, 52, 31)), deg2rad(23.4392911))
ra_deg, decl_deg = map(rad2deg,(ra, decl))
@test_approx_eq_eps(ra_deg/15, 9.581534330766397, 0.01)
@test_approx_eq_eps(decl_deg, 19.536745492338458, 0.01)
println(" passed")

print("Equatorial (HA/Dec) to horizontal coordinates (Alt/Azi)")
# need to set latitude
set_latitude(deg2rad(52.0))
println(" using latitude $(rad2deg(latitude))")

# what is the altitude and azimuth of a star whose hour-angle is 05h51m44s and declination is 23d13m10s,
# latitude 52N
# altitude should be 19d20m04s
# azimuth should be 283d16m16s

set_latitude(deg2rad(52))
h = hangle_to_dec_deg(5,51,44) # returns degrees
d = dms_to_d(23,13,10) # returns degrees
azi,alt = equ_to_horiz(deg2rad(h), deg2rad(d))
azi_deg = rad2deg(azi)
alt_deg = rad2deg(alt)
@test(d_to_dms(azi_deg)[1] == 283)
@test_approx_eq_eps(d_to_dms(azi_deg)[2], 16, 0.1)
@test_approx_eq_eps(d_to_dms(azi_deg)[3], 16, 0.4) # only accurate to 0.4
@test(d_to_dms(alt_deg)[1] == 19.0)
@test(d_to_dms(alt_deg)[2] == 20.0)
@test_approx_eq_eps(d_to_dms(alt_deg)[3], 4, 0.4) # only accurate to 0.4 seconds???
println(" passed")

print("40.a topocentric right ascension and declination")
# calculate the topocentric RA and Dec of Mars on 2003 Aug 28 at 3h17m00 UT at Palomar,
# longitude 7h47m27s, altitude 1706
# Mars' equatorial coordinates: RA 339.530208, decl -15.771083
"""
      phi: geocentric radius in radians
        H : observer's altitude (above sea level) in meters
        L ; observer longitude (in radians) (hangle_to_dec_deg(7,47,27))
        ra : body right ascension
        decl : body declination in radians
        d : body distance (in AU)
        jd : observer's hour angle in radian

"""
ra, decl = geocentric_to_topocentric(deg2rad(33.356111), 1706, deg2rad(116.8625), deg2rad(339.530208), deg2rad(-15.771083), 0.37276, cal_to_jd(2003, 8, 28.136806))
# topocentric right ascension
@test_approx_eq_eps(rad2deg(ra), 339.5, .1)
# topocentric declination
@test_approx_eq_eps(rad2deg(decl), -15.775, .1)
println(" passed")
