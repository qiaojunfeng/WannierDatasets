#!/bin/bash

set -e

NP=8
NK=4

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

F='si2.win'
mpirun -n $NP $W90X -pp $F

F='p2w'
mpirun -n $NP $P2WX -in $F.in > $F.out

F='si2.win'
mpirun -n $NP $W90X $F

# Following are the commands to split val/cond

# If you want to plot WFs, rotate UNK as well
#../../util/split.sh --rotate-unk --nval 4 si2 > split.out
../../util/split.sh --nval 4 si2 > split.out

cd val/
$WJL optrot si2 > optrot.out
F='si2.win'
mpirun -n $NP $W90X $F
cd ../

cd cond/
$WJL optrot si2 > optrot.out
F='si2.win'
mpirun -n $NP $W90X $F
cd ../
