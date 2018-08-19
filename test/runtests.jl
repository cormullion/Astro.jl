using Astro, Test

fatalerrors = length(ARGS) > 0 && ARGS[1] == "-f"
quiet = length(ARGS) > 0 && ARGS[1] == "-q"

anyerrors = false

push!(LOAD_PATH, "src")

loaddebugflag = false

my_tests = String[
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
]

println("...Running tests:")

passed = String[]
failed = String[]

for my_test in my_tests
    try
        include(my_test)
        println("$(my_test)")
        push!(passed, my_test)
    catch e
        global anyerrors = true
        push!(failed, my_test)
        println("$(my_test)")
        if fatalerrors
            rethrow(e)
        elseif !quiet
            showerror(stdout, e, backtrace())
            println()
        end
    end
end

for tst in passed
    printstyled("PASSED:\t", color=:green)
    println("$tst")
end

for tst in failed
    printstyled("FAILED:\t", color=:red)
    println("$tst")
end
