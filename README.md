# Astro - astronomy formulas

This module implement some of Jan Meeus' astronomical formulas in Julia.

It was written while I was learning Julia version 0.2 and 0.3, and some of the code looks to have aged poorly, although it runs OK in Julia version 1.0.

A better and more comprehensive library of astronomical routines can be found at [JuliaAstro/AstroLib](https://github.com/JuliaAstro/AstroLib.jl).

## Usage

```
using Astro
```

What was the Right Ascension and Declination of the Moon on Feb 25 1979 at 16h00m UT?

```
jd = date_to_jd(1979, 2, 26, 16, 0, 0);

geoecl_long, geoecl_lat, rad = moon_dimension3(jd);

ra_rad, dec_rad = ecl_to_equ(geoecl_long, geoecl_lat, obliquity(jd));

ra_deg = ra_rad / 2pi |> fday_to_hms

#-> (22, 33, 29.10833089183143) # RA 22 33 29.1
```

What phase is the moon on October 31 2014:

```
jd = date_to_jd(2014, 10, 31, 0, 0, 0);
 moon_illuminated_fraction_high(jd)[1]

#-> 0.48777635849493634
```

What age is it:

```moon_age_location(jd)[1]
#-> 7.302239900906831
```

What is the current Greenwich Sidereal Time:

```
apparent_sidereal_time_greenwich(Dates.datetime2julian(now())) |> radianstime_to_fday |> fday_to_hms

#-> (7, 55, 41.038224676074606) or 7:55:41
```

Where is Mercury at the moment?

```
println("Right Ascension: ", fday_to_hms(radianstime_to_fday(ra)))
# (8, 53, 12.632065656522173)

println("Declination: ", rad2deg(decl))
#  Declination: 14.963269087821232
```
JPL give Right Ascension: 08h 53m 01.4s and Declination: 15° 12' 04.5"

## Reference

Jean Meeus, _Astronomical Algorithms_, second edition, 1998, Willmann-Bell, Inc.
