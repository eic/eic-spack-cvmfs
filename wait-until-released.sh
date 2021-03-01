#!/bin/bash

dir=`dirname ${0}`

cvmfs=${1:-/cvmfs/eic.opensciencegrid.org/packages}

# Group umask
umask 002

# Load spack
source ${cvmfs}/setup-env.sh

# Wait loop
n=120
while [ -f ${cvmfs}/CVMFSRELEASE ] ; do
  echo "${cvmfs}/CVMFSRELEASE present. Waiting ${n} seconds..." 
  sleep ${n}
done
