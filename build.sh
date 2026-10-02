#!/bin/sh
# Rebuilds every package in this repository.
#
# A package is built in two steps. mkfexe turns the .f! source in src/ into a
# .f! executable, which is the program a user runs. mkpkg then wraps that
# executable in a .f12 archive, which is what the index points at and what a
# user downloads. The archive carries a sha256 for every file it contains, and
# those are the digests "pls verify" checks after installing.
#
# Run this from the repository root. The F12 tools are not on PATH by default,
# so point MKFEXE and MKPKG at them:
#
#   MKFEXE="python3 /path/to/f12/tools/mkfexe" \
#   MKPKG="python3 /path/to/f12/tools/mkpkg" \
#   ./build.sh

set -e

MKFEXE=${MKFEXE:-mkfexe}
MKPKG=${MKPKG:-mkpkg}

rm -rf build
mkdir -p build packages

echo "building hello 1.0.0"
$MKFEXE --name hello --version 1.0.0 \
    --summary "the classic hello, echoes its arguments" \
    --source src/hello.f!.src build/hello.f!
$MKPKG --name hello --version 1.0.0 \
    --summary "the classic hello, echoes its arguments" \
    --license MIT --entry bin/hello.f! \
    --file bin/hello.f!=build/hello.f! \
    packages/hello.f12

echo "building lisp-test 1.0.0"
$MKFEXE --name lisp-test --version 1.0.0 \
    --summary "prints a greeting and echoes its arguments" \
    --depends "hello ^1.0.0" \
    --source src/lisp-test.f!.src build/lisp-test.f!
$MKPKG --name lisp-test --version 1.0.0 \
    --summary "prints a greeting and echoes its arguments" \
    --license MIT --entry bin/lisp-test.f! \
    --depends "hello ^1.0.0" \
    --file bin/lisp-test.f!=build/lisp-test.f! \
    packages/lisp-test.f12

cat > index.txt <<'EOF'
hello 1.0.0 the classic hello, echoes its arguments
lisp-test 1.0.0 prints a greeting and echoes its arguments
EOF

rm -f packages/hello.lisp packages/lisp-test.lisp
echo "done"