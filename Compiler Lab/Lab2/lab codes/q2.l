%{
    #include "y.tab.h"
    
%}
alpha [A-Za-z]
digit [0-9]
%%
"int"       {return INTDT;}
"char"      {return CHARDT;}
"float"     {return FLOATDT;}
"double"    {return DOUBLEDT;}

","         {return COM;}
";"         {return SC;}
"="         {return EQ;}
[ \n\t]+    ;


[+-]?{digit}+                               {return INTEGER;}
[+-]?{digit}+("."{digit}+)?(E[+-]?{digit})? {return NUMERIC;}
[']{alpha}[']                               {return CHAR;}

{alpha}({alpha}|{digit})*                   {yylval=yytext;return IDENTIFIER;}
"["{digit}+"]"                              {yylval=yytext;return ARRAYDEC;}
.           {return yytext[0];}

%%
// int yywrap(void){
//     return 1;
// }
// int main(){
//     yylex();
//     return 0;
// }          
