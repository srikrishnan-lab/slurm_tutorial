"""Parallelise across the cores of a single node with multiprocessing.

The pool size comes from Slurm rather than from os.cpu_count(): the latter
reports every core on the machine, including ones your job was not given.
"""
import os
import time
from multiprocessing import Pool


def run_member(seed):
    """Stand-in for one ensemble member."""
    time.sleep(0.5)
    return seed, seed ** 2


def n_workers():
    # Slurm sets this when you ask for -c/--cpus-per-task.
    return int(os.environ.get("SLURM_CPUS_PER_TASK", 1))


if __name__ == "__main__":
    workers = n_workers()
    print(f"running on {workers} workers")
    with Pool(workers) as pool:
        results = pool.map(run_member, range(64))
    print(f"completed {len(results)} members")
