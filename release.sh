#!/bin/bash

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

# Cvmfs catalog in every package top directory
for package in /cvmfs/eic.opensciencegrid.org/packages/* ; do
  if [ ${package} = ${package/spack/} ] ; then
    find ${package} -mindepth 2 -maxdepth 2 -type d -exec touch {}/.cvmfscatalog \;
  fi
done
# Verification
find /cvmfs/eic.opensciencegrid.org/packages/ -maxdepth 4 -name ".cvmfscatalog" -type f

# Cvmfs catalog at spack top level and builtin repo
touch ${SPACK_ROOT}/.cvmfscatalog
touch ${SPACK_ROOT}/var/spack/repos/builtin/.cvmfscatalog

# Release
touch /cvmfs/eic.opensciencegrid.org/packages/CVMFSRELEASE
