# nicked from DataFrames
fatalerrors = length(ARGS) > 0 && ARGS[1] == "-f"
quiet = length(ARGS) > 0 && ARGS[1] == "-q"
anyerrors = false

push!(LOAD_PATH, "src")

using Astro
using Base.Test
using Compat

loaddebugflag = false

my_tests = Array([
    "calendar-tests.jl",
    "coordinates-test.jl",
    "dynamical-tests.jl",
    "earth-tests.jl",
    "equinox-tests.jl",
    "kepler-tests.jl",
    "moon-tests.jl",
    "nutation-tests.jl",
    "planet-tests.jl",
    "pluto-tests.jl",
    "riseset-tests.jl",
    "sidereal-tests.jl",
    "sun-tests.jl",
    "utils-tests.jl"
])

println("Running tests:")

passed = []
failed = []

for my_test in my_tests
    try
        include(my_test)
        println("\t\033[1m\033[32mPASSED\033[0m: $(my_test)")
        push!(passed, my_test)
    catch e
        anyerrors = true
        push!(failed, my_test)
        println("\t\033[1m\033[31mFAILED\033[0m: $(my_test)")
        if fatalerrors
            rethrow(e)
        elseif !quiet
            showerror(STDOUT, e, backtrace())
            println()
        end
    end
end

println("Passed:")
for tst in passed
    println("\t\033[1m\033[32mPASSED\033[0m:   $tst")
end

println("Failed:")
for tst in failed
    println("\t\033[1m\033[31mFAILED\033[0m:   $tst")
end

