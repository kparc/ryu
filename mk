#!/bin/sh

OPT=""
#OPT="-DDRYU_DEBUG $OPT"
#OPT="-DRYU_OPTIMIZE_SIZE $OPT"
#OPT="-DRYU_ONLY_64_BIT_OPS $OPT"
#OPT="-DRYU_AVOID_UINT128 $OPT"
#OPT="-DRYU_32_BIT_PLATFORM $OPT"
#OPT="-DHAS_64_BIT_INTRINSICS $OPT"
#OPT="-DRYU_FLOAT_FULL_TABLE $OPT"
#OPT="-DHAS_UINT128 $OPT"

export CC=/opt/clang/bin/clang
#export CC=tcc
export CXX=/opt/clang/bin/clang++

export CFLAGS="-O3"
export RYU_CFLAGS="$CFLAGS"

#export CC=/opt/intel/bin/icc
#export CXX=/opt/intel/bin/icc
#export RYU_CFLAGS="$RYU_CFLAGS -mcpu=core-avx2 -axCORE-AVX2 -fno-stack-security-check\
# -fno-stack-protector -funroll-loops -finline-functions -finline -fbuiltin\
# -use-intel-optimized-headers -intel-extensions -qsimd-serialize-fp-reduction -pc64\
# -vec -noalign -ip"

mkdir -p bin/tests
cd lib/double-conversion && ./mk

cd ../..
make -C lib/mersenne
make -C lib/gtest

RYUCFG=$OPT make -C src clean libs test bench

echo
find bin/tests/*.test | xargs -0 | sh
echo

mkdir -p csv
S=100

for i in 1 10 100 1000; do
  F="glibc-printf-fixed-$i.csv"
  echo "$F..."
  bin/bench_printf_c -samples=$S -v -precision=$i > csv/$F.csv
  F="glibc-printf-exp-$i.csv"
  echo "$F..."  
  bin/bench_printf_c -samples=$S -v -precision=$i -exp > csv/$F.csv
  echo
done

echo
bin/bench_grisu
echo

#for i in 1 10 100 1000; do
#  echo $i
#  CC=musl-gcc src/bench_printf_c -samples=$S -v -precision=$i > musl-fixed-$i.csv
#  CC=musl-gcc src/bench_printf_c -samples=$S -v -precision=$i -exp > musl-exp-$i.csv
#done


#!~
