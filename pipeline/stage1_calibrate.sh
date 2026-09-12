#!/bin/bash
#SBATCH -J stage1-calibrate
#SBATCH -p normal
#SBATCH -t 01:00:00
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

module purge
source ~/envs/tutorial/bin/activate

echo "stage 1: calibrate"
# python calibrate.py --out calibration.nc
