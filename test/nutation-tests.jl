using Base.Test, Astro

# references are to a book by Meeus

print("22.a Nutation (delta psi)")
deltaPsi = nut_in_lon(2446895.5)
d, m, s = d_to_dms(rad2deg(deltaPsi))
@test(d == 0)
@test(m == 0)
@test_approx_eq_eps(s, -3.788, 0.001)
println(" passed")

print("22.a Nutation (delta epsilon)")
deltaEps = nut_in_obl(2446895.5)
d, m, s = d_to_dms(rad2deg(deltaEps))
@test(d == 0)
@test(m == 0)
@test_approx_eq_eps(s, 9.443, 0.001)
println(" passed")

print("22.a Nutation (epsilon)")
eps = obliquity(2446895.5)
d, m, s = d_to_dms(rad2deg(eps))
@test(d == 23)
@test(m == 26)
@test_approx_eq_eps(s, 27.407, 0.001)
println(" passed")

print("22.a Nutation (epsilon - high precision)")
eps = obliquity_high(2446895.5)
d, m, s = d_to_dms(rad2deg(eps))
@test(d == 23)
@test(m == 26)
@test_approx_eq_eps(s, 27.407, 0.001)
println(" passed")
