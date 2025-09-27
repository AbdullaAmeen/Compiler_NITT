%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_IDENTIFIERS 100

typedef struct {
    char* name;
    char* datatype;
    int offset;
    int size;
} Identifier;

Identifier symbol_table[MAX_IDENTIFIERS];
int num_identifiers = 0;
int current_offset = 0;

void add_identifier(char* name, char* datatype, int size) {
    if (num_identifiers == MAX_IDENTIFIERS) {
        printf("Error: Symbol table overflow\n");
        exit(1);
    }
    symbol_table[num_identifiers].name = strdup(name);
    symbol_table[num_identifiers].datatype = strdup(datatype);
    symbol_table[num_identifiers].offset = current_offset;
    symbol_table[num_identifiers].size = size;
    num_identifiers++;
    current_offset += size;
}

void print_symbol_table() {
    int i;
    printf("%-10s%-10s%-10s%-10s\n", "Name", "Type", "Offset", "Size");
    for (i = 0; i < num_identifiers; i++) {
        printf("%-10s%-10s%-10d%-10d\n", symbol_table[i].name, symbol_table[i].datatype, symbol_table[i].offset, symbol_table[i].size);
    }
}

%}


%token IDENTIFIER
%token DATATYPE
%token SIZE
%token NEWLINE

%%

program: declaration_list
    ;

declaration_list: declaration
    | declaration_list declaration
    ;

declaration:  IDENTIFIER ':' DATATYPE SIZE NEWLINE {
        add_identifier($2, $3, $4);
    }
    ;

%%

int main() {
    
	parse();
    print_symbol_table();
    return 0;
}

int yywrap() {
    return 1;
}

int yyerror(char* msg) {
    printf("Error: %s\n", msg);
    return 1;
}
