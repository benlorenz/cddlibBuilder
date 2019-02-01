# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build cddlibBuilder
sources = [
    "https://github.com/cddlib/cddlib/releases/download/0.94j/cddlib-0.94j.tar.gz" =>
    "27d7fcac2710755a01ef5381010140fc57c95f959c3c5705c58539d8c4d17bfb",
]
name = "cddlib"
version = v"0.94j"

# Bash recipe for building across all platforms
script = raw"""
cd cddlib-0.94j
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
    "https://github.com/JuliaMath/GMPBuilder/releases/download/v6.1.2-2/build_GMP.v6.1.2.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
