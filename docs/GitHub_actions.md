# Notes on GitHub Actions

## Release process

The current process of bumping version is:

- create a branch, since the `main` branch is protected.
  The branch name can be `bumpversion`.
- use `bump2version (major|minor|patch)` to update
  `.bumpversion.cfg` and `Project.toml`, and it will create a git commit
- create a PR
- the release workflow will run, it will
  - build the artifact tarballs
  - commit `Artifacts.toml`
  - create a draft release, with tarballs attached
  - check if the version in `Project.toml` is consistent with that suggested
    by the `release-drafter` workflow, and if not, add a comment to the PR
- once the PR is merged, publish the draft release, and it will create
  a git tag pointing to main (thus including the just merged PR)

In the end, we have:

- a new version git tagged
- an `Artifacts.toml` with updated tarball SHA
- a GitHub release with tarballs attached
- the version in `Project.toml` is consistent with the git tag

## Debugging

- to debug github workflows, set `ACTIONS_STEP_DEBUG` to `true` in secrets
