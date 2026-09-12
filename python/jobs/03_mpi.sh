#!/bin/bash
#SBATCH -J py-mpi
#SBATCH -p normal
#SBATCH -t 00:30:00
#SBATCH -N 2                  # nodes
#SBATCH -n 40                 # total MPI ranks
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

# mpi4py must be built against this MPI. Install it once, inside the venv,
# with these modules loaded:
#   module load gnu9 openmpi4 && pip install --no-binary=mpi4py mpi4py

module purge
module load gnu9 openmpi4
source ~/envs/tutorial/bin/activate

srun python python/03_mpi.py
