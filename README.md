# WannierDatasets.jl

Datasets for playing with Wannier functions.

Specifically, this repo

- provides input data files for running the examples inside
  [`Wannier.jl`](https://github.com/qiaojunfeng/Wannier.jl) documentation
- provides a set of cheap and small datasets for testing
  [`Wannier.jl`](https://github.com/qiaojunfeng/Wannier.jl)
  and [`WannierIO.jl`](https://github.com/qiaojunfeng/WannierIO.jl)
- allow users to quickly load typical systems when developing algorithms for
  Wannier functions. Fully focus on Wannier algorithms, without the need of
  running density functional theory (DFT) calculations

On technical side, we use [Julia Artifacts](https://pkgdocs.julialang.org/v1/artifacts/)
to manage the datasets. This allows us to

- keep the `Wannier.jl` and `WannierIO.jl` repositories small and clean
- safely rewrite the datasets without the risk of rebasing the history of
  `Wannier.jl` and `WannierIO.jl` repositories
- still providing a convenient way to load the datasets in Julia scripts/REPL.

## Structure of the repo

- [`pseudo/`](./pseudo/) pseudopotentials used when generating the datasets

- [`util/`](./util/) Several small scripts that help with running the examples

## Contributing

If you feel your dataset is useful for the community, please feel free to
contribute. In general, we would like to

- keep the repository as small as possible but still produce (more or less)
  physically meaningful results (e.g., roughly correct band structures).
  Of course, for testing datasets, no such requirement is needed.
- keep the original DFT input files and scripts for generating the datasets,
  to ensure reproducibility. This also allows us to regenerate the datasets if needed.
