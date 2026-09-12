#!/bin/bash
#SBATCH -J jl-distributed
#SBATCH -p normal
#SBATCH -t 00:30:00
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

module purge

# Single node: -p starts that many worker processes on this node.
julia --project=julia -p "$((SLURM_CPUS_PER_TASK - 1))" julia/03_distributed.jl

# Across nodes, drop -p and use ClusterManagers.jl inside the script:
#     using ClusterManagers
#     addprocs(SlurmManager(parse(Int, ENV["SLURM_NTASKS"])))
# then submit with -N 2 -n 40 instead of -c 16.
