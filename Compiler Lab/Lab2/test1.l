%{
#include "y.tab.h"
%}

%%
"++"   { yylval.op = INCREMENT; return OP; }
"--"   { yylval.op = DECREMENT; return OP; }
[0-9]+ { yylval.num = atoi(yytext); return NUM; }
.      { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}
