# Multi-process parallelism. Each worker is a separate Julia process, so this
# also works across nodes (see the job script for the multi-node variant).
#
# Prefer threads (02) when one node is enough: workers each pay full startup
# and package-load cost.

using Distributed

# Workers are added by `julia -p` in the job script; nworkers() reflects that.
@everywhere begin
    using Random
    function run_member(seed)
        rng = MersenneTwister(seed)
        sum(randn(rng, 100_000)) / 100_000
    end
end

println("running on $(nworkers()) workers")
results = pmap(run_member, 1:64)
println("completed $(length(results)) members")
