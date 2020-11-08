#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Find compilers
if [ -w /cvmfs/eic.opensciencegrid.org/packages ] ; then
  spack compiler find --scope site
else
  spack compiler find --scope user
fi
spack compiler list

# Remove cvmfscatalog
${dir}/cvmfscatalog-remove.sh /cvmfs/eic.opensciencegrid.org/packages

# Create environments
for envdir in ${SPACK_ROOT}/var/spack/repos/eic-spack/environments/* ; do
	env=`basename ${envdir}`
        envfile=${envdir}/spack.yaml
	spack env activate ${env}
	if [ -z "${SPACK_ENV}" ] ; then
		spack env create ${env} ${envfile}
		spack env activate ${env}
	fi
	if [ "${envdir}/spack.yaml" -nt "${envdir}/spack.lock" ] ; then
		spack concretize -f
	fi
	spack install -j $(($(nproc)/2)) || spack install --keep-stage --show-log-on-error -j 1
	spack env deactivate
done

# Add cvmfscatalog
${dir}/cvmfscatalog-add.sh /cvmfs/eic.opensciencegrid.org/packages

# Release the cvmfs working directory
${dir}/release.sh /cvmfs/eic.opensciencegrid.org/packages
