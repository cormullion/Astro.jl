using Astro, Base.Test

print("37.a (1) heliocentric coordinates of Pluto")
L, B, R = heliocentric_pluto(2448908.5)
@test_approx_eq_eps(round(B, 5),  14.58782, 0.1)
@test_approx_eq_eps(round(L, 5), 232.74071, 0.1)
@test_approx_eq_eps(round(R, 6),  29.71111, 0.1)
println(" passed")
