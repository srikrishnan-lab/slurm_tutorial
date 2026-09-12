#!/bin/bash
#SBATCH -J stage2-simulate
#SBATCH -p normal
#SBATCH -t 00:30:00
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --array=1-200%40
#SBATCH -o logs/%x-%A_%a.out
#SBATCH -e logs/%x-%A_%a.err

module purge
source ~/envs/tutorial/bin/activate

echo "stage 2: member $SLURM_ARRAY_TASK_ID"
# python simulate.py --member "$SLURM_ARRAY_TASK_ID" --calibration calibration.nc
