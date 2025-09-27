#!/bin/bash
rm lex.yy.c output a.out y.tab.h y.tab.c
flex lex.l
yacc -d yacc.y 
g++ lex.yy.c y.tab.c
./a.out test