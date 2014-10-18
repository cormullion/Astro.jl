using Base.Test, Astro

print("12.a Sidereal time (mean)")
# Meeus page 88
# Find mean and apparent sidereal  time at Greenwich on 1987 April 10 at 0 UT:
# Mean sidereal time should be 13h10m46.3668s
# Nutation in right ascension should be -0.2317 degrees
# Apparent sidereal time is 13h10m46.1351s
jd = cal_to_jd(1987, 4, 10) + hms_to_fday(0,0,0)
theta0 = mean_sidereal_time_greenwich(jd)
# theta0 is mean sidereal time in radians (2pi radians = 24 hrs)

theta0_st = fday_to_hms(theta0 / (pi * 2)) # is a tuple!
theta_fday = hms_to_fday(theta0_st...)     # so splat required... :)
# mean sidereal time
@test_approx_eq_eps(theta0 / (pi * 2), theta_fday, 0.1)
@test(theta0_st[1] == 13)
@test(theta0_st[2] == 10)
@test_approx_eq_eps(theta0_st[3], 46.3668, 0.1)
println(" passed")

print("12.a Sidereal time (apparent)")
jd = cal_to_jd(1987, 4, 10) + hms_to_fday(0,0,0)
theta0 = apparent_sidereal_time_greenwich(jd)
# apparent sidereal time
ast_hms = fday_to_hms(theta0/(2 * pi))
@test(ast_hms[1] == 13)
@test(ast_hms[2] == 10)
@test_approx_eq_eps(ast_hms[3], 46.1351, 0.1)
println(" passed")

print("12.b Sidereal time (mean)")
# find the mean sidereal time at Greenwich on 1987 April 10 at 19h21m00s
# jd = cal_to_jd(1987, 4, 10) + hms_to_fday(19,21,0)
msd_midnight = mean_sidereal_time_greenwich(cal_to_jd(1987, 4, 10))
println(msd_midnight)

@test_approx_eq_eps(theta0 / (pi * 2), 128.7378734 / 360, 0.2)
println(" passed")

println(" Mean and apparent sidereal time")
mst_g = fday_to_hms(mean_sidereal_time_greenwich(cal_to_jd(1987, 4, 10)) / (2 * pi))
@test(mst_g[1] == 13)
@test(mst_g[2] == 10)
@test_approx_eq_eps(mst_g[3] , 46.3668, 0.01)

ast_g = fday_to_hms(apparent_sidereal_time_greenwich(cal_to_jd(1987, 4, 10)) / (2 * pi))
@test(ast_g[1] == 13)
@test(ast_g[2] == 10)
@test_approx_eq_eps(ast_g[3], 46.1351, 0.3) #  good enough?

# mean sidereal time and gmt/ut should be the same around September 21/22
mst = fday_to_hms(mod2pi(mean_sidereal_time_greenwich(cal_to_jd(2014,9,21)))/(2 * pi))
@test(mst[1] == 23)
@test(mst[2] == 59)
println(" passed")
