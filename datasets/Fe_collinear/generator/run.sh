#!/bin/bash

set -e

NP=8
NK=4

PWX=pw.x
P2WX=pw2wannier90.x
W90X=wannier90.x

F='scf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='bands'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out
cp out/Fe.xml qe_bands.xml

F='nscf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='Fe_up.win'
mpirun -n $NP $W90X -pp $F
if [ ! -f 'Fe_dn.nnkp' ]; then
    ln -s Fe_up.nnkp Fe_dn.nnkp
fi
if [ ! -f 'Fe_updn.nnkp' ]; then
    ln -s Fe_up.nnkp Fe_updn.nnkp
fi

F='p2w_up'
mpirun -n $NP $P2WX -in $F.in > $F.out
F='p2w_dn'
mpirun -n $NP $P2WX -in $F.in > $F.out
F='p2w_mud'
mpirun -n $NP $P2WX -in $F.in > $F.out

F='Fe_up.win'
mpirun -n $NP $W90X $F
F='Fe_dn.win'
mpirun -n $NP $W90X $F
