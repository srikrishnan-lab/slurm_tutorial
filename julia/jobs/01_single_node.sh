#!/bin/bash
#SBATCH -J jl-hello
#SBATCH -p normal
#SBATCH -t 00:05:00
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

module purge

julia --project=julia julia/01_hello.jl
