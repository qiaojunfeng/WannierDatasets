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

# let Artifacts.toml point to local tarballs, otherwise point to GitHub releases
LOCAL = false
# if on local machine, I assume all the 7z files are already decompressed
DECOMPRESS_7Z = true

# check if we are running in github actions
if isnothing(get(ENV, "GITHUB_ACTIONS", nothing))
    LOCAL = true
    DECOMPRESS_7Z = false
else
    LOCAL = false
    DECOMPRESS_7Z = true
end

if DECOMPRESS_7Z
    PY_SCRIPT = joinpath(@__DIR__, "util/GitHub-ForceLargeFiles/src/reverse.py")
    run(
        Cmd([
            "python",
            PY_SCRIPT,
            # reverse.py will delete the 7z files by default
            "--delete_partitions",
            # workaround for python argparse: only empty string "" -> false
            "",
            "--root_dir",
            joinpath(@__DIR__, "datasets"),
        ]),
    )
end

artifacts = Dict()

const datasets_dir = joinpath(@__DIR__, "datasets")
const artifacts_dir = joinpath(@__DIR__, "artifacts")
# exclude the generator folder which contains the inputs for generating the datasets
const tar_excludes = ["generator", ".gitignore", "README.md", "*.7z.*"]

# gzip compression level, highest
const GZIP = "-9"
# By default, use gzip
compress_prog = "gzip $GZIP"
# Try to use pigz for parallel compression.
# However, it is not available in github workflow (ubuntu-latest)
try
    run(`which pigz`)
    # -k: keep original files
    global compress_prog = "pigz $GZIP -k"
catch
    # pigz is not available
end

TAR_CMD = [
    "tar",
    "--exclude-vcs",
    "--exclude-vcs-ignores",
    "--use-compress-program=$compress_prog",
]
append!(TAR_CMD, ["--exclude=" * f for f in tar_excludes])

mkpath(artifacts_dir)

for data in readdir(datasets_dir)
    startswith(data, "_") && continue
    fullpath = joinpath(datasets_dir, data)
    isdir(fullpath) || continue

    tar_name = "$(data).tar.gz"
    outpath = joinpath(artifacts_dir, tar_name)
    cd(fullpath) do
        files = readdir()
        run(Cmd(vcat(TAR_CMD, ["-cvf", outpath], files)))
    end

    if LOCAL
        # if you want to test locally
        url = "file://$(outpath)"
    else
        # use github release to host the artifacts
        # https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases
        # 2GB limit per file, no limit on total size, no bandwidth limit
        # https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases
        url = "https://github.com/qiaojunfeng/WannierDatasets/releases/latest/download/$(tar_name)"
    end

    artifact_name = data
    artifacts[artifact_name] = Dict(
        "git-tree-sha1" => Tar.tree_hash(IOBuffer(inflate_gzip(outpath))),
        "lazy" => true,
        "download" =>
            [Dict("url" => url, "sha256" => bytes2hex(open(sha256, outpath)))],
    )
end

open("Artifacts.toml", "w") do io
    TOML.print(io, artifacts)
end
