# Slurm examples for Hopper

Worked job scripts for [Hopper](https://portal.cac.cornell.edu/techdocs/clusters/Hopper/), the cluster shared by the Srikrishnan, Reed, Steinschneider, and Anderson groups.

Each example is a Slurm script plus the small program it runs, in both Julia and Python, ordered from the simplest thing that works to the patterns this group actually uses day to day.

For getting an account, connecting, remote editing, and cluster etiquette, see **[Using Hopper](https://viveks.bee.cornell.edu/lab-manual/guides/hopper-access.html)** in the lab manual. This repository is only about running things.

## What's here

| | Julia | Python | Use it when |
|---|---|---|---|
| **1. Single node, one core** | [`julia/jobs/01_single_node.sh`](julia/jobs/01_single_node.sh) | [`python/jobs/01_single_node.sh`](python/jobs/01_single_node.sh) | Checking your environment; anything serial |
| **2. One node, many cores** | [`02_threads.sh`](julia/jobs/02_threads.sh) | [`02_multiprocessing.sh`](python/jobs/02_multiprocessing.sh) | Work that fits on one node |
| **3. Many nodes** | [`03_distributed.sh`](julia/jobs/03_distributed.sh) | [`03_mpi.sh`](python/jobs/03_mpi.sh) | Work that genuinely will not fit on one node |
| **4. Job array** | [`04_array.sh`](julia/jobs/04_array.sh) | [`04_array.sh`](python/jobs/04_array.sh) | Independent members: ensembles, sweeps, replicates |
| **5. Chained stages** | [`pipeline/`](pipeline/) | same | Multi-stage workflows with dependencies |

Run everything from the repository root, so the relative paths in the scripts resolve:

```bash
mkdir -p logs
sbatch python/jobs/01_single_node.sh
squeue -u $USER
```

`logs/` must exist before you submit. Slurm will not create it, and the job fails immediately if it is missing.

## Which pattern do I want?

**Start with the job array.** Most of what this group runs is an ensemble of independent tasks — Monte Carlo replicates, parameter sweeps, one run per scenario. An array is the right tool, and it beats the alternatives on every axis that matters: Slurm schedules tasks into gaps as they open, a failed member can be resubmitted alone, and you are not holding a large allocation while most of it idles.

Reach for **threads or multiprocessing** when one task needs several cores, and for **MPI or Julia's `Distributed`** only when the work genuinely does not fit on a node. Multi-node parallelism is harder to debug and waits longer in the queue; do not pay that cost until you have to.

If you are unsure whether your problem parallelises at all, that is worth asking about before you queue anything. Most MCMC does not. Approximate Bayesian Computation, pre-calibration, and particle filtering do.

## Hopper specifics

**Partitions.** `normal` has no time limit; `guest` is capped at 48 hours. Set `-t` to something realistic anyway — a hung job with no limit holds resources the rest of the cluster wants.

**Hyperthreading is on.** Slurm counts each physical core as two CPUs, so `-c 16` is 8 physical cores. Add `--ntasks-per-core=1` if you would rather count physical cores.

**Throttle your arrays.** `--array=1-500%50` runs at most 50 tasks at once. Four groups share this cluster; an unthrottled 500-task array will fill it. If you need a large fraction of Hopper for a while, tell the other groups first.

**`$HOME` is NFS, and it is not backed up.** Jobs doing heavy file I/O should stage through node-local `/tmp` and copy results back at the end — CAC is emphatic about this, and it matters most for arrays, where the multiplier is the number of concurrent tasks. Nothing on Hopper is backed up by anyone, so anything you cannot cheaply regenerate belongs somewhere else too.

**Never compute on the head node.** CAC's stated consequence is that your privileges are revoked. For interactive work:

```bash
srun -p normal -n 1 -c 8 --pty /bin/bash -l
```

## Setting up

**Python.** Hopper has no `python3` module and ships a system Python 3.6, so build a virtual environment:

```bash
python3 -m venv ~/envs/tutorial
source ~/envs/tutorial/bin/activate
pip install --upgrade pip
pip install -r python/requirements.txt
```

`mpi4py` is only needed for example 3 and must be built against the cluster's MPI — `module load gnu9 openmpi4` before installing it.

**Julia.** A `julia` module exists but may lag; installing [`juliaup`](https://github.com/JuliaLang/juliaup) in your home directory gives you control of the version, which is what you want for a project with a committed `Manifest.toml`.

```bash
julia --project=julia -e 'using Pkg; Pkg.instantiate()'
```

Every array task pays Julia's precompilation cost separately. For large arrays, consider a sysimage built with `PackageCompiler.jl`.

## Monitoring

```bash
squeue -u $USER                 # what is queued and running
scontrol show job <job_id>      # why is it pending
scancel <job_id>                # cancel; add _<task> for one array task
sacct -j <job_id>               # what a finished job used, if configured
```

`sacct` and `seff` are standard Slurm but are not in CAC's documentation for Hopper, so they may or may not be available here.

A job stuck in `PENDING` with reason `Resources` just means the cluster is busy. `DependencyNeverSatisfied` in a chained workflow means an earlier stage failed — read its log and cancel the rest.

## More

- [CAC TechDocs: Hopper](https://portal.cac.cornell.edu/techdocs/clusters/Hopper/) and [Slurm](https://portal.cac.cornell.edu/techdocs/clusterinfo/slurm/)
- [Slurm command summary](https://slurm.schedmd.com/pdfs/summary.pdf) (SchedMD)
- [Job scheduling on HPC resources](https://waterprogramming.wordpress.com/2018/06/25/job-scheduling-on-hpc-resources/) and [more HPC posts](https://waterprogramming.wordpress.com/category/high-performance-computing/), Water Programming
