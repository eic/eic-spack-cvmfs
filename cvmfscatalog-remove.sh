#!/bin/bash

cvmfs=${1:-/cvmfs/eic.opensciencegrid.org/packages}

# Remove cvmfscatalog
find ${cvmfs} -mindepth 4 -maxdepth 4 -name .cvmfscatalog -delete

