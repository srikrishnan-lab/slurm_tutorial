#!/bin/bash
# Submit a three-stage workflow with dependencies, so the whole thing runs
# unattended instead of you waiting to submit each stage by hand.
#
#   calibrate  ->  simulate (job array)  ->  postprocess
#
# Run this from the repository root:  bash pipeline/submit_pipeline.sh

set -euo pipefail
mkdir -p logs output

# --parsable makes sbatch print just the job ID, which is what we capture.
jid1=$(sbatch --parsable pipeline/stage1_calibrate.sh)
echo "stage 1: $jid1"

# afterok means "only if the previous job exited 0". Use afterany if the next
# stage should run regardless of whether the previous one succeeded.
jid2=$(sbatch --parsable --dependency=afterok:"$jid1" pipeline/stage2_simulate.sh)
echo "stage 2: $jid2  (waits on $jid1)"

# Depending on an array job's ID waits for *every* task in the array.
jid3=$(sbatch --parsable --dependency=afterok:"$jid2" pipeline/stage3_postprocess.sh)
echo "stage 3: $jid3  (waits on all tasks of $jid2)"

echo
echo "watch with:  squeue -u $USER"
echo "a stage shown as DependencyNeverSatisfied means an earlier stage failed;"
echo "check its log in logs/ and scancel the rest."
