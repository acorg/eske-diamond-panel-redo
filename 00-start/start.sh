#!/bin/bash -e

. /home/tcj25/.virtualenvs/35/bin/activate

log=../slurm-pipeline.log
> $log

# Remove the marker file that indicates when a job is fully complete.
rm -f ../slurm-pipeline.done

echo "SLURM pipeline started at `date`" >> $log
echo >> $log

# echo "TASK: start"
