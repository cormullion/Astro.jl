# Astro

Some of Jan Meeus' astronomical formulas coded in Julia.

## Status

This is currently half-finished. Some of the tests pass, others fail. And more and better tests need to be written. I don't understand some of the code (which has been borrowed from all the different versions that are floating around on the Internet, in C, IDL,  Python, etc. Problems with the rise and set code especially, but see also the TODO annotated lines...
 
It's on my back burner until the syntax of Julia settles down a bit (they're going to change the dictionary syntax, for example, for version 0.4).

Contributions very welcome!

As of November 17 2014:

    $ cd Astro.jl/
    $ julia test/run-tests.jl

    ...
    Passed:
		PASSED:   calendar-tests.jl
		PASSED:   coordinates-test.jl
		PASSED:   dynamical-tests.jl
		PASSED:   earth-tests.jl
		PASSED:   kepler-tests.jl
		PASSED:   nutation-tests.jl
		PASSED:   pluto-tests.jl
		PASSED:   riseset-tests.jl
		PASSED:   sidereal-tests.jl
		PASSED:   utils-tests.jl
	 Failed:
 		FAILED:   moon-tests.jl
		FAILED:   equinox-tests.jl
		FAILED:   planet-tests.jl
		FAILED:   sun-tests.jl
	$

## Usage

	julia> using Astro
	loading files
	finished loading files

What are the right ascension and declination of a planet whose ecliptic coordinates are longitude 139°41'10" and latitude 4°52'31"?

	julia> ra, decl = ecl_to_equ(deg2rad(dms_to_d(139, 41, 10)),
	 	    				deg2rad(dms_to_d(4,52,31)), deg2rad(23.4392911));
	
	julia> ra_deg, decl_deg = map(rad2deg,(ra, decl));

	julia> d_to_dms(ra_deg/15) 
	
	(9,34,53.40627076542424)
	
	julia> d_to_dms(decl_deg)

	(19,32,14.2)
	
Calculate the topocentric RA and Dec of Mars on 2003 Aug 28 at 3h17m00 UT at Palomar, longitude 7h47m27s, altitude 1706. Mars' equatorial coordinates: RA 339.530208, decl -15.771083. 

	julia> ra, decl = geocentric_to_topocentric(
						deg2rad(33.356111), 
						1706,
						deg2rad(116.8625),
						deg2rad(339.530208),
						deg2rad(-15.771083), 0.37276,
						cal_to_jd(2003, 8, 28.136806))
	
	julia> rad2deg(ra) 	 # topocentric right ascension
	339.5
	
	julia> rad2deg(decl) # topocentric declination
	-15.775

What was the Right Ascension and Declination of the Moon on Feb 25 1979 at 16h00m UT?
 
	julia> jd = date_to_jd(1979,2,26,16,0,0);
	julia> geoecl_long, geoecl_lat, rad = moon_dimension3(jd);
	julia> ra_rad, dec_rad = ecl_to_equ(geoecl_long, 
			   geoecl_lat, obliquity(jd));
	julia> ra_deg = ra_rad / (2 * pi) |> fday_to_hms
	(22,33,29.10833089183143) # RA 22 33 29.1
   
What phase is the moon on October 31 2014:

	julia> jd = date_to_jd(2014,10,31,0,0,0);
	julia> moon_illuminated_fraction_high(jd)[1]
	0.48777635849493634

What age is it:

	julia> moon_age_location(jd)[1]
	7.302239900906831

## Functions

	aberration_low(R)
	apparent_longitude_low(jd, L)
	apparent_sidereal_time_greenwich(jd)
	astrology(body, jd)
	biorhythm(jd_origin, jd_current)
	cal_to_day_of_year(yr, mo, dy, gregorian=true)
	cal_to_jd_m(yr, mo, day, gregorian=true)
	cal_to_jd(yr, mo, day, gregorian=true)
	christian_to_moslem(X, M, D, gregorian=true)
	d_to_dms(x)
	date_to_jd(yr, mo, d, h, m, s, gregorian=true)
	day_of_year_to_cal(yr, N, gregorian=true)
	deltaT_seconds(jd::Float64)
	diff_angle(a, b)
	dms_to_d(deg, minute, second)
	dt_to_ut(jd::Float64)
	easter(yr, gregorian=true)
	eccent_E(T)
	ecl_to_equ(long, lat, obliquity)
	equ_to_ecl(ra, declin, obliquity)
	equ_to_horiz(H, decl)
	equation_time(jd)
	equinox_approx(yr, season)
	equinox(jd::Float64, season, delta)
	fday_to_hms(day)
	geocentric_planet(jd, planet, deltaPsi, epsilon, delta)
	geocentric_pluto(jd)
	geocentric_to_topocentric(phi, H, L, ra, decl, d, jd)
	geodesic_distance(L1, B1, L2, B2)
	geographical_to_geocentric_lat(phi, H)
	hangle_to_dec_deg(hour, minute, second)
	hangle_to_dec_deg(hour, minute, second)
	heliocentric_pluto(jd)
	hms_to_fday(hr, mn, seconds)
	interpolate_angle3(n, y)
	interpolate3(n, y)
	is_dst(jd::Float64)
	is_leap_year(yr, gregorian=true)
	jd_to_cal(jd::Float64, gregorian=true)
	jd_to_date(jd::Float64, gregorian=true)
	jd_to_day_of_week(jd::Float64)
	jd_to_jcent(jd::Float64)
	jewish_new_year(yr)
	load_planet_data(planet)
	longitude_radius_low(jd)
	lt_to_str(jd::Float64, zone="", level="second")
	lunation(jd::Float64, system=false)
	mean_sidereal_time_greenwich(jd)
	moon_age_location(jd::Float64)
	moon_altitude(jd::Float64)
	moon_apogee_perigee_time_low(jd::Float64, apo_nperi)
	moon_constants(T)
	moon_dimension(jd::Float64, dim)
	moon_dimension3(jd::Float64)
	moon_horizontal_parallax(jd::Float64)
	moon_illuminated_fraction_high(jd::Float64)
	moon_illuminated_fraction_low(jd::Float64)
	moon_latitude(jd::Float64)
	moon_longitude(jd::Float64)
	moon_mean_ascending_node_longitude(jd)
	moon_mean_perigee_longitude(jd::Float64)
	moon_nearest_phase(jd::Float64, phase=0)
	moon_node(jd::Float64, desc_not_asc)
	moon_radius(jd::Float64)
	moon_riseset(jd::Float64)
	moon_rst_altitude(r)
	moon_true_ascending_node_longitude(jd::Float64)
	moslem_to_christian(h, m, d)
	nut_in_lon(jd)
	nut_in_obl(jd)
	nut_in_ra(jd)
	nutation_constants(T)
	object_rts_low(jd, ra, decl, h0)
	obliquity_high(jd)
	obliquity(jd)
	pesach(yr, gregorian=true)
	planet_dimension(jd, planet_data_dim)
	polynomial(coefficients, x)
	quadratic_interpolation(x_list, y_list)
	quadratic_roots(a, b, c)
	radianstime_to_fday(tr)
	rectangular_md(jd)
	set_latitude(lat)
	set_longitude(long)
	solve_kepler(mean_anomaly, eccentricity, desired_accuracy = 1e-6)
	sun_dimension3(jd)
	tdt_to_bdt(tt, jd)
	true_obliquity(jd)
	ut_to_lt(jd::Float64)
	vsop_to_fk5(jd, L, B)
	vsop87d_dimension(jd, planet)
