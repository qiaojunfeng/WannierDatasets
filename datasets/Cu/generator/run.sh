#!/bin/bash

set -e

NP=8
NK=4

PWX=pw.x
BANDSX=bands.x
W90X=wannier90.x
P2WX=pw2wannier90.x

F='scf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='bands'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='bandsx'
mpirun -n $NP $BANDSX -nk $NK -in $F.in > $F.out

F='nscf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='Cu.win'
mpirun -n $NP $W90X -pp $F

F='p2w'
mpirun -n $NP $P2WX -in $F.in > $F.out

F='Cu.win'
mpirun -n $NP $W90X $F
