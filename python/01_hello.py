"""Smallest possible job: confirm the environment is what you think it is."""
import os
import platform
import sys

print(f"host          : {platform.node()}")
print(f"python        : {sys.version.split()[0]}")
print(f"job id        : {os.environ.get('SLURM_JOB_ID')}")
print(f"cpus per task : {os.environ.get('SLURM_CPUS_PER_TASK')}")
