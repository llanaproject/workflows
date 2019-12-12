#!/bin/bash -l
#SBATCH --account=m2859
#SBATCH --job-name=rddemo18
#SBATCH --constraint=knl,quad,cache
#SBATCH --time=00:02:00
#SBATCH --qos=debug

t_start=$(date +%s)

njobs=${1:-3}
maxevents=${2:-150}
xtcdir=${3:-/global/cscratch1/sd/wilko/test/demo18}
echo "Using njobs=${njobs} xtcdir=${xtcdir} maxevts: ${maxevents}"

export TEST_XTC_DIR=${xtcdir}
export PMI_MMAP_SYNC_WAIT_TIME=600

srun -n ${njobs} python reader_demo18.py ${maxevents}

t_end=`date +%s`
echo "PSJobCompleted TotalElapsed $(( t_end - t_start )) ${t_start} ${t_end}"
