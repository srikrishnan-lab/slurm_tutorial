"""One ensemble member, selected by the Slurm array task ID.

This is the workhorse pattern for this group: independent members, one task
each, scheduled and retried individually.
"""
import argparse
import json
import os
import pathlib

import numpy as np

parser = argparse.ArgumentParser()
parser.add_argument("--member", type=int, default=None)
parser.add_argument("--outdir", type=pathlib.Path, default=pathlib.Path("output"))
args = parser.parse_args()

member = args.member
if member is None:
    member = int(os.environ["SLURM_ARRAY_TASK_ID"])

# Seed from the member index so the run is reproducible and every member differs.
rng = np.random.default_rng(member)
result = {"member": member, "mean": float(rng.normal(size=1000).mean())}

args.outdir.mkdir(parents=True, exist_ok=True)
out = args.outdir / f"member_{member:05d}.json"
out.write_text(json.dumps(result))
print(f"wrote {out}")
