#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

cvmfs=${1:-/cvmfs/eic.opensciencegrid.org/singularity}

# Loop over operating systems
for os in centos7 centos8 ubuntu18.04 ubuntu20.04 ubuntu20.10 ; do
  singularity build --sandbox ${cvmfs}/spack-builder:${os}.new docker://electronioncollider/spack-builder:${os}
  rm -rf ${cvmfs}/spack-builder:${os}
  if [ ! -d ${cvmfs}/spack-builder:${os} ] ; then 
    mv ${cvmfs}/spack-builder:${os}.new ${cvmfs}/spack-builder:${os}
  fi
done

# Release
touch ${cvmfs}/CVMFSRELEASE

