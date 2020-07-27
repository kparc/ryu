# This makefile builds libryu.a. Mostly useful for building
# the lib as a dependency in non-Bazel projects (e.g. CMake).
# Contributed by @gritzko. Supported on a best-effort basis.

#CC=tcc

CFLAGS = -fPIC $(RYUCFG) $(RYU_CFLAGS)
BIN = ../bin/

SRC=d2fixed.c d2s.c f2s.c

ifneq ($(CC),tcc)
  SRC += generic_128.c
endif

OBJ = $(SRC:.c=.o)

ALIB = libryu.a
SOLIB = libryu.so

INCLUDES = -I..

.SUFFIXES: .c

default: libs

.c.o:
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@

$(ALIB): $(OBJ)
	$(AR) rcs $(ALIB) $(OBJ)

$(SOLIB): $(OBJ)
	$(CC) -fpic -shared -o $(SOLIB) $(OBJ)

libs: $(ALIB) $(SOLIB)

.PHONY: install
install: libs
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	mkdir -p $(DESTDIR)$(PREFIX)/include
	cp $(ALIB) $(DESTDIR)$(PREFIX)/lib/$(ALIB)
	cp $(SOLIB) $(DESTDIR)$(PREFIX)/lib/$(SOLIB)
	cp ryu.h $(DESTDIR)$(PREFIX)/include/

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/lib/$(ALIB)
	rm -f $(DESTDIR)$(PREFIX)/include/ryu.h

TESTSRC=tests/common_test.cc tests/d2fixed_test.cc tests/d2s_intrinsics_test.cc tests/d2s_table_test.cc tests/d2s_test.cc tests/f2s_test.cc

ifneq ($(CC),tcc)
  TESTSRC+=tests/generic_128_test.cc
endif

TESTS = $(TESTSRC:.cc=.test)

.PHONY: gtest
gtest:
	make -C ../lib/gtest

%.test: %.cc $(ALIB)
	$(CXX) $(RYU_CFLAGS) -L/usr/lib64 $< ../lib/gtest/*.o -lpthread -frtti  -I.. $(ALIB) -o $(BIN)$@

.PHONY: test
test: gtest $(TESTS)

.PHONY: bench
bench: libs
	$(CXX) $(RYU_CFLAGS) -I. -I../lib/double-conversion benchmark/benchmark.cc ../lib/double-conversion/libdouble-conversion.a libryu.a -o $(BIN)bench_grisu
	$(CC) $(RYU_CFLAGS) -I. -I../lib benchmark/benchmark_fixed.c ../lib/mersenne/mersenne.a libryu.a -lm -o $(BIN)bench_printf_c
	$(CXX) $(RYU_CFLAGS) -I. -I../lib benchmark/benchmark_fixed.cc ../lib/mersenne/mersenne.a libryu.a -lm -o $(BIN)bench_printf_cc

.PHONY: clean
clean:
	rm -f $(OBJ) $(ALIB) $(SOLIB)
