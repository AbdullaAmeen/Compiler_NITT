%{
#include "y.tab.h"
%}

%%
[ \t]+          ; /* ignore whitespace */
[0-9]+          { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return ID; }
[\+\-\*\/\(\)\=]    { return yytext[0]; }
\n          { return(EOL);}
.          { printf("Invalid character\n"); }
%%

int yywrap(void) {
    return 1;
}
