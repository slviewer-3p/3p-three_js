#!/usr/bin/env bash

cd "$(dirname "$0")"

# turn on verbose debugging output
exec 4>&1; export BASH_XTRACEFD=4; set -x

# make errors fatal
set -e

# bleat on references to undefined shell variables
set -u

if [ -z "$AUTOBUILD" ] ; then
    exit 1
fi

if [ "$OSTYPE" = "cygwin" ] ; then
    export AUTOBUILD="$(cygpath -u $AUTOBUILD)"
fi

top="$(pwd)"
stage="$(pwd)/stage"

source_environment_tempfile="$stage/source_environment.sh"
"$AUTOBUILD" source_environment > "$source_environment_tempfile"
. "$source_environment_tempfile"

SOURCE_DIR="THREE.js"

build=${AUTOBUILD_BUILD_ID:=0}

cat "${SOURCE_DIR}/package.json" | python -c "import sys, json; print( json.load(sys.stdin)['version'])" > "$stage/VERSION.txt"

case "$AUTOBUILD_PLATFORM" in
    windows* | darwin64 | linux64 )

        mkdir -p "$stage/js"
        mkdir -p "$stage/LICENSES"

        cp "${SOURCE_DIR}/src/three.min.js" "$stage/js/"
        cp "${SOURCE_DIR}/src/OrbitControls.js" "$stage/js/"

        cp "${SOURCE_DIR}/LICENSE.txt" "$stage/LICENSES/THREEJS_LICENSE.txt"
    ;;
esac
