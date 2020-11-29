CC ?= gcc
CFLAGS = -Wall -O2 -g -fno-pie -no-pie

jitcalc: jitcalc.c
	$(CC) $(CFLAGS) -o jitcalc jitcalc.c

all: jitcalc

LuaJIT/src/host/minilua.c:
	git clone https://github.com/LuaJIT/LuaJIT
	touch $@

minilua: LuaJIT/src/host/minilua.c
	$(CC) $(CFLAGS) -o $@ $^ -lm

jitcalc.c: jitcalc.dasc minilua
	./minilua LuaJIT/dynasm/dynasm.lua -o jitcalc.c jitcalc.dasc

check: all
	./jitcalc "1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10"
	./jitcalc "1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10"
	./jitcalc "1 + 2 - 3 * 4 / 5 + 6 - 7 * 8 / 9 + 10"
	./jitcalc "5 > 3 ? 1 : 0"
	./jitcalc "99 != 100 ? 1 : 0"
	./jitcalc "abs(-1)"

.PHONY: clean
clean:
	rm -f jitcalc.c jitcalc
distclean: clean
	rm -rf LuaJIT minilua
