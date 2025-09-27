#!/bin/bash
rm -f y.tab.c y.tab.h lex.yy.c q1 y.output
lex q1.l
bison -dyv q1.y 
gcc lex.yy.c y.tab.c -o q1
./q1 < input.txt