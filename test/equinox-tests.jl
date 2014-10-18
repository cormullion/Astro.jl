using Base.Test, Astro

# equinox tests from meeus chapter

print("Finding nearest Equinox for 12 January 2007")
jd = cal_to_jd(2007,1,12)
eq = equinox(jd, "Spring", 1) # to the nearest day
#println("Nearest spring equinox to 2007/1/12 is $(jd_to_cal(eq))")
#println(jd_to_cal(eq))
@test_approx_eq_eps(jd_to_cal(eq), 6181.6, .1)
println(" passed")

print("27.a Approximate solstice")
jd = equinox_approx(1962, "summer")
@test_approx_eq_eps(jd, 2437837.39245, .1)
println(" passed")
