#!/bin/bash
#SBATCH -J jl-threads
#SBATCH -p normal
#SBATCH -t 00:30:00
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

module purge

# -t reads the Slurm allocation rather than hard-coding a thread count.
julia --project=julia -t "$SLURM_CPUS_PER_TASK" julia/02_threads.jl
