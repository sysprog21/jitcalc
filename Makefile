CC ?= gcc
CFLAGS = -Wall -O2 -std=gnu99 -g -fno-pie -no-pie

BIN = jitcalc
OBJS = jitcalc.o

deps := $(OBJS:%.o=%.o.d)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $< -MMD -MF $@.d

jitcalc: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $<

all: $(BIN)

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
	./jitcalc "mul(-1, -1) ? +1 : -1"
	./jitcalc "max(-100, +100)"

.PHONY: clean
clean:
	$(RM) jitcalc.c jitcalc
	$(RM) $(OBJS) $(deps)

distclean: clean
	rm -rf LuaJIT minilua

-include $(deps)
