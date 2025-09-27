#!/bin/sh
rm y.tab.h y.tab.c lex.yy.c a.out
flex q2.l
yacc -d q2.y
g++ lex.yy.c y.tab.c 
./a.out input.txt