# eic-spack-cvmfs

This repository contains the scripts to manage the EIC Spack Software Stack on CernVM-FS.

A typical crontab entry might be:
```
13 02 * * *     crontab -l > $HOME/crontab.`hostname`
24 */2 * * *    if [ -f ~/eic-spack-cvmfs/update-git.sh ] ; then ~/eic-spack-cvmfs/update-git.sh ; fi
35 */2 * * *    if [ -f ~/eic-spack-cvmfs/update-all.sh ] ; then ~/eic-spack-cvmfs/update-all.sh ; fi
```
