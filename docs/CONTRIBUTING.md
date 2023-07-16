# Contributing guidelines

Thanks for taking the time to contribute! :+1:

In general, we would like to

- keep the repository as small as possible but still produce (more or less)
    physically meaningful results (e.g., roughly correct band structures).
    Of course, for testing datasets, no such requirement is needed.
- keep the original DFT input files and scripts for generating the datasets,
    to ensure reproducibility. This also allows us to regenerate the datasets
    if needed.

## All Code Changes Happen Through Pull Requests

Pull requests are the best way to propose changes to the codebase.
We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. Add dataset(s), ideally small (in terms of file size) but still gives
    physical results. The `prefix` of the files (i.e. `prefix.amn`/`prefix.mmn`)
    should be the same as the folder name, to allow easy loading of the dataset
    by `Wannier.jl` (the function `Wannier.Datasets.load_dataset`)
3. Make sure the original input files are committed in a `generator` subfolder,
    so we can always reproduce the results on different machines.
4. (Optional) put useful reference files in a `reference` subfolder
5. Always `git rebase` your branch on top of the latest `main` branch, so that
    we can merge your PR without ugly :worried: merge commits.
    Otherwise, we will rebase explicitly your branch when merging.
6. Create that pull request!
