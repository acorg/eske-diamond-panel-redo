#!/bin/bash -e

#SBATCH -J panel-redo
#SBATCH -A DSMITH-BIOCLOUD
#SBATCH -o slurm-%A.out
#SBATCH -p biocloud-normal
#SBATCH --time=10:00:00

. /home/tcj25/.virtualenvs/35/bin/activate

# The log file is the overall top-level job log file, seeing as this step
# is a 'collect' step that is only run once.
log=../slurm-pipeline.log
sample=`/bin/pwd | tr / '\012' | egrep 'DA[0-9]+'`

echo "01-panel started at `date`" >> $log
echo "  Sample is '$sample'" >> $log

json=
fastq=

for dir in ../../../2016*/Sample_ESW_*${sample}_*
do
    for file in $dir/04-diamond/*.json.bz2
    do
        json="$json $file"
    done

    for file in $dir/03-find-unmapped/*-unmapped.fastq.gz
    do
        fastq="$fastq $file"
    done
done

dbfile=$HOME/scratch/root/share/ncbi/viral-refseq/viral.protein.fasta

if [ ! -f $dbfile ]
then
    echo "DIAMOND database FASTA file $dbfile does not exist!" >> $log
    exit 1
fi

echo "  noninteractive-alignment-panel.py started at `date`" >> $log
srun -n 1 noninteractive-alignment-panel.py \
  --json $json \
  --fastq $fastq \
  --matcher diamond \
  --outputDir out \
  --withScoreBetterThan 40 \
  --maxTitles 200 \
  --minMatchingReads 3 \
  --minCoverage 0.1 \
  --negativeTitleRegex phage \
  --diamondDatabaseFastaFilename $dbfile > summary-proteins
echo "  noninteractive-alignment-panel.py stopped at `date`" >> $log

echo "  group-summary-proteins.py started at `date`" >> $log
group-summary-proteins.py < summary-proteins > summary-virus
echo "  group-summary-proteins.py stopped at `date`" >> $log

echo "01-panel stopped at `date`" >> $log
echo >> $log
