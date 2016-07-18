using Base.Test, Astro

print("25.a Sun position, low precision")
# Meeus page 165
# Calculate the Sun's position on 1992 October 13 at 0h TD
# should be geometric long mean equinox of date 199degrees  54 minutes 26.18 seconds
#          apparent longitude 199d54m23.56s
#          apparent latitude +0.72 seconds
#          radius vector 0.99760853
#          apparent RA 13h13m30.749s
#          apparent decl -1d47m01.74s
L, R = longitude_radius_low(2448908.5)
@test_approx_eq_eps(rad2deg(L), 199.90988, 1e-2) # should be 1e-5 ?
@test_approx_eq_eps(R, 0.99766, 1e-5)
L = apparent_longitude_low(2448908.5, L)
println("\nL is $(rad2deg(L)) degrees, R is $R au")
@test_approx_eq_eps(rad2deg(L), 199.90895, 1e-2) # should be 1e-5 ?
println(" passed\n\n")


print("28.a Equation of time")
# Find equation of time on 1992 October 13 at 0h
# should be 13.70949 minutes, 13m42.6s
E = equation_time(cal_to_jd(1992,10,13))
@test_approx_eq_eps(E, 13.7, .5) # half a second?
E = equation_time(cal_to_jd(1980,7,27.5))
@test_approx_eq_eps(E, -6.4, .1)
println(" passed")

#=

map(rad2deg,sun_dimension3(cal_to_jd(1992,10,13)))
 2014-10-08T16:59:16 loaded data for Earth 2.4489085e6 (1992.0,10.0,13.0)
(199.90729724204937,0.00020664594475074667,57.158757815790885)

=#

print(" Duffett-Smith: RA and DEC of the sun of July 27 1980")
# Duffett-Smith page 83 Practical Astronomy with your calculator
# What were the RA and DEC of the sun of July 27 1980
# sun's longitude should be 124.108828
# > ra should be 08h25m44s
# dec should be 19h13m53s
jd = cal_to_jd(1980,7,27)
Lsun, radius = longitude_radius_low(cal_to_jd(1980,7,27))
# ecliptic latitude is 0
Bsun = 0
obliquity = obliquity_high(jd)
ra, decl = ecl_to_equ(Lsun, Bsun, obliquity)
#println(" For July 27, 1980, the Sun's RA and Dec were")
#println(" RA: $(d_to_dms(rad2deg(ra))), Decl: $(d_to_dms(rad2deg(decl)))")
# RA is (126.0,26.0,8.426670651592705), Decl is (19.0,13.0,52.04805574268332)

#=

Lsun, radius = longitude_radius_low(cal_to_jd(1980,7,27))
> (2.166121184301187,1.0155158031473217)

rad2deg(2.166121184301187)
> 124.10960177433758        - sun's longitude looks good

Bsun = 0
obliquity = obliquity_high(jd)

ra, decl = ecl_to_equ(Lsun, Bsun, obliquity)

ecl_to_equ returns:
        Right ascension in radians (2 pi is 24 hours)
        Declination in radians

> (2.206718804590345,0.335646440686569)

map(rad2deg, (ra,decl))
> (126.435674075181,19.231124459928523)
θθ

=#

#print("\n\n25.b Sun position, high precision, page 169")
L, B, R = sun_dimension3(2448908.5)

# meeus gives L as 19°.907372, B as -0.000179, R as 0.99760775

@test_approx_eq_eps(rad2deg(L), 199.907372  , 1) # <<<<<<<<<<<<<<<<<===== fails
@test_approx_eq_eps(rad2deg(B) , 0.644, .1)
@test_approx_eq_eps(R * km_per_au, 0.99760775 * km_per_au, .1)
L, B = vsop_to_fk5(2448908.5, L, B)
@test_approx_eq_eps(rad2deg(L) * 3600, 199.907347 * 3600, .1)
@test_approx_eq_eps(rad2deg(B) * 3600, 0.62, .1)
aberration = aberration_low(R)
@test_approx_eq_eps(rad2deg(aberration) * 3600, -20.539, 0.001)
println(" passed")

print("\n\n25.b Sun position, high precision (complete theory pg 165)")
@test_approx_eq_eps(rad2deg(L) * 3600 * 100, dms_to_d(199, 54, 26.18) * 3600 * 100, 1)
@test_approx_eq_eps(rad2deg(B) * 3600 * 100, 0.72 * 100, 1)
@test_approx_eq_eps(R, 0.99760853, 1e-8)
println(" passed")

print("\n\n26.a 1 rectangular coordinates of the sun, relative to the mean equinox of the date")
X, Y, Z = rectangular_md(2448908.5)
@test_approx_eq_eps(X*km_per_au, -0.9379952*km_per_au, .1) # <<<<<<<<<<<<<<<<<<<<<===== fails
@test_approx_eq_eps(Y*km_per_au, -0.3116544*km_per_au, .1) # ..
@test_approx_eq_eps(Z*km_per_au, -0.1351215*km_per_au, .1) # ..
println(" passed")

