#!/bin/bash

cvmfs=${1:-/cvmfs/eic.opensciencegrid.org/packages}

# Show disk usage
echo "Disk usage (top 10 packages): [this may take a while]"
du -sh ${cvmfs}/* | sort -h -r | head -n 10
