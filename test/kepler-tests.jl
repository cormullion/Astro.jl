using Base.Test, Astro

# solve_kepler(mean_anomaly, eccentricity, desired_accuracy = 1e-6)

println("Kepler's equation")
print("Duffett-Smith PA with your Computer, page 116 ")

eccentric_anomaly = solve_kepler(deg2rad(201.7292), 0.016718) |> rad2deg
@test_approx_eq_eps(eccentric_anomaly, 201.38, .01)

eccentric_anomaly = solve_kepler(deg2rad(43.7172), 0.965) |> rad2deg
@test_approx_eq_eps(eccentric_anomaly, 98.41, .01)

# circular orbit 
eccentric_anomaly = solve_kepler(deg2rad(60), 0.0) |> rad2deg
@test_approx_eq_eps(eccentric_anomaly, 60, .001)

println("passed")
