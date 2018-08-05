using Test, Astro

# earth tests from meeus chapter 11

print("Geodesic distance")
# geodesic distance between Paris and Washington observatories 
# should be 6181.628423726299 km

d = geodesic_distance(deg2rad(dms_to_d(-2, 20, 14)),deg2rad(dms_to_d(48, 50, 11)), deg2rad(dms_to_d(77,3,56)), deg2rad(dms_to_d(38,55,17)))
@test isapprox(d, 6181.6, atol=.1)
println(" passed")

print("Geocentric latitude")
# p sin phi and p cos phi 
 
r = geographical_to_geocentric_lat(deg2rad(dms_to_d(33, 21, 22)), 1706)
# TODO earth-tests.jl Is this accurate enough?
@test rad2deg(r[1]) ≈  33.356111 atol= .2# <<<----------------------?
@test isapprox(r[2], 0.546, atol=.1)
@test isapprox(r[3], 0.83, atol=.1)
println(" passed")
