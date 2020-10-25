#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load spack
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Clean spack (stage, downloads, failures)
echo "Cleaning temporary files"
spack clean -s -d -f

# Garbage collect (disabled to reuse build dependencies)
#echo "Removing unneeded specs"
#spack gc

# Show explicitly installed packages
echo "Explicitly installed packages:"
spack find -x -v -L

# Show disk usage
echo "Disk usage (top 10 packages): [this may take a while]"
du -sh /cvmfs/eic.opensciencegrid.org/packages/* | sort -h -r | head -n 10

# Add cvmfscatalog
${dir}/cvmfscatalog-add.sh /cvmfs/eic.opensciencegrid.org/packages

# Release
touch /cvmfs/eic.opensciencegrid.org/packages/CVMFSRELEASE
