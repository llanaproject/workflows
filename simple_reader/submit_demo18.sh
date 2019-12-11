#!/bin/bash -l
#SBATCH --account=m2859
#SBATCH --job-name=rddemo18
#SBATCH --constraint=knl,quad,cache
#SBATCH --time=00:02:00
#SBATCH --qos=debug

t_start=$(date +%s)

export TEST_XTC_DIR=/global/cscratch1/sd/wilko/test/demo18
export PMI_MMAP_SYNC_WAIT_TIME=600

srun -n 5  python reader_demo18.py

t_end=`date +%s`
echo "PSJobCompleted TotalElapsed $(( t_end - t_start )) ${t_start} ${t_end}"
