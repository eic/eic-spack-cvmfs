#!/bin/bash

dir=`dirname ${0}`

for os in ubuntu20.04 ; do
  singularity run docker://electronioncollider/spack-builder:${os} ${dir}/update.sh
done

echo "Singularity cache size:"
ls -alShr ${HOME}/.singularity/docker/ | tail -n 10
