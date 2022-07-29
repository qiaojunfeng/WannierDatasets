#!/bin/bash

set -e

NP=8
NK=8

PWX=pw.x
W90X=wannier90.x
P2WX=pw2wannier90.x
WJL=$HOME/.julia/bin/wannier

F='scf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='bands'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='nscf'
mpirun -n $NP $PWX -nk $NK -in $F.in > $F.out

F='mos2.win'
mpirun -n $NP $W90X -pp $F

F='p2w'
mpirun -n $NP $P2WX -in $F.in > $F.out

F='mos2.win'
mpirun -n $NP $W90X $F

../split.sh --rotate-unk --nval 9    mos2 > split.out

cd val/
$WJL optrot mos2 > optrot.out
F='mos2.win'
mpirun -n $NP $W90X $F
cd ../

cd cond/
$WJL optrot mos2 > optrot.out
F='mos2.win'
mpirun -n $NP $W90X $F
cd ../
