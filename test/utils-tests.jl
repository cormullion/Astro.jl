using Base.Test, Astro

# references are to a book by Meeus

print("Degrees to Degrees Minutes Seconds")
@test(d_to_dms(45.5) == (45.0,30.0,0.0))
println(" passed")

print("7.a Convert Gregorian date to Julian day number")
jd = cal_to_jd(1957, 10, 4.81)
@test_approx_eq_eps(jd, 2436116.31, 0.01)
println(" passed")

print("7.b Convert Julian date to Julian day number")
jd = cal_to_jd(333, 1, 27.5, false)
@test_approx_eq_eps(jd, 1842713.0, 0.01)
println(" passed")

print("7.c Convert Julian day number to Gregorian date")
yr, mo, day = jd_to_cal(2436116.31)
@test(yr == 1957)
@test(mo == 10)
@test_approx_eq_eps(day, 4.81, 0.01)
println(" passed")

print("7.c(1) Convert Julian day number to Julian date")
yr, mo, day = jd_to_cal(1842713.0, false)
@test(yr == 333)
@test(mo == 1)
@test_approx_eq_eps(day, 27.5, 0.01)
println(" passed")

print("7.c(2) Convert Julian day number to Julian date")
yr, mo, day = jd_to_cal(1507900.13, false)
@test(yr == -584)
@test(mo == 5)
@test_approx_eq_eps(day, 28.63, 0.01)
println(" passed")

print("7.d Time interval in days")
jd0 = cal_to_jd(1910, 4, 20.0)
jd1 = cal_to_jd(1986, 2, 9.0)
@test(jd1 - jd0 == 27689)
println(" passed")

print("7.d(1) Time interval in days")
jd = cal_to_jd(1991, 7, 11)
jd = jd + 10000
yr, mo, day = jd_to_cal(jd)
@test(yr == 2018)
@test(mo == 11)
@test(day == 26)
println(" passed")

print("7.e Day of the week")
jd = cal_to_jd(1954, 6, 30.0)
@test(jd == 2434923.5)
dow = jd_to_day_of_week(jd)
@test(dow == 3)
println(" passed")

print("7.f Day of the year")
N = cal_to_day_of_year(1978, 11, 14)
@test(N == 318)
println(" passed")

print("7.g Day of the year")
N = cal_to_day_of_year(1988, 4, 22)
@test(N == 113)
println(" passed")

print("7(pg 66-1) Day of the year to calendar")
mo, day = day_of_year_to_cal(1978, 318)
@test(mo == 11)
@test(day == 14)
println(" passed")

print("7(pg 66-2) Day of the year to calendar")
mo, day = day_of_year_to_cal(1988, 113)
@test(mo == 4)
@test(day == 22)
println(" passed")

print("difference between angles")
diffr = diff_angle(pi/3, pi/5)
@test(diffr == 5.8643062867009474)
println(" passed")

print("difference between angles 2")
# TODO utils-test.jl check these results more
@test_approx_eq_eps(diff_angle(deg2rad(10), deg2rad(0)) |> rad2deg, 350, .1)
@test_approx_eq_eps(diff_angle(deg2rad(0), deg2rad(10)) |> rad2deg, 10, .1)
@test_approx_eq_eps(diff_angle(deg2rad(-10), deg2rad(10)) |> rad2deg, 20, .1)
println(" passed")

print("degree/minute/second to decimal degrees")
@test dms_to_d(10,45,0) == 10.75
@test dms_to_d(-10,45,0) == -10.75
println(" passed")

print("hangle to d")
@test hangle_to_dec_deg(5,0,0) == 75
@test hangle_to_dec_deg(12,0,0) == 180.0
@test_approx_eq_eps(hangle_to_dec_deg(23,55,55), 358.9791666666667, 0.0001)
println(" passed")

print("fractional day and hms day conversions")
@test fday_to_hms(0) == (0.0,0.0,0.0)
@test fday_to_hms(0.1) == (2.0,24.0,0.0)
@test fday_to_hms(0.2) == (4.0,48.0,0.0)
@test fday_to_hms(0.25) == (6.0,0.0,0.0)
@test fday_to_hms(0.5) == (12.0,0.0,0.0)
@test fday_to_hms(0.75) == (18.0,0.0,0.0)
@test fday_to_hms(0.99) == (23.0,45.0,36.0)
@test hms_to_fday(23.0, 45, 36) == 0.99
@test hms_to_fday(18.0, 0, 0) == 0.75
println(" passed")

print("3.1 Interpolation")
y = interpolate3(0.18125, [0.884226, 0.877366, 0.870531])
@test_approx_eq_eps(y, 0.876125, 1e-6)
@test_approx_eq_eps(interpolate_angle3(1, [0, 30,60]), 34.86725, 0.01)
@test_approx_eq_eps(interpolate_angle3(0, [0, 30,60]), 30.0, 0.01)
@test_approx_eq_eps(interpolate_angle3(-1, [0, 30,60]), 25.13, 0.01)
println(" passed")

print("polynomials")
@test @polynomial_horner(18, 7, 4, 1) == 403
@test polynomial([7, 4, 1], 18) == 403
@test_approx_eq_eps(@polynomial_horner(18, 9, 13, 7.4, 4, 1), 130944.59, .1)
@test_approx_eq_eps(polynomial((9, 13, 7.4, 4, 1), 18), 130944.6, .1)
println(" passed")
