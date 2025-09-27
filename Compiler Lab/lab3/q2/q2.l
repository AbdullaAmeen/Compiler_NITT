%{
#include<stdio.h>
#include<string.h>
#include "y.tab.h"
%}

%%
[ \n\t]+ ;
main {return MAIN;}
[a-zA-Z][a-zA-Z0-9_]*    {strcpy(yylval.string,yytext);return ID; }
[0-9]+        {yylval.dval=atoi(yytext);
          return INT;}
[0-9]+\.[0-9]+   {
          yylval.dval=atof(yytext);
          return NUMBER;
                 }
. return yytext[0];
%%
int yywrap(){
return 1;
}