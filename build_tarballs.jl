# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

commit_hash = "475890c3a760300f5b088c0c308d2b3b95b2acbb"

# Collection of sources required to build cddlibBuilder
sources = [
    "https://github.com/cddlib/cddlib/archive/$commit_hash.zip" =>
    commit_hash,
]
name = "cddlib"
version = v"0.94j+"

# Bash recipe for building across all platforms
script = raw"""
cd cddlib-475890c3a760300f5b088c0c308d2b3b95b2acbb
CPPFLAGS=-I$prefix/include ./configure --prefix=$prefix --host=$target
make -j
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libcddgmp", :libcddgmp)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/GMP-v6.1.2-1/build_GMP.v6.1.2.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
