using Base.Test, Astro

print("33.a Apparent position, page 225")
# calculate the apparent position of Venus on 1992 December 20 at 0h TD, HDE 2448976.5
# apparent RA should be 316.172791 = 21h.078194 = 21h04m41.50
# apparent Dec should be -18.88801 = -18d53m16.8s
ra, decl = geocentric_planet(2448976.5, "Venus", deg2rad(dms_to_d(0, 0, 16.749)), deg2rad(23.439669), days_per_second)
ra_hms = fday_to_hms(radianstime_to_fday(ra))
@test(ra_hms[1] == 21)
@test(ra_hms[2] == 4)
@test_approx_eq_eps(ra_hms[3], 41.5, 0.01)
println(" passed")

print("32.a Planet position, page 219")
# calculate the heliocentric coordinates of Venus on 1992 Dec 20 at 0h
# heliocentric longitude of Venus should be 26.11428
# heliocentric latitude is -2.62070
# radius vector is 0.724603 AU
L, B, R = vsop87d_dimension(2448976.5, "Venus")
@test_approx_eq_eps(rad2deg(L), 26.11428, .1)
@test_approx_eq_eps(rad2deg(B), -2.62070, .1)
@test_approx_eq_eps(R, 0.724603, .1)
println(" passed")
