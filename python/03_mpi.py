"""Parallelise across multiple nodes with MPI.

Use this only when the work genuinely will not fit on one node. A job array
(04) is simpler and schedules faster for independent tasks.
"""
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank, size = comm.Get_rank(), comm.Get_size()

local = rank ** 2
total = comm.reduce(local, op=MPI.SUM, root=0)

print(f"rank {rank} of {size} on {MPI.Get_processor_name()}")
if rank == 0:
    print(f"sum of squares: {total}")
