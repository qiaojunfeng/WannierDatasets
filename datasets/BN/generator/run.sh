#!/bin/bash

set -e

NP=8
NK=8

PWX=pw.x
BANDSX=bands.x
W90X=wannier90.x
P2WX=pw2wannier90.x
PHX=ph.x
# PPPY="$(dirname $(which epw.x))/pp.py"
# Unfortunately, if using cmake to builde QE, the pp.py script is not in the
# same directory as epw.x. I need to hardcode the path here.
PPPY=~/git/q-e/EPW/bin/pp.py
EPWX=epw.x

F='scf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='ph'
mpirun -n $NP $PHX -nk $NK -in $F.in > $F.out

echo bn | python $PPPY

F='nscf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='epw1'
mpirun -n $NP $EPWX -nk $NK -in $F.in > $F.out

F='epw2'
mpirun -n $NP $EPWX -nk $NK -in $F.in > $F.out

# F='BN.win'
# mpirun -n $NP $W90X -pp $F
# EPW already generated a nnkp file
ln -s bn.nnkp BN.nnkp

F='p2w'
mpirun -n $NP $P2WX -nk $NK -in $F.in > $F.out
