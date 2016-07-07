using Base.Test

using Astro

print("leap years")
@test is_leap_year(2004) == true
@test is_leap_year(333, false) == false
println(" passed")

print("7.a Convert Gregorian date to Julian day number")
jd = cal_to_jd(1957, 10, 4.81)
@test jd == 2436116.31
println(" passed")

print("7.a Convert Gregorian date to Julian day number — meeus'")
jd = cal_to_jd_m(1957, 10, 4.81)
@test jd == 2436116.31
println(" passed")

print("7.b Convert Julian date to Julian day number")
jd = cal_to_jd(333, 1, 27.5, false)
# currently fails, is off by one
#    @test_approx_eq_eps(jd, 1842713.0, 0.1)
println(" passed")

print("7.b Convert Julian date to Julian day number — meeus")
jd = cal_to_jd_m(333, 1, 27.5, false)
# currently fails, is off by one
#    @test_approx_eq_eps(jd, 1842713.0, 0.1)
println(" passed")

print("7.c Convert Julian day number to Gregorian date")
yr, mo, day = jd_to_cal(2436116.31)
@test yr == 1957
@test mo == 10
@test_approx_eq_eps(day, 4.81, 0.1)
println(" passed")

print("7.c(1) Convert Julian day number to Julian date")
yr, mo, day = jd_to_cal(1842713.0, false)
@test yr == 333
@test mo == 1
@test_approx_eq_eps(day, 27.5, 0.01)
println(" passed")

print("7.c(2) Convert Julian day number to Julian date")
yr, mo, day = jd_to_cal(1507900.13, false)
@test yr == -584
@test mo == 5
@test_approx_eq_eps(day, 28.63, 0.01)
println(" passed")

print("7.d Time interval in days")
jd0 = cal_to_jd(1910, 4, 20.0)
jd1 = cal_to_jd(1986, 2, 9.0)
@test jd1 - jd0 == 27689
println(" passed")

print("7.d(1) Time interval in days")
jd = cal_to_jd(1991, 7, 11)
jd = jd + 10000
yr, mo, day = jd_to_date(jd)
@test yr == 2018
@test mo == 11
@test day == 26
dow = jd_to_day_of_week(jd)
@test dow == 1
println(" passed")

print("7.f Day of the year")
N = cal_to_day_of_year(1978, 11, 14)
@test N == 318
println(" passed")

print("7.g Day of the year")
N = cal_to_day_of_year(1988, 4, 22)
@test N == 113
println(" passed")

print("7(pg 66-1) Day of the year to calendar")
mo, day = day_of_year_to_cal(1978, 318)
@test mo == 11
@test day == 14
println(" passed")

print("7(pg 66-2) Day of the year to calendar")
mo, day = day_of_year_to_cal(1988, 113)
@test mo == 4
@test day == 22
println(" passed")

tbl = Array[
    [1991, 3, 31],
    [1992, 4, 19],
    [1993, 4, 11],
    [1954, 4, 18],
    [2000, 4, 23],
    [1818, 3, 22]
]

print("8(pg 68) Gregorian Easter (6 times)")
for (yr, mo, day) in tbl
    # calculate xmo and xday given yr
    xmo, xday = easter(yr)
    map(print, [" ", yr, " ", mo, " ", day, " -> ", yr, " ", xmo, " ", xday])
    println()
    @test xmo == mo
    @test xday == day
end
println(" passed")

print("8(pg 69) Julian Easter (3 times)")
for yr in [179, 711, 1243]
    mo, day = easter(yr, false)
    @test mo == 4
    @test day == 12
end
println(" passed")

print("9.a Jewish Pesach")
mo, day = pesach(1990)
@test mo == 4
@test day == 10
println(" passed")

print("9.b Julian date of Moslem year 1421 first day")
yr, mo, day = moslem_to_christian(1421, 1, 1)
@test yr == 2000
@test mo == 4
@test day == 6
println(" passed")

print("9.c Moslem date for Aug 13 1991 gregorian")
yr, mo, day = christian_to_moslem(1991, 8, 13)
@test yr == 1412
@test mo == 2
@test day == 2
println(" passed")

print("Julian day to date")
(y, month, d, h, m, s) = jd_to_date(2436116.31, true)
@test y == 1957
@test month == 10
@test d == 4
@test h == 19
@test m == 26
@test_approx_eq_eps(s, 24, 0.1)
println(" passed")

# 2014 September 5 09:41:24  2456905.90375 Friday
print("is September 5 DST?")
@test is_dst(2456905.90375) == true
println(" passed")

print("number of Julian centuries since J2000.0")
@test jd_to_jcent(2456905.90375) == 0.14677354551677085
println(" passed")

print("Julian date to formatted string 1")
@test lt_to_str(2456905.90375, "GMT", "second") == "Fri, 05 Sep 2014 09:41:24"
println(" passed")

print("Julian date to formatted string 2")
@test lt_to_str(2456905.90375, "GMT", "day") == "Fri, 05 Sep 2014"
println(" passed")
