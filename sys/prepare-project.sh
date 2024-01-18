#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: prepare-project.sh <build dir>"
    exit 1
fi

SCRIPT_PATH=`readlink -f "$0"`
SCRIPT_DIR=`dirname "$SCRIPT_PATH"`
PROJECT_DIR=`readlink -f "$SCRIPT_DIR/.."`
BUILD_DIR="$1"

if [ -d "$PROJECT_DIR/build" ]; then
    echo "Directory 'build' already exists at project root"
    exit 1
fi

cd "$PROJECT_DIR"

mkdir -p "$BUILD_DIR/meson" "$BUILD_DIR/cache" "$BUILD_DIR/pyenv"
ln -s "$BUILD_DIR/meson" "build"
ln -s "$BUILD_DIR/cache" ".cache"

python -m venv "$BUILD_DIR/pyenv"
. "$BUILD_DIR/pyenv/bin/activate"
python -m pip install --upgrade pip
pip install meson

meson setup -Dbuildtype=debug -Dc_args="" -Dc_link_args="" \
            -Denable_libfuzzer=false \
            -Denable_r2r=false \
            -Denable_tests=false \
            -Duse_sys_openssl=true \
            -Duse_sys_zlib=true \
            build

