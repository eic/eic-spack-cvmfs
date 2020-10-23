#!/bin/bash

# Group umask
umask 002

# Load environment
source /cvmfs/eic.opensciencegrid.org/packages/setup-env.sh

# Update spack repository
spack_pre=`git -C ${SPACK_ROOT} rev-parse HEAD`
git -C ${SPACK_ROOT} fetch -q --all
git -C ${SPACK_ROOT} pull -q
git -C ${SPACK_ROOT} status -s
spack_post=`git -C ${SPACK_ROOT} rev-parse HEAD`

# Update eic-spack repository
eic_spack_pre=`git -C ${SPACK_ROOT}/var/spack/repos/eic-spack rev-parse HEAD`
git -C ${SPACK_ROOT}/var/spack/repos/eic-spack fetch -q --all
git -C ${SPACK_ROOT}/var/spack/repos/eic-spack pull -q
git -C ${SPACK_ROOT}/var/spack/repos/eic-spack status -s
eic_spack_post=`git -C ${SPACK_ROOT}/var/spack/repos/eic-spack rev-parse HEAD`

# Exit if no changes
[[ "${spack_pre}" == "${spack_post}" && "${eic_spack_pre}" == "${eic_spack_post}" ]] && exit

# Show local differences 
git diff

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

# Release the cvmfs working directory
dir=`dirname ${0}`
${dir}/release.sh
