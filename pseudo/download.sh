#!/bin/bash

# pseudos are downloaded from SSSP
# https://www.materialscloud.org/discover/sssp/table/efficiency

# auto download with either aiida-pseudo, or wget
# aiida-pseudo install sssp -x PBEsol --download-only

F='SSSP_1.1.2_PBEsol_efficiency.tar.gz'
wget "https://archive.materialscloud.org/record/file?filename=${F}&parent_id=19" -O $F
tar xvf $F

F='nc-fr-04_pbe_standard_upf.tgz'
wget "http://www.pseudo-dojo.org/pseudos/${F}" -O $F
tar xvf $F
