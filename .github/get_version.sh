#!/bin/bash
# Get version number from Project.toml

f="Project.toml"
# https://unix.stackexchange.com/questions/13466/can-grep-output-only-specified-groupings-that-match
regex='^version *= *"\K([\d\.]+)(?=" *)'
toml_version=$(grep -Po "$regex" "$f")

if test -z "$toml_version"
then
echo "No version found in $f" >&2
exit 1
fi

# prefix with 'v' to compare with git tag
echo "v$toml_version"
