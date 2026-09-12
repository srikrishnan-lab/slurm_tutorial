#!/bin/bash
#SBATCH -J py-hello
#SBATCH -p normal
#SBATCH -t 00:05:00
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o logs/%x-%j.out
#SBATCH -e logs/%x-%j.err

module purge
source ~/envs/tutorial/bin/activate

python python/01_hello.py
