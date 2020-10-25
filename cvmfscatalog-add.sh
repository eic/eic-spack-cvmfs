#!/bin/bash

cvmfs=${1:-/cvmfs/eic.opensciencegrid.org/packages}

# Cvmfs catalog in every package top directory except spack
for package in ${cvmfs}/* ; do
  if [ ${package} = ${package/spack/} ] ; then
    find ${package} -mindepth 2 -maxdepth 2 -type d -print -exec touch {}/.cvmfscatalog \;
  fi
done

# Cvmfs catalog at spack top level and builtin repo
touch ${SPACK_ROOT}/.cvmfscatalog
touch ${SPACK_ROOT}/var/spack/repos/builtin/.cvmfscatalog

