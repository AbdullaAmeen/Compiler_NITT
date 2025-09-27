/* regular definitions */
%{
    #include<string.h>
%}
delim   [ \t\n]

ws      {delim}+

letter  [_A-Za-z]

digit   [0-9]

id      {letter}({letter}|{digit}){0,31}

number     {digit}+(\.{digit}+)?

invalidId  {digit}({letter})+

toolongId {letter}({letter}|{digit}){32,}

mlcom   "/*"[^\*]*"*/"

lcom    "//".*

com     {lcom}|{mlcom}

%%

{com}    ;

{ws}    printf(" ");

int      {printf("<INT ,%s>",yytext);}
struct      {printf("<STRUCT,%s>",yytext);}
break     {printf("<BREAK,%s>",yytext);}
else     {printf("<ELSE,%s>",yytext);}
long     {printf("<LONG,%s>",yytext);}
switch      {printf("<SWITCH,%s>",yytext);}
case     {printf("<CASE,%s>",yytext);}
enum     {printf("<ENUM,%s>",yytext);}
register     {printf("<REGISTER,%s>",yytext);}
typedef      {printf("<TYPEDEF,%s>",yytext);}
char     {printf("<CHAR,%s>",yytext);}
extern     {printf("<EXTERN,%s>",yytext);}
return     {printf("<RETURN,%s>",yytext);}
union     {printf("<UNION,%s>",yytext);}
continue     {printf("<CONTINUE,%s>",yytext);}
for     {printf("<FOR,%s>",yytext);}
signed     {printf("<SIGNED,%s>",yytext);}
void      {printf("<VOID,%s>",yytext);}
do     {printf("<DO,%s>",yytext);}
if     {printf("<IF,%s>",yytext);}
static     {printf("<STATIC,%s>",yytext);}
while      {printf("<WHILE,%s>",yytext);}
default     {printf("<DEFAULT,%s>",yytext);}
goto     {printf("<GOTO,%s>",yytext);}
sizeof     {printf("<SIZEOF,%s>",yytext);}
volatile      {printf("<VOLATILE,%s>",yytext);}
const     {printf("<CONST,%s>",yytext);}
float     {printf("<FLOAT,%s>",yytext);}
short     {printf("<SHORT,%s>",yytext);}
unsigned     {printf("<UNSIGNED,%s>",yytext);}

   
{id}    {printf("<ID,%s>",yytext);}

{invalidId} {printf("\n ID is invalid %s  \n", yytext);}

{toolongId} {printf("\n ID is too long %s \n", yytext);}

{number}    {printf("<NUM, %s>", yytext); }



%%

main(){

    yylex();
    printf("\n");
}