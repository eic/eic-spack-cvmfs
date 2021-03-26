#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Setup os
spack debug report
os=`spack arch -o`

# Find compilers
if [ -w /cvmfs/eic.opensciencegrid.org/packages ] ; then
  spack compiler find --scope site
else
  spack compiler find --scope user
fi
spack compiler list

# Remove cvmfscatalog
if [ -w /cvmfs/eic.opensciencegrid.org/packages ] ; then
  ${dir}/cvmfscatalog-remove.sh /cvmfs/eic.opensciencegrid.org/packages
fi

# Create environments
environments=/cvmfs/eic.opensciencegrid.org/packages/spack/eic-spack/environments
for envdir in ${environments}/* ; do
	env=`basename ${envdir}`
        envfile=${envdir}/spack.yaml
	if [ ! -f "${envdir}/spack.lock" ] ; then
		spack env create -d ${envdir} ${envfile}
	fi
	spack env activate ${envdir}
	if [ ! -f "${envdir}/spack.lock" -o "${envdir}/spack.yaml" -nt "${envdir}/spack.lock" -o $# -gt 0 ] ; then
		spack concretize -f
	fi
	spack install -j $(($(nproc)/2)) || spack install --keep-stage --show-log-on-error -j 1
	spack env deactivate
done

# Add cvmfscatalog
if [ -w /cvmfs/eic.opensciencegrid.org/packages ] ; then
  ${dir}/cvmfscatalog-add.sh /cvmfs/eic.opensciencegrid.org/packages
fi

# Release the cvmfs working directory
if [ -w /cvmfs/eic.opensciencegrid.org/packages ] ; then
  ${dir}/release.sh /cvmfs/eic.opensciencegrid.org/packages
fi
