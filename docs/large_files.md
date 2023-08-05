# Notes on large files

## `util/GitHub-ForceLargeFiles`

GitHub has a limit of 100MB per file, to bypass this limit, there is a
python script `util/GitHub-ForceLargeFiles/src/main.py` that will auto
compress large files and split them into chunks.

To use it

```shell
python util/GitHub-ForceLargeFiles/src/main.py DIR_TO_CHECK
```

where `DIR_TO_CHECK` is the directory to check for large files.

To decompress the files, use

```shell
python util/GitHub-ForceLargeFiles/src/reverse.py DIR_TO_CHECK
```

For more information, see the two scripts.

## Adding large dataset files

Therefore, in general we should avoid adding large files. However, if e.g.
without enough kpoint sampling the band structure is really poor, then we
can use `main.py` script to compress the files and git commit the 7z files.
In the GitHub workflow, the `reverse.py` script will be run to decompress
the files and pack them into artifact tarballs.
