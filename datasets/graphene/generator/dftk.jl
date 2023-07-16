# Generate amn/mmn/eig/unk from DFTK
# Adapted from
# https://github.com/JuliaMolSim/DFTK.jl/blob/d3a2963b34f16491eb6aa213d59b8f0d0929f1f5/examples/wannier90.jl
# Changes are:
# - use `3 x 3 x 1` kgrid
# - unk files are resampled on a much coarse grid to save space
# - fix normalization of unk
using DFTK
using Unitful
using UnitfulAtomic

d = 10u"Å"
a = 2.641u"Å"  # Graphene Lattice constant
lattice = [
    a -a/2 0
    0 √3*a/2 0
    0 0 d
]

C = ElementPsp(:C, psp = load_psp("hgh/pbe/c-q4"))
atoms = [C, C]
positions = [[0.0, 0.0, 0.0], [1 // 3, 2 // 3, 0.0]]
model = model_PBE(lattice, atoms, positions)
basis = PlaneWaveBasis(model; Ecut = 15, kgrid = [3, 3, 1])
scfres = self_consistent_field(basis; n_bands = 15, tol = 1e-8);

using wannier90_jll  # Needed to make run_wannier90 available
run_wannier90(
    scfres;
    fileprefix = "wannier/graphene",
    n_wannier = 5,
    #num_print_cycles=25,
    num_iter = 200,
    ##
    dis_win_max = 19.0,
    dis_froz_max = 0.1,
    dis_num_iter = 300,
    dis_mix_ratio = 1.0,
    ##
    wannier_plot = true,
    wannier_plot_format = "cube",
    wannier_plot_supercell = 5,
    write_xyz = true,
    translate_home_cell = true,
);

# resample unk
period = 3
using Wannier
# and make sure unk is normalized such that
# for each w = W[:,:,:,i], i = 1:n_bands
#     sum(conj(w) .* w) = prod(size(w))
for f in filter(x -> startswith(x, "UNK"), readdir())
    ik, W = read_unk(f)
    w = W[:, :, :, 1]
    fac = sqrt(prod(size(w)) / sum(real(conj(w) .* w)))
    W = fac * W[1:period:end, 1:period:end, 1:period:end, :]
    write_unk("$period.$f", ik, W)
end
