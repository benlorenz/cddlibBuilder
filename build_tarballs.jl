# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build MPFRBuilder
sources = [
    "https://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.xz" =>
    "67874a60826303ee2fb6affc6dc0ddd3e749e9bfcb4c8655e3953d0458a6e16e",

]

# Bash recipe for building across all platforms
script = raw"""
cd mpfr-4.0.1
UNAME=`uname`
if [[ ${UNAME} == MSYS_NT-6.3 ]]; then
ln -sf $prefix/bin/libgmp-10.dll $prefix/lib/libgmp.lib && cp $prefix/bin/libgmp-10.dll $prefix/lib/libgmp.dll && ./configure --prefix=$prefix --host=$target --enable-shared --disable-static --with-gmp=$prefix
else
./configure --prefix=$prefix --host=$target --enable-shared --disable-static --with-gmp=$prefix
fi
make -j
make install


"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Windows(:i686, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
    BinaryProvider.Windows(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi),
    BinaryProvider.MacOS(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:i686, :glibc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libmpfr", :libmpfr)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaMath/GMPBuilder/releases/download/v6.1.2/build.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "MPFRBuilder", sources, script, platforms, products, dependencies)
