# Shared-memory parallelism across the cores of a single node.
#
# Thread count comes from `julia -t` in the job script, which reads
# SLURM_CPUS_PER_TASK. Do not hard-code it.

using Random

function run_member(seed)
    rng = MersenneTwister(seed)
    sum(randn(rng, 100_000)) / 100_000
end

n = 64
results = zeros(n)

println("running on $(Threads.nthreads()) threads")
Threads.@threads for i in 1:n
    results[i] = run_member(i)
end

println("completed $(length(results)) members")
