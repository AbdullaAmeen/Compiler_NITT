%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


%}


%token IF ELSE LPAREN RPAREN LBRACE RBRACE SEMICOLON EXP STMT



%%

program:
    | program IFBLOCK
    | program STMT SEMICOLON
    ;

IFBLOCK:
    IF LPAREN expr RPAREN LBRACE program RBRACE
        {  printf("if statement with condition \n"); }
    | IF LPAREN expr RPAREN LBRACE program RBRACE ELSE LBRACE program RBRACE
        {  printf("if-else statement with condition\n"); }
    |STMT;

expr: EXP;



%%

int main() {
    yyparse();

    printf("\n ::The expression is VALID:: \n");
    return 0;
}

void yyerror(char *msg) {
 printf("Syntax error: %s\n", msg);
 exit(0);
 
}

