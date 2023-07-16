#!/usr/bin/env fish
set -l NP 24
set -l NK 12

set -l F scf
mpirun -n $NP pw.x -nk $NK -in $F.in > $F.out

set -l F bands
mpirun -n $NP pw.x -nk $NK -in $F.in > $F.out
cp out/CrI3.xml qe_bands.xml
rm out/CrI3.save/wfc*dat

set -l F nscf
mpirun -n $NP pw.x -nk $NK -in $F.in > $F.out

cd up/
set -l F p2w_up
mpirun -n $NP pw2wannier90.x -in $F.in > $F.out
cd ../

cd dn/
set -l F p2w_dn
mpirun -n $NP pw2wannier90.x -in $F.in > $F.out
cd ../

cd updn/
set -l F p2w_mud
mpirun -n $NP pw2wannier90.x -in $F.in > $F.out
cd ../

# cd up/
# set -l F CrI3_up
# mpirun -n $NP wannier90.x $F
# cd ../

# cd dn/
# set -l F CrI3_dn
# mpirun -n $NP wannier90.x $F
# cd ../
