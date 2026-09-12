#!/bin/bash
#SBATCH -J stage3-postprocess
#SBATCH -p normal
#SBATCH -t 00:20:00
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

module purge
source ~/envs/tutorial/bin/activate

echo "stage 3: postprocess"
# python postprocess.py --indir output --out summary.nc
