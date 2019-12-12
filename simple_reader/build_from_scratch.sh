#!/bin/bash
# Build psana conda environment from scratch

ccver=7.3.0

#set -x

#================================================
# Setup environment needed to build and run psana
#================================================

cat > env.sh <<EOF
# variables needed to run psana2
export PSANA_PREFIX=$PWD/lcls2
export PATH=\$PSANA_PREFIX/install/bin:${PATH}
export PYTHONPATH=\$PSANA_PREFIX/install/lib/python3.7/site-packages

# variables needed for conda
module load python/3.7-anaconda-2019.07

if conda env list | grep psana2_py37 ; then
    source /usr/common/software/python/3.7-anaconda-2019.07/etc/profile.d/conda.sh
    conda activate psana2_py37
fi

module load darshan
EOF

source env.sh


#=========================================
# remove existing psana repo and conda env
#=========================================

[[ -e lcls2 ]] && rm -rf lcls2

if conda env list | grep psana2_py37 ; then
    source /usr/common/software/python/3.7-anaconda-2019.07/etc/profile.d/conda.sh
    conda activate base
    conda env remove --name psana2_py37
fi

conda env create -f env_create.yaml
source /usr/common/software/python/3.7-anaconda-2019.07/etc/profile.d/conda.sh
conda activate psana2_py37


##########################
# Download and build psana
##########################

install_latest=0
if [[ ${install_latest} -eq 1 ]] ; then
    git clone https://github.com/slac-lcls/lcls2.git
else
    psana_ver=1.2.0
    [[ -e v${psana_ver}.tar.gz ]] || wget https://github.com/slac-lcls/lcls2/archive/v${psana_ver}.tar.gz
    tar xf v${psana_ver}.tar.gz
    mv lcls2-${psana_ver} lcls2
fi

pushd $PSANA_PREFIX
    module swap PrgEnv-intel PrgEnv-gnu
    # remode the conda installed linker (ld) 
    conda_ld=~/.conda/envs/psana2_py37/compiler_compat/ld
    [[ -e ${conda_ld} ]] && mv ${conda_ld} ${conda_ld}.ignore

    # build psana
    CC=/opt/gcc/${ccver}/bin/gcc CXX=/opt/gcc/${ccver}/bin/g++ ./build_all.sh -d
popd

#============================================================================
# Remove mpi4py from psana conda env and rebuild mpi4py with NERSC cray mpich
#============================================================================

conda uninstall -y mpi4py
[[ -e mpi4py-3.0.0.tar.gz ]] || wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.0.tar.gz
tar zxvf mpi4py-3.0.0.tar.gz
module unload craype-hugepages2M
pushd mpi4py-3.0.0
    python setup.py build --mpicc="$(which cc) -shared"
    python setup.py install
popd

echo
echo "Done. Please run 'source env.sh' to use this build."
