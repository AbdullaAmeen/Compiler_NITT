%{
#include <stdio.h>
%}

%token NUMBER ID BOOLAND RELOPLTE RELOPE RELOPNE RELOPGTE BOOLOR
%right '='
%left BOOLOR
%left BOOLAND
%left RELOPE RELOPNE
%left RELOPGTE RELOPLTE '<' '>'

%left '+' '-' 
%left '*' '/' '%'
%right '!'
%%
E : T	 {
				printf("The expression is Valid \n");
				printf("Result = %d\n", $$);
				return 0;
			}

T :
	T '+' T { $$ = $1 + $3;}
	| T '-' T { $$ = $1 - $3; }
	| T '*' T { $$ = $1 * $3; }
	| T '/' T { $$ = $1 / $3; }
	| T '%' T { $$ = $1 % $3; }
	
    | T BOOLAND T {$$ = $1 && $3; }
	| T BOOLOR T {$$ = $1 || $3; }

	| T RELOPE T {$$ = $1 == $3;}
	| T RELOPNE T {$$ = $1 != $3; }
	| T RELOPGTE T {$$ = $1 >= $3; }
	| T RELOPLTE T {$$ = $1 <= $3; }
	| T '>' T {$$ = $1 > $3; }
	| T '<' T {$$ = $1 < $3; }
	
	| '!' NUMBER {$$ = !$1; }
	| '!' ID {$$ = !$1; }
	| '-' NUMBER { $$ = -$2; }
	| '-' ID { $$ = -$2; }
	| '(' T ')' { $$ = $2; }
	| NUMBER { $$ = $1; }
	| ID { $$ = $1; };
%%

int main() {
		printf("Enter the expression\n");
		yyparse();
}

/* For printing error messages */
int yyerror(char* s) {
	printf("\nExpression is invalid\n");
}
