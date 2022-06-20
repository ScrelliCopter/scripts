#!/bin/sh
set -e

BUILDDIR=build
TARGET=jucePlugin_All
CONFIG=Release

NPROC="$(sysctl -n hw.ncpu)"

cmake -G Xcode -B "$BUILDDIR" -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"
cmake --build "$BUILDDIR" --config "$CONFIG" --target "$TARGET" --parallel "$NPROC"
#xcodebuild build -project "$BUILDDIR/gearmulator.xcodeproj" -target "$TARGET" -configuration "$CONFIG" -parallelizeTargets -jobs "$NPROC"
cpack -G ZIP --config "$BUILDDIR/CPackConfig.cmake"
