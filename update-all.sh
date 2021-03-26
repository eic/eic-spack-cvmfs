#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Update spack repository
if [ -w ${SPACK_ROOT} ] ; then
  spack_pre=`git -C ${SPACK_ROOT} rev-parse HEAD`
  git -C ${SPACK_ROOT} pull origin -q
  git -C ${SPACK_ROOT} status -s
  spack_post=`git -C ${SPACK_ROOT} rev-parse HEAD`
  [[ "${spack_pre}" == "${spack_post}" ]] && spack_unchanged=1
fi

# Update eic-spack repository
if [ -w ${SPACK_ROOT}/var/spack/repos/eic-spack ] ; then
  eic_spack_pre=`git -C ${SPACK_ROOT}/var/spack/repos/eic-spack rev-parse HEAD`
  git -C ${SPACK_ROOT}/var/spack/repos/eic-spack pull origin -q
  git -C ${SPACK_ROOT}/var/spack/repos/eic-spack status -s
  eic_spack_post=`git -C ${SPACK_ROOT}/var/spack/repos/eic-spack rev-parse HEAD`
  [[ "${eic_spack_pre}" == "${eic_spack_post}" ]] && eic_spack_unchanged=1
fi

# Exit if no changes
[[ "${spack_unchanged}" -eq 1 && "${eic_spack_unchanged}" -eq 1 && $# -eq 0 ]] && exit

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

echo "Singularity cache size:"
ls -alShr ${HOME}/.singularity/docker/ | tail -n 10
