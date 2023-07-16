These are results computed by `wannier90`.

The `Si2_valence.chk.amn` contains the unitary matrices from the `Si2_valence.chk` file, i.e., the final maximally-localized gauge.

The `binary` folder contains Fortran unformatted files, used in `WannierIO.jl` tests.

The `Si2_valence.win.toml` and `Si2_valence.nnkp.toml` files are the reference data for `WannierIO.jl` tests.

For Wannier interpolations,
- Files in `mdrs` folder are generated with MDRS interpolation, i.e., `use_ws_distance = .true.` in wannier90
- Files in `ws` folder are generated with WS interpolation, i.e., `use_ws_distance = .false.` in wannier90
