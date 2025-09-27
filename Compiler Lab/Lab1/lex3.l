/* regular definitions */
%{
    #include<string.h>
%}
delim   [ \t\n]

ws      {delim}+

mlcom   "/*"[^\*]*"*/"

lcom    "//".*

com     {lcom}|{mlcom}

%%

{com}    ;

{ws}    printf(" ");


"<"     {printf(" < <,RELOP > ");} 

"<="    {printf(" < <=,RELOP > ");} 

"==" {printf(" < ==,RELOP > ");}

"!="    {printf(" < !=,RELOP > ");}

">" {printf(" < >,RELOP > ");}

">=" {printf(" < >=,RELOP > ");}

"&&" {printf(" < &&,AND > ");}

"||" {printf(" < ||,OR > ");}

"!" {printf(" < !,NOT > ");}

"<<" {printf(" < <<,LSHFT > ");}

">>" {printf(" < >>,RSHFT > ");}

"~" {printf(" < ~,COM > ");}

"&" {printf(" < &,BAND > ");}

"|" {printf(" < |,BOR > ");}

"^" {printf(" < ^,BEXOR > ");}

"++"    {printf(" < ++, UADD > ");}

"--"    {printf(" < ++, USUB > ");}

"+" {printf(" < +, ADD > ");}

"-" {printf(" < -, SUB > ");}

"/" {printf(" < /, DIV > ");}

"*" {printf(" < *, MUL > ");}

"="    printf(" < %s, ASN >", yytext);

"+="    printf(" < %s, ASN >", yytext);

"-="    printf(" < %s, ASN >", yytext);

"*="    printf(" < %s, ASN >", yytext);

"/="    printf(" < %s, ASN >", yytext);

"%="    printf(" < %s, ASN >", yytext);

"<<="   printf(" < %s, ASN >", yytext);

">>="   printf(" < %s, ASN >", yytext);

"&="    printf(" < %s, ASN >", yytext);

"^="    printf(" < %s, ASN >", yytext);

"|="    printf(" < %s, ASN >", yytext);

%%

main(){

    yylex();
    printf("\n \n");
}