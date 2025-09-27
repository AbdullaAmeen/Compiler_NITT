%{
	/* Definition section*/
	#include "y.tab.h"
	extern yylval;
%}

%%
[0-9]+ {
			yylval = atoi(yytext);
			return NUMBER;
			}

[a-zA-Z]+ { return ID; }
[ \t]+		 ; /*For skipping whitespaces*/

\n		 { return 0; }


"<="    {return RELOPLTE;} 

"==" {return RELOPE;}

"!="    {return RELOPNE;}

">=" {return RELOPGTE;}




"&&" {return BOOLAND;}

"||" {return BOOLOR;}





.		 { return yytext[0]; }

%%
