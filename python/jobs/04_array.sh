#!/bin/bash
#SBATCH -J py-ensemble
#SBATCH -p normal
#SBATCH -t 00:20:00
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --array=1-500%50      # 500 members, at most 50 running at once
#SBATCH -o logs/%x-%A_%a.out
#SBATCH -e logs/%x-%A_%a.err

# The %50 throttle is not optional politeness: four groups share this
# cluster, and an unthrottled 500-task array will fill it.

module purge
source ~/envs/tutorial/bin/activate

python python/04_array_member.py --outdir output
