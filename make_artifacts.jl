#!/usr/bin/env -S julia --project
# Script to generate `Artifacts.toml` and `artifacts/*.tar.gz`.
#
# For the 1st time running this script, you need to run
#   using Pkg; Pkg.instantiate()
# to install the dependencies.
#
using Tar, Inflate, SHA, TOML

ENV["GZIP"] = -9

artifacts = Dict()

const examples_dir = joinpath(@__DIR__, "examples")
const artifacts_dir = joinpath(@__DIR__, "artifacts")

for example in readdir(examples_dir)
    fullpath = joinpath(examples_dir, example)
    isdir(fullpath) || continue

    outpath = joinpath(artifacts_dir, "$(example).tar.gz")
    cd(fullpath) do
        run(`tar --use-compress-program="pigz -k" -cvzf $outpath $(readdir())`)
    end

    artifact_name = example
    artifacts[artifact_name] = Dict(
        "git-tree-sha1" => Tar.tree_hash(IOBuffer(inflate_gzip(outpath))),
        "lazy" => true,
        "download" => [Dict(
            "url" => "https://github.com/qiaojunfeng/WannierDatasets/raw/main/artifacts/$(example).tar.gz",
            "sha256" => bytes2hex(open(sha256, outpath))
        )]
    )
end

open("Artifacts.toml", "w") do io
    TOML.print(io, artifacts)
end
