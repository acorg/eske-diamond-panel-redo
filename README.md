## Eske blastn pipeline spec

This repo contains a
[slurm-pipeline](https://github.com/acorg/slurm-pipeline) specification
file (`specification.json`) and associated scripts for post-processing
ancient DNA samples from Eske Willerslev that have already been searched
using DIAMOND.

In the original run, we did not group samples as weren't aware that some
samples had been sequenced multiple times.  The code in this repo re-does
the final step of the original processing (the making of a blue plot
panel), but collects all reads (across different sequencing runs) for each
sample.

### Usage

It's assumed you've already run
[the first pipeline](https://github.com/acorg/eske-pipeline-spec) on the
samples you're interested in.

The `01-panel/submit.sh` script expects the original unmapped sample FASTQ
files to be in
`../../*/Sample_ESW_*${sample}_*/03-find-unmapped/*-unmapped.fastq.gz`
where `${sample}` is taken from the last component of the local directory
name of this repo.  It expects to find the DIAMOND output files in
`04-diamond/*.fastq.gz` in a sibling (of the above `03-find-unmapped`)
directory.

So you can do this, for example:

```sh
$ mkdir DA100
$ cd DA100
$ git clone https://github.com/acorg/eske-diamond-panel-redo
$ make run
```

This will run `noninteractive-alignment-panel.py` on all the DIAMOND output
from all directories for sample `DA100`.

### Output

`01-panel` leaves its output in `01-panel/out` and
`01-panel/summary-virus`.

### Cleaning up

```sh
$ make clean-1
```

Note that this throws away all the intermediate work done by the pipeline.

### Cleaning up a bit more

```sh
$ make clean-2
```

Does a `make clean-1` and removes intermediate SLURM output log files.

### Really cleaning up

```sh
$ make clean-3
```

Does a `make clean-2` and also removes the final output in `01-panel/out`.
