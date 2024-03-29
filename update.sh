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

# Find ccache
spack load --first ccache os=$os || spack install ccache os=$os && spack load --first ccache os=$os

# Wait until released
if [ -w /cvmfs/eic.opensciencegrid.org/packages ] ; then
  ${dir}/wait-until-released.sh /cvmfs/eic.opensciencegrid.org/packages
fi

# Create environments
packages=/cvmfs/eic.opensciencegrid.org/packages/spack/eic-spack/packages
environments=/cvmfs/eic.opensciencegrid.org/packages/spack/eic-spack/environments
for envdir in ${environments}/* ; do
	env=`basename ${envdir}`
	envfile=${envdir}/spack.yaml
	if [ ! -d "${envdir}" ] ; then
		continue
	fi

	envosdir=${envdir}/${os}
	if [ ! -w ${envosdir} ] ; then
		continue
	fi

	mkdir -p ${envosdir}
	if [ ! -f "${envosdir}/spack.lock" ] ; then
		spack env create --without-view -d ${envosdir} ${envfile}
	fi

	spack env activate --without-view ${envosdir}

	if [ ! -f "${envosdir}/spack.lock" ] ; then
		echo "Concretizing for the first time"
		spack concretize -f
	fi

	yaml_time=$(ls --time-style=+%s -l ${envdir}/spack.yaml | awk '{print($6)}')
	lock_time=$(ls --time-style=+%s -l ${envosdir}/spack.lock | awk '{print($6)}')
        yaml_lock_diff=$((yaml_time-lock_time))
	if [ "${yaml_lock_diff}" -gt 5 ] ; then
		echo "Reconcretizing because of changes to environment"
		cp ${envdir}/spack.yaml ${envosdir}/spack.yaml
		spack concretize -f
	fi

	updated_packages=`find ${packages} -type f -newer ${envosdir}/spack.lock -not -name "*.pyc"`
	if [ ! -z "${updated_packages}" ] ; then
		echo "Reconcretizing because of changes to packages:"
		echo "${updated_packages}"
		spack concretize -f
	fi

	spack install -j $(($(nproc)/2)) | grep -v '^\[+\]'
	spack install -j 1 --keep-stage --show-log-on-error | grep -v '^\[+\]'
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
