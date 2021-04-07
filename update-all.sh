#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Loop over local operating systems
for os in rhel7 ; do
  if [ -w ${SPACK_ROOT}/../log ] ; then
    log=$SPACK_ROOT/../log/spack-builder:${os}-$(date --iso-8601=minutes).log
  else
    log=/tmp/spack-builder:${os}-$(date --iso-8601=minutes).log
  fi
  ${dir}/update.sh $* 2>&1 | tee ${log}
done

# Loop over container operating systems
for os in centos7 centos8 ubuntu18.04 ubuntu20.04 ubuntu20.10 ; do
  if [ -w ${SPACK_ROOT}/../log ] ; then
    log=$SPACK_ROOT/../log/spack-builder:${os}-$(date --iso-8601=minutes).log
  else
    log=/tmp/spack-builder:${os}-$(date --iso-8601=minutes).log
  fi
  export TINI_SUBREAPER=""
  singularity run -B /cvmfs:/cvmfs /cvmfs/eic.opensciencegrid.org/singularity/spack-builder:${os} ${dir}/update.sh $* 2>&1 | tee ${log}
done
