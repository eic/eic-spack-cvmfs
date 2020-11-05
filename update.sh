#!/bin/bash

dir=`dirname ${0}`

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

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
	spack concretize -f
	spack install -j $(($(nproc)/2))
	spack env deactivate
done

# Add cvmfscatalog
${dir}/cvmfscatalog-add.sh /cvmfs/eic.opensciencegrid.org/packages

# Release the cvmfs working directory
${dir}/release.sh
