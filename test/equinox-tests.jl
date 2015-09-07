using Base.Test, Astro

# equinox tests from meeus chapter

print("27.a Approximate solstice")
eqa = equinox_approx(1962, "summer")
y, m , d = jd_to_cal(eqa)

@test y == 1962
@test m == 6
@test_approx_eq_eps(d, 21, 1)

println(" passed")

print("27.a Finding nearest Equinox for 12 January 2007")
jd = cal_to_jd(2007,1,12)
eq = equinox(jd, "Spring", 1) # return jd of equinox to the nearest day

y, m , d = jd_to_cal(eq)
@test y == 2007
@test m == 3
@test_approx_eq_eps(d, 21, 1)

println(" passed")

