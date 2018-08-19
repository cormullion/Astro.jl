# Astro - astronomy formulas and some time/date code in Julia

This module tried to implement some of Jan Meeus' astronomical formulas.

A better and more comprehensive library of astronomical routines can be found at [JuliaAstro/AstroLib](https://github.com/JuliaAstro/AstroLib.jl).

## Usage

```
using Astro
```

What was the Right Ascension and Declination of the Moon on Feb 25 1979 at 16h00m UT?

```
jd = date_to_jd(1979,2,26,16,0,0);
geoecl_long, geoecl_lat, rad = moon_dimension3(jd);
ra_rad, dec_rad = ecl_to_equ(geoecl_long, geoecl_lat, obliquity(jd));
ra_deg = ra_rad / 2pi |> fday_to_hms
#-> (22, 33, 29.10833089183143) # RA 22 33 29.1
```

What phase is the moon on October 31 2014:

```
jd = date_to_jd(2014,10,31,0,0,0);
moon_illuminated_fraction_high(jd)[1]
#-> 0.48777635849493634
```

What age is it:

```moon_age_location(jd)[1]
#-> 7.302239900906831
```

Current Greenwich Sidereal Time:

```
apparent_sidereal_time_greenwich(Dates.datetime2julian(now())) |> radianstime_to_fday |> fday_to_hms

#-> (7, 55, 41.038224676074606) or 7:55:41
```
