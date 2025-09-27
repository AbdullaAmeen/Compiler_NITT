%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// /int flag = 1;
%}


%token WHILE LPAREN RPAREN LBRACE RBRACE SEMICOLON EXP STMT



%%

program:
    | program loop 
    | program STMT SEMICOLON
    {
        printf("Expression is valid \n");
        return 0;
    };

loop:
    WHILE LPAREN expr RPAREN LBRACE program RBRACE
        { //flag = 0; 
        printf("while Loop\n"); }
    |STMT;

expr: EXP;



%%

int main() {
    yyparse();
    return 0;
}

void yyerror(char *msg) {
 //if(flag)
 printf("Syntax error: %s\n", msg);
}

