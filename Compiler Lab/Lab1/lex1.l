/* regular definitions */

delim   [ \t\n]

string   ["].*["]

ws      {delim}+

mlcom   "/*"[^\*]*"*/"

lcom    "//".*

com     {lcom}|{mlcom}

redSpace [ ]


%%

{string}    printf("%s", yytext); 

{com}    ;

{ws}    printf(" ");




%%

main(){

    yylex();
    printf("\n");
}