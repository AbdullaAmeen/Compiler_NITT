%{
#include <stdio.h>

#include "y.tab.h"
%}

%%
"if"   { return IF; }
"else" { return ELSE; }
"("    { return LPAREN; }
")"    { return RPAREN; }
"{"    { return LBRACE; }
"}"    { return RBRACE; }
";"    { return SEMICOLON; }
"exp" { return EXP;}

"stmt"  {return STMT;}

[ \t\n] { /* ignore whitespace */ }
.      { printf("Error: unknown token\n"); }

%%

int yywrap() { return 1; }

