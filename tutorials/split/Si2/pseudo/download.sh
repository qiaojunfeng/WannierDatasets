#!/bin/bash

# pseudo can be downloaded from QE website
#    http://pseudopotentials.quantum-espresso.org/legacy_tables/ps-library/si
# or SSSP
#    https://www.materialscloud.org/discover/sssp/table/efficiency

url='http://pseudopotentials.quantum-espresso.org/upf_files/Si.pbe-n-rrkjus_psl.1.0.0.UPF'

wget $url
