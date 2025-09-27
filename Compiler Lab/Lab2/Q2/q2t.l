%{
%}

dataType 	(int|float|double|char)

digit   [0-9]

INT		{digit}+

array 	"["{INT}"]" 

CHAR 	"'"."'"
%%

{array}		{printf("%s", yytext);}
{CHAR}		{printf("CHAR");}
{dataType} {printf("DATATYPE ");}
[0-9]+ {
			printf("nUM");
			}

[a-zA-Z]+ {  printf(" ID ");}

[ \t]+		 ; /*For skipping whitespaces*/




%%
