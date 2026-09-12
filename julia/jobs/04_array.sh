#!/bin/bash
#SBATCH -J jl-ensemble
#SBATCH -p normal
#SBATCH -t 00:20:00
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --array=1-500%50
#SBATCH -o logs/%x-%A_%a.out
#SBATCH -e logs/%x-%A_%a.err

module purge

export OUTDIR=output

# Precompilation is per-process, so every array task pays it. For large
# arrays consider building a sysimage with PackageCompiler.jl first.
julia --project=julia julia/04_array_member.jl
