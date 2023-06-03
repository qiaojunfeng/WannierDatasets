#!/usr/bin/env -S julia --project
# Script to generate `Artifacts.toml` and `artifacts/*.tar.gz`.
#
# For the 1st time running this script, you need to run
#   using Pkg; Pkg.instantiate()
# to install the dependencies.
#
using Tar, Inflate, SHA, TOML

artifacts = Dict()

const datasets_dir = joinpath(@__DIR__, "datasets")
const artifacts_dir = joinpath(@__DIR__, "artifacts")
# exclude the creator folder which contains the inputs for generating the datasets
const tar_excludes = ["creator"]

for data in readdir(datasets_dir)
    fullpath = joinpath(datasets_dir, data)
    isdir(fullpath) || continue

    outpath = joinpath(artifacts_dir, "$(data).tar.gz")
    cd(fullpath) do
        # -9: use highest compression level
        files = readdir()
        filter!(x -> !(x in tar_excludes), files)
        run(`tar --use-compress-program="pigz -9 -k" -cvf $outpath $files`)
    end

    artifact_name = data
    artifacts[artifact_name] = Dict(
        "git-tree-sha1" => Tar.tree_hash(IOBuffer(inflate_gzip(outpath))),
        "lazy" => true,
        "download" => [Dict(
            "url" => "https://github.com/qiaojunfeng/WannierDatasets/raw/main/artifacts/$(data).tar.gz",
            "sha256" => bytes2hex(open(sha256, outpath))
        )]
    )
end

open("Artifacts.toml", "w") do io
    TOML.print(io, artifacts)
end
