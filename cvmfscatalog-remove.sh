#!/bin/bash

cvmfs=${1:-/cvmfs/eic.opensciencegrid.org/packages}

# Do not remove catalogs when release pending
if [ -f ${cvmfs}/CVMFSRELEASE ] ; then exit ; fi

# Remove cvmfscatalog
find ${cvmfs} -mindepth 4 -maxdepth 4 -name .cvmfscatalog -delete
find ${cvmfs}/spack/current/var/spack/environments/ -maxdepth 4 -name .cvmfscatalog -delete
