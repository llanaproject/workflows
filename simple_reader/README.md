
# Simple workflow to read demo18 data

The *reader_demo18.py* is a simple psana2 script to read detector data. The data used are from
a demo in 2018 and contains a big data file *data-r0001-s00.xtc2* which is 599GB in size and smalldata
file.


In order to build psana2 and run the workflow at nersc follw the steps:

## Install psana2
The install a conda environment and build psana run the command:

```shell
% ./build_from_scratch.sh
```

Installs a conda environment and builds psana2. 

## submit job
 
```shell
% sbatch submit_demo18.sh
```
