%{
    #include<stdio.h>
    #include<string.h>
    #include "y.tab.h"
%}
dataTypes int|float|long|double|char|struct|union|enum|void|long[ ]*double|long[ ]*int|long[ ]*long|long[ ]*float|long[ ]*char|unsigned[ ]*int|unsigned[ ]*long|unsigned[ ]*double|unsigned[ ]*char|signed[ ]*int|signed[ ]*long|signed[ ]*double|signed[ ]*char|short
keyword auto|break|case|const|continue|default|do|extern|for|goto|if|inline|register|restrict|return|sizeof|static|switch|typedef|volatile|while|include|define|ifdef|ifndef|else|endif

%option noyywrap

%%

{dataTypes}" "                  {return DATATYPE;}
{keyword}" "                    ;
[0-9]+                          {strcpy(yylval.str, yytext); return NUMBER;}
[a-zA-Z_][_a-zA-Z0-9]*          {strcpy(yylval.str, yytext); return IDENTIFIER;}
"&&"                            {return AND;}    
"||"                            {return OR;}
">="                            {return GE;}
"<="                            {return LE;}
"=="                            {return EE;}
"!="                            {return NE;}
\t                              ;
[ ]                             ;
\n                              ;
.                               {return yytext[0];}

%%