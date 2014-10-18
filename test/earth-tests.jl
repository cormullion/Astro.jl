using Base.Test, Astro

# earth tests from meeus chapter 11

print("Geodesic distance")
# geodesic distance between Paris and Washington observatories 
# should be 6181.628423726299 km

d = geodesic_distance(deg2rad(dms_to_d(-2, 20, 14)),deg2rad(dms_to_d(48, 50, 11)), deg2rad(dms_to_d(77,3,56)), deg2rad(dms_to_d(38,55,17)))
@test_approx_eq_eps(d, 6181.6, .1)
println(" passed")

print("Geocentric latitude")
# p sin phi and p cos phi 
 
r = geographical_to_geocentric_lat(deg2rad(dms_to_d(33, 21, 22)), 1706)
# TODO earth-tests.jl Is this accurate enough?
@test_approx_eq_eps(rad2deg(r[1]), 33.356111, .2) # <<<----------------------?
@test_approx_eq_eps(r[2], 0.546, .1)
@test_approx_eq_eps(r[3], 0.83, .1)
println(" passed")
