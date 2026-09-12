#!/bin/bash
#SBATCH -J py-pool
#SBATCH -p normal
#SBATCH -t 00:30:00
#SBATCH -n 1                  # one process...
#SBATCH -c 16                 # ...with 16 CPUs for its worker pool
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

# Hyperthreading is on, so 16 CPUs is 8 physical cores. Add
# --ntasks-per-core=1 if you would rather count physical cores.

module purge
source ~/envs/tutorial/bin/activate

python python/02_multiprocessing.py
