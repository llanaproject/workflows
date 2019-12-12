
# *reader_demo18.py*: Simple workflow to reading lcls data

This workflow reads lcls (lcls1) data using psana2. The example data are a single 588GB file, data-r0001-s00.xtc2,
and the corresponding smalldata file, data-r0001-s00.smd.xtc2 (18MB).

The script *reader_demo18.py* reads the data of the area detector used for experiment but doesn't do any further
processing (e.g.: calibration, peak finding, ...). Therefore it is an IO bound workflow. 



## Install conda environment and psana

The command 

```shell
% ./build_from_scratch.sh
```
builds a conda environment downloads the _lcls_ repo and installs psana.
It creates the environment script *env.sh* that needs to be sourced when running psana.

Every time build_from_scratch.sh is run the previous install will be removed (conda env and psana)
and rebuild.

A simple check that the build might have worked is to check that the psana package link exists:
> ls lcls2/install/lib/python3.7/site-packages/psana.egg-link
and that the conda env exists:
> ~/.conda/envs/psana2_py37/



## Run the workflow

Before running psana the conda environment needs to be activated and psana added to the PATH. We also laod the
darshan module:
```shell
% source env.sh 
```

The sbatch script
```shell
submit_demo18.sh [ntasks  xtc-directory] 
```
is an example how to run the workflow. The options are::

ntasks:
  number of tasks given to srun (-n option)

xtc-directory:
  directory where to find the data. There are currently two directories which contain identical files
  but differnt Lustre stripping settings:

  |  directory                                 | stripe count | stripe size |
  | ------------------------------------------ | ------------ | ----------- |
  | /global/cscratch1/sd/wilko/test/demo18     |            1 |         1MB |
  | /global/cscratch1/sd/wilko/test/demo18/s16 |           16 |         4MB |
	 
 
To run the work flow:
```
sbatch 