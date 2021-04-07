#!/bin/bash

dir=`dirname ${0}`

cvmfs=${1:-/cvmfs/eic.opensciencegrid.org/packages}

# Group umask
umask 002

# Load spack
source ${cvmfs}/setup-env.sh

# Clean spack (stage, downloads, failures)
echo "Cleaning temporary files"
spack clean -s -d -f

# Garbage collect (disabled to reuse build dependencies)
#echo "Removing unneeded specs"
#spack gc -y

# Show explicitly installed packages
echo "Explicitly installed packages:"
spack find -x -v -L

# Add cvmfscatalog
${dir}/cvmfscatalog-add.sh ${cvmfs}

# Release
touch ${cvmfs}/CVMFSRELEASE
