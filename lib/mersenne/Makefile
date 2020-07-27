all:
	rm -f mersenne.*
	$(CC) $(RYU_CFLAGS) -shared -fpic random.c -o mersenne.so
	$(CC) $(RYU_CFLAGS) random.c -o mersenne.o -c
	$(AR) rcs mersenne.a mersenne.o
	