%{
    #include "y.tab.h"
	
%}

%%

int|float|char|double {
    printf("1");
    yylval.string= strdup(yytext);
    return DATATYPE;
}

[a-zA-Z][a-zA-Z0-9]* {
    printf("2");
    yylval.string= strdup(yytext);
    return IDENTIFIER;
}



[1-9][0-9]* {
    yylval.integer= atoi(yytext);
    return SIZE;
}

[\n] {
    return NEWLINE;
}

[\t] {
    /* Ignore whitespace */
}

. {
    printf("Error: Invalid character: %c\n", *yytext);
}

%%


