#!/usr/bin/env julia
# Wannierize the top valence band of MoS2
using Wannier

truncate_w90("../mos2", [9, ], ".", true)

model = read_seedname("mos2"; amn=false)
pprint(omega(model))

A, _ = parallel_transport(model)
pprint(omega(model, A))

write_amn("mos2.amn", A)
