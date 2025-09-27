%{
#include <stdio.h>
#include <stdlib.h>
%}

%token NUM OP

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

statement_list : statement
               | statement_list statement
               ;

statement : expression ';' { printf("%d\n", $1); }
          | ';' { printf("\n"); }
          ;

expression : primary_expression
           | expression OP primary_expression { 
               if ($2 == INCREMENT) { 
                   $$ = $1 + 1; 
               } else { 
                   $$ = $1 - 1; 
               }
             }
           | primary_expression OP { 
               if ($2 == INCREMENT) { 
                   $$ = $1 + 1; 
               } else { 
                   $$ = $1 - 1; 
               }
             }
           ;

primary_expression : NUM
                    | '-' NUM %prec UMINUS { $$ = -$2; }
                    | '(' expression ')' { $$ = $2; }
                    ;

%%

int main() {
    yyparse();
    return 0;
}

int yylex() {
    return yylex();
}

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}
