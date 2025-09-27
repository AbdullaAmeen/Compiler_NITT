%{
	/* Definition section*/
	#include "y.tab.h"
	extern yylval;
%}

dataType 	(int|float|double|char)

letter  [_A-Za-z]

digit   [0-9]

INT		{digit}+

FLOAT	{digit}+(\.{digit}+)?


CHAR 	"'"."'"

%%

{dataType} { yylval = yytext; return dataType;}


{INT} {
			yylval = atoi(yytext);
			return INT;
			}

{FLOAT} {
		yylval = atof(yytext);
 		return FLOAT;	
	}

[a-zA-Z]+ {  
	yylval= strdup(yytext); 
	return ID; 
}
[ \t]+		 ; /*For skipping whitespaces*/



\n		 { return 0; }

%%
