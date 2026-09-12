# One ensemble member, selected by the Slurm array task ID.
#
# The workhorse pattern for this group: independent members, one task each,
# scheduled and retried individually.

using Random, JSON3

member = parse(Int, get(ENV, "SLURM_ARRAY_TASK_ID", "1"))
outdir = get(ENV, "OUTDIR", "output")

# Seed from the member index so the run is reproducible and members differ.
rng = MersenneTwister(member)
result = (member = member, mean = sum(randn(rng, 1000)) / 1000)

mkpath(outdir)
out = joinpath(outdir, "member_" * lpad(member, 5, '0') * ".json")
open(out, "w") do io
    JSON3.write(io, result)
end
println("wrote ", out)
