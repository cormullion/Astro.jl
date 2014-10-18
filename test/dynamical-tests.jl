using Base.Test, Astro

println("10.1 Dynamical Time and Universal Time")
# UT is based on the rotation of the earth, but the earth is slowing down and irregular in its orbital habits..
# DynamicalTime is related to Ephemeris time, but changes year to year.
# For example, 1990 January 27, 0h UT is 57 seconds later than 1990 January 27, 0h TD.
jd = cal_to_jd(1990,1,27) + hms_to_fday(0,0,0)
@test_approx_eq_eps(jd, 2.4479185e6, 0.1)
deltat = deltaT_seconds(jd)
@test_approx_eq_eps(deltat, 57, 1) # accurate to a second -— good enough?
println(" passed")

println("10.2 Dynamical Time and Universal Time")
# New Moon took place on 1977 Feburary 18 at 3h37m40s
# deltaT was equal to +48 seconds, correpsonding UT time is 3h36m52s
jd = cal_to_jd(1977,2,18) + hms_to_fday(3,37,40)
deltat = deltaT_seconds(jd)
@test_approx_eq_eps(deltat, 48, 1)
println(" passed")
