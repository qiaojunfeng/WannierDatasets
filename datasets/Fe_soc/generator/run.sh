#!/bin/bash

set -e

NP=8
NK=4

PWX=pw.x
P2WX=pw2wannier90.x
W90X=wannier90.x
PW90X=postw90.x

F='scf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='bands'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out
cp out/Fe.xml qe_bands.xml

F='nscf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='Fe.win'
mpirun -n $NP $W90X -pp $F

F='p2w'
mpirun -n $NP $P2WX -in $F.in > $F.out

F='Fe.win'
mpirun -n $NP $W90X $F

F='Fe.win'
mpirun -n $NP $PW90X $F
