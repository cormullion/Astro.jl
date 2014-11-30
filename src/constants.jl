export
    earth_pol_to_equ_radius, 
    earth_flattening, 
    earth_equ_radius, 
    minutes_per_day, 
    days_per_minute, 
    seconds_per_day, 
    days_per_second, 
    km_per_au, 
    standard_rst_altitude, 
    sun_rst_altitude
    
# Don't change these unless you are moving to a new universe.

# Ratio of Earth's polar to equatorial radius.
global earth_pol_to_equ_radius = 0.99664719

# Earth flattening
global earth_flattening = 1/298.257

# Equatorial radius of the Earth in km.
global earth_equ_radius = 6378.14

# How many minutes in a day?
global minutes_per_day = 24 * 60

# How many days in minute?
global days_per_minute = 1 / minutes_per_day

# How many seconds (time) in a day?
global seconds_per_day = 24 * 60 * 60

# How many days in a second?
global days_per_second = 1 / seconds_per_day

# How many kilometres in an astronomical unit?
global km_per_au = 149597870

# For rise-set-transit: altitude deflection caused by refraction
global standard_rst_altitude = -0.00989078087105 # -0.5667 degrees
global sun_rst_altitude      = -0.0145438286569       # -0.8333 degrees
