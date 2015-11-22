CFLAGS = -msse2 --std gnu99 -O0 -Wall

EXEC = naive_transpose sse_transpose sse_prefetch_transpose

all: $(EXEC)

SRCS_common = main.c

naive_transpose: $(SRCS_common) impl.c
	$(CC) $(CFLAGS) -Dnaive_transpose -o $@ $(SRCS_common)

sse_transpose: $(SRCS_common) impl.c
	$(CC) $(CFLAGS) -Dsse_transpose -o $@ $(SRCS_common)

sse_prefetch_transpose: $(SRCS_common) impl.c
	$(CC) $(CFLAGS) -Dsse_prefetch_transpose -o $@ $(SRCS_common)


run:
	echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
	perf stat -e cache-misses,cache-references,L1-dcache-load-misses,L1-dcache-store-misses,L1-dcache-prefetch-misses,L1-icache-load-misses  ./naive_transpose
	echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
	perf stat -e cache-misses,cache-references,L1-dcache-load-misses,L1-dcache-store-misses,L1-dcache-prefetch-misses,L1-icache-load-misses  ./sse_transpose
	echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
	perf stat -e cache-misses,cache-references,L1-dcache-load-misses,L1-dcache-store-misses,L1-dcache-prefetch-misses,L1-icache-load-misses  ./sse_prefetch_transpose

clean:
	$(RM) $(EXEC) *.o perf.*
