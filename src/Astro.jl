module Astro

println("loading files")

global dname = dirname(Base.source_path()) # used in vsop87d.jl to load data

if VERSION <= v"0.4"
    using Dates
else
    using Base.Dates
end

# to check loading files progress, set this to true:
loaddebugflag = false

files = {
        "constants.jl",
        "global.jl",
        "utils.jl",
        "calendar.jl",
        "coordinates.jl",
        "dynamical.jl",
        "earth.jl",
        "equinox.jl",
        "kepler.jl",
        "moon.jl",
        "nutation.jl",
        "pluto.jl",
        "pseudoscience.jl",
        "riseset.jl",
        "sidereal.jl",
        "sun.jl",
        "vsop87d.jl"
        }

for f in files
    if loaddebugflag
        tic()
        println("starting to include $f")
    end
    include(f)
    if loaddebugflag
       print("  finished loading $f")
       toc()
    end
end

println("finished loading files")

# set location to London
set_latitude(deg2rad(52))
set_longitude(deg2rad(0))

end
