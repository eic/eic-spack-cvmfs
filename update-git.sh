#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Update repositories
for repo in ${SPACK_ROOT} \
            ${SPACK_ROOT}/etc/spack \
            ${HOME}/.spack \
            ${HOME}/eic-spack \
            ${HOME}/eic-spack-cvmfs ; do
  git -C ${repo} pull origin -q
  git -C ${repo} status -s
done
