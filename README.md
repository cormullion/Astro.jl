# Astro - astronomy formulas

This module implement some of Jan Meeus' astronomical formulas in Julia.

It was written while I was learning Julia version 0.2 and 0.3, and some of the code looks to have aged poorly, although it kind of runs OK in Julia version 1.0.

A much better and more comprehensive library of astronomical routines can be found at [JuliaAstro/AstroLib](https://github.com/JuliaAstro/AstroLib.jl).

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

What is the current phase of the moon:

```
jd = Dates.datetime2julian(now())
moon_illuminated_fraction_high(jd)[1]

#-> 0.12195292764741428
```

What age is it:

```moon_age_location(jd)[1]
#-> 26.54878954261963
```

What is the current Greenwich Sidereal Time:

```
apparent_sidereal_time_greenwich(Dates.datetime2julian(now())) |> radianstime_to_fday |> fday_to_hms

#-> (7, 55, 41.038224676074606) or 7:55:41
```

Calculate the apparent position of Venus on 1992 December 20. Apparent RA should be 316.172791 = 21h.078194 = 21h04m41.50. Apparent Declination should be -18.88801 = -18d53m16.8s.

```
using Astro, Dates
jd = Dates.datetime2julian(Dates.DateTime(1992, 12, 20, 0, 0, 0))

ra, decl = geocentric_planet(jd, "Venus", nut_in_lon(jd), obliquity_high(jd) , days_per_second)

dayfraction = radianstime_to_fday(ra)

println("Right Ascension: ", fday_to_hms(dayfraction))

Right Ascension: (21, 4, 43.468973979426664)

println("Declination: ", rad2deg(decl))

Declination: -18.88572837948753
```

## Reference

Jean Meeus, _Astronomical Algorithms_, second edition, 1998, Willmann-Bell, Inc.
