#!/bin/bash

cvmfs=${1:-/cvmfs/eic.opensciencegrid.org/packages}

# Remove cvmfscatalog
find ${cvmfs} -mindepth 4 -maxdepth 4 -name .cvmfscatalog -delete
find ${cvmfs}/spack/current/var/spack/environments/ -maxdepth 4 -name .cvmfscatalog -delete
