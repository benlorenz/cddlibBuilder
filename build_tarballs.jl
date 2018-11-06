# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build MPFRBuilder
sources = [
    "https://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.xz" =>
    "67874a60826303ee2fb6affc6dc0ddd3e749e9bfcb4c8655e3953d0458a6e16e",
]
name = "MPFR"
version = v"4.0.1"

# Bash recipe for building across all platforms
script = raw"""
cd mpfr-4.0.1
UNAME=`uname`
./configure --prefix=$prefix --host=$target --enable-shared --disable-static --with-gmp=$prefix
make -j
make install


"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libmpfr", :libmpfr)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/benlorenz/GMPBuilder/releases/download/v6.1.2-2/build_GMP.v6.1.2.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
