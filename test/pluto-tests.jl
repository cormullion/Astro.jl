using Astro,Test

print("37.a (1) heliocentric coordinates of Pluto")
L, B, R = heliocentric_pluto(2448908.5)
@test round(B, digits=5) ≈ 14.58782 atol=0.1
@test round(L, digits=5) ≈ 232.74071 atol=0.1
@test round(R, digits=6) ≈ 29.71111 atol=0.1
println(" passed")
