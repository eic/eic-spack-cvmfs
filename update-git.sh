#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Update configuration repositories
for repo in ${HOME}/.spack ${SPACK_ROOT}/etc/spack; do
  git -C ${repo} pull origin -q
  git -C ${repo} status -s
done
