# jitcalc

A simple integer calculator using JIT compilation.

By means of the [DynASM](https://luajit.org/dynasm.html) runtime assembler of
the [LuaJIT](https://luajit.org/) project, the expressions will be translated
into x86-64 instructions. So they, the evaluation of the given expressions can
be much faster than pure interpreters.

## Features

1. Only integer operations are supported;
2. add, substrate, multiply and divide;
3. logic and comparison;
4. function call;
5. tenary operation;

## License

`jitcalc` is licensed under the MIT License.
