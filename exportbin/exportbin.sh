#!/bin/sh

# http://www.metashock.de/2012/11/export-binary-with-lib-dependencies/
# Usage: cp BINARY TARGET_DIRECTORY

# parse command-line arguments
SELF=`basename "$0"`

if [ $# -lt 1 ]
then
    >&2 echo "$SELF: missing path to binary"
    exit 1
elif [ $# -lt 2 ]
then
    >&2 echo "$SELF: missing target folder"
    exit 1
elif [ $# -gt 2 ]
then
    >&2 echo "$SELF: too many arguments"
    exit 1
fi

PATH_TO_BINARY="$1"
TARGET_DIRECTORY="$2"

# if we cannot find the binary we abort
if [ ! -f "$PATH_TO_BINARY" -o ! -x "$PATH_TO_BINARY" ]
then
    >&2 echo "$SELF: $PATH_TO_BINARY: not regular executable file"
    exit 1
fi

# if we cannot find the target directory we abort
if [ ! -d "$TARGET_DIRECTORY" ]
then
    >&2 echo "$SELF: target '$TARGET_DIRECTORY' is not a directory"
    exit 1
fi

# copy the binary to the target directory
# create directories if required
cp --parents --preserve=mode,timestamps "$PATH_TO_BINARY" "$TARGET_DIRECTORY"

# copy the required shared libs to the target folder
# create directories if required
for lib in `ldd "$PATH_TO_BINARY" | sed 's/^.*=>//;s/^[ \t]*//;s/(.*)$//;s/[ \t]*$//;/^$/d'`
do
    cp -d --parents --preserve=mode,timestamps "$lib" "$TARGET_DIRECTORY"
    symlink=`realpath "$lib"`
    while [ -n "$symlink" -a "$symlink" != "$lib" ]
    do
        lib="$symlink"
        cp -d --parents --preserve=mode,timestamps "$lib" "$TARGET_DIRECTORY"
        symlink=`realpath "$lib"`
    done
done
