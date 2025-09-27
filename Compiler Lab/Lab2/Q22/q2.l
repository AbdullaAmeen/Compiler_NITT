%{
    #include "y.tab.h"
    
%}
alpha [A-Za-z]
digit [0-9]
%%
"int"       {return INT;}
"char"      {return CHART;}
"float"     {return FLOAT;}
"double"    {return DOUBLE;}

[ \n\t]+    ;


[+-]?{digit}+                               {return INTEGER;}
[+-]?{digit}+("."{digit}+)?(E[+-]?{digit})? {return NUMERIC;}
[']{alpha}[']                               {return CHAR;}

{alpha}({alpha}|{digit})*                   {yylval=yytext;return IDENTIFIER;}
.           {return yytext[0];}

%%
