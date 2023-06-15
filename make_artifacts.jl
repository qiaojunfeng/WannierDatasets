#!/usr/bin/env -S julia --project
# Script to generate `Artifacts.toml` and `artifacts/*.tar.gz`.
#
# For the 1st time running this script, you need to run
#   using Pkg; Pkg.instantiate()
# to install the dependencies.
#
# Artifacts docs:
# https://pkgdocs.julialang.org/v1/artifacts/
#
using Tar, Inflate, SHA, TOML

artifacts = Dict()

const datasets_dir = joinpath(@__DIR__, "datasets")
const artifacts_dir = joinpath(@__DIR__, "artifacts")
# exclude the creator folder which contains the inputs for generating the datasets
const tar_excludes = ["creator", ".gitignore", "README.md"]

# gzip compression level, highest
const GZIP = "-9"
# Try to use pigz for parallel compression, much faster.
if Sys.which("pigz") !== nothing
    # -k: keep original files
    compress_prog = "pigz $GZIP -k"
else
    # By default, use gzip
    compress_prog = "gzip $GZIP"
end

mkpath(artifacts_dir)

for data in readdir(datasets_dir)
    fullpath = joinpath(datasets_dir, data)
    isdir(fullpath) || continue

    tar_name = "$(data).tar.gz"
    outpath = joinpath(artifacts_dir, tar_name)
    cd(fullpath) do
        files = readdir()
        filter!(x -> !(x in tar_excludes), files)
        run(`tar --use-compress-program="$compress_prog" -cvf $outpath $files`)
    end

    artifact_name = data
    artifacts[artifact_name] = Dict(
        "git-tree-sha1" => Tar.tree_hash(IOBuffer(inflate_gzip(outpath))),
        "lazy" => true,
        "download" => [Dict(
            # Use github release to host the artifacts
            # https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases
            # 2GB limit per file, no limit on total size, no bandwidth limit
            # https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases
            "url" => "https://github.com/qiaojunfeng/WannierDatasets/releases/latest/download/$(tar_name)",
            # Or if you want to test locally
            # "url" => "file://$(outpath)",
            "sha256" => bytes2hex(open(sha256, outpath))
        )]
    )
end

open("Artifacts.toml", "w") do io
    TOML.print(io, artifacts)
end
