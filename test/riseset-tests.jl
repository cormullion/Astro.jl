using Base.Test, Astro

println("15.a Rise, Set, Transit")
# Meeus chapter 15, pages 103
# Venus 1988 March 20, at Boston (long 71.0833, lat 42.333)
# sidereal time at Greenwich in degrees should be 11h50m58.10 177d.74208

# coordinates of venus at 0h TD
# march 19 RA 40d.68021 Dec = 18d.04761 
# march 20 RA 41.73129  Dec = 18d.44092
# march 21 RA 42.78204  Dec = 18d.82742

save_Lat = Astro.latitude
save_Long = Astro.longitude
set_longitude(deg2rad(71.0833))
set_latitude(deg2rad(42.3333))

println("using Longitude $(rad2deg(longitude))°" )
println("using Latitude $(rad2deg(latitude))°" )

println("Only low accuracy version currently available")

println("rise")
ut = cal_to_jd(1988, 3, 20)
ra = deg2rad(41.73129)
decl = deg2rad(18.44092)
# h0 is the 'standard' altitude, deg2rad(-0.5667) for stars/planets, deg2rad(-0.8333) for the sun
h0 = deg2rad(-0.5667)
jd_rise, jd_transit, jd_set = object_rts_low(ut, ra, decl, h0)
 
println("jd_rise $(fday_to_hms(jd_rise)), jd_transit $(fday_to_hms(jd_transit)), jd_set $(fday_to_hms(jd_set))")

#@test_approx_eq_eps(jd_rise - ut, 0.51766, 0.1)

println("")

# restore lat and long
set_longitude(save_Long)
set_latitude(save_Lat)
