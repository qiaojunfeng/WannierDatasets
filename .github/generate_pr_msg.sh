#!/bin/bash
# Generate PR message for `mshick/add-pr-comment@v2`.
# Need three input arguments:
# - $1: the URL of the draft release
# - $2: the guessed next version number
# - $3: the current version number in `Project.toml`

output_file="pr_msg.txt"
echo "Write PR message to $(realpath $output_file)"

cat << EOF > $output_file
A draft release is created here:
<$1>

EOF

if [[ "$2" == "$3" ]]
then
# unicode
# TICK='\U2705'
# Switch to GitHub markdown
TICK=':heavy_check_mark:'
echo -n -e "$TICK versions are consistent" >> $output_file
else
# CROSS='\U274C'
CROSS=':x:'
echo -n -e "$CROSS versions inconsistent, **check if this is what you want?**" >> $output_file
fi

cat << EOF >> $output_file

- [\`release-drafter\`](https://github.com/release-drafter/release-drafter#version-resolver) auto generated version: \`$2\`
- version you specified in \`Project.toml\`: \`$3\`

EOF

cat << EOF >> $output_file
Once this PR is merged, you can publish the draft release, and a git tag will be created automatically.
EOF
