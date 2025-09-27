%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 1000
#define MAX_NAME_LENGTH 32

typedef struct {
    char name[MAX_NAME_LENGTH];
    char datatype[MAX_NAME_LENGTH];
    int offset;
    int size;
    int scope;
} symbol_t;

symbol_t symbol_table[MAX_SYMBOLS];
int num_symbols = 0;
int current_scope = 0;
%}

%union {
    char* string;
    int integer;
}

%token <string> IDENTIFIER
%token <string> TYPE_SPECIFIER
%token <integer> NUM
%token DATATYPE
%token SIZE
%token NEWLINE

%type <string> declaration
%type <string> var_declaration
%type <string> type_specifier
%type <integer> size

%%

program: declaration_list
    ;

declaration_list: declaration
    | declaration_list declaration
    ;

declaration: var_declaration
    ;

var_declaration: type_specifier IDENTIFIER size { 
        symbol_table[num_symbols].scope = current_scope;
        strncpy(symbol_table[num_symbols].name, $2, MAX_NAME_LENGTH);
        strncpy(symbol_table[num_symbols].datatype, $1, MAX_NAME_LENGTH);
        symbol_table[num_symbols].size = $3;
        symbol_table[num_symbols].offset = -1;
        num_symbols++;
    }
    ;

type_specifier: TYPE_SPECIFIER
    ;

size: '[' NUM ']' { $$ = $2; }
    | { $$ = 1; }
    ;

%%

int main() {
    yyparse();
    printf("Symbol Table:\n");
    printf("Name\tType\tOffset\tSize\tScope\n");
    for (int i = 0; i < num_symbols; i++) {
        printf("%s\t%s\t%d\t%d\t%d\n", symbol_table[i].name, symbol_table[i].datatype, symbol_table[i].offset, symbol_table[i].size, symbol_table[i].scope);
    }
    return 0;
}

int yyerror(char* message) {
    printf("Error: %s\n", message);
    exit(1);
}
