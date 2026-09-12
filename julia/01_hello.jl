# Smallest possible job: confirm the environment is what you think it is.
println("host          : ", gethostname())
println("julia         : ", VERSION)
println("job id        : ", get(ENV, "SLURM_JOB_ID", "not in a job"))
println("threads       : ", Threads.nthreads())
println("cpus per task : ", get(ENV, "SLURM_CPUS_PER_TASK", "unset"))
