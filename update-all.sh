#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Update spack repository
spack_pre=`git -C ${SPACK_ROOT} rev-parse HEAD`
git -C ${SPACK_ROOT} pull origin -q
git -C ${SPACK_ROOT} status -s
spack_post=`git -C ${SPACK_ROOT} rev-parse HEAD`

# Update eic-spack repository
eic_spack_pre=`git -C ${SPACK_ROOT}/var/spack/repos/eic-spack rev-parse HEAD`
git -C ${SPACK_ROOT}/var/spack/repos/eic-spack pull origin -q
git -C ${SPACK_ROOT}/var/spack/repos/eic-spack status -s
eic_spack_post=`git -C ${SPACK_ROOT}/var/spack/repos/eic-spack rev-parse HEAD`

# Exit if no changes
[[ "${spack_pre}" == "${spack_post}" && "${eic_spack_pre}" == "${eic_spack_post}" && $# -eq 0 ]] && exit

# Loop over operating systems
for os in centos7 centos8 ubuntu18.04 ubuntu20.04 ubuntu20.10 ; do
  singularity run -B /cvmfs:/cvmfs docker://electronioncollider/spack-builder:${os} ${dir}/update.sh $* 2>&1 | tee ~/spack-builder:${os}.log
done

echo "Singularity cache size:"
ls -alShr ${HOME}/.singularity/docker/ | tail -n 10
