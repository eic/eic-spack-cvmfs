#!/bin/bash

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Update eic-spack repository
git -C ${SPACK_ROOT} fetch --all
git -C ${SPACK_ROOT} pull
git -C ${SPACK_ROOT} status 

# Update eic-spack repository
git -C ${SPACK_ROOT}/var/spack/repos/eic-spack fetch --all
git -C ${SPACK_ROOT}/var/spack/repos/eic-spack pull
git -C ${SPACK_ROOT}/var/spack/repos/eic-spack status

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
	spack install
	spack env deactivate
done
