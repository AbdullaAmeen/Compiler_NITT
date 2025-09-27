%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <bits/stdc++.h>
using namespace std;

#define MAXCODE 1000
#define MAXSYMBOLS 100
int yyerror(char *);
extern FILE *yyin;
extern int yylex();
struct code {
    char op;
    char arg1[10];
    char arg2[10];
    char result[10];
};

struct symbol {
    char name[10];
    int value;
};

int ncode = 0;
vector<code> quadTable (MAXCODE);

struct symbol symbols[MAXSYMBOLS];

void gen_code(char op, char *ar1, char *ar2, char *res) {
    quadTable[ncode].op = op;
    //printf("ar1 %s",ar1);
    strcpy(quadTable[ncode].arg1, ar1);
    strcpy(quadTable[ncode].arg2, ar2);
    strcpy(quadTable[ncode].result, res);
    ncode++;
}

void print_code() {
    int i;
    for (i = 0; i < ncode; i++) {
        printf("%c %s %s %s\n", quadTable[i].op, quadTable[i].arg1, quadTable[i].arg2, quadTable[i].result);
        //printf("%c ", quadTable[i].op);
    }
}
void print_proper_code() {
    int i;
    for (i = 0; i < ncode; i++) {
        if(strcmp(quadTable[i].arg2, ""))
        printf("%s = %s %c %s\n", quadTable[i].result, quadTable[i].arg1, quadTable[i].op, quadTable[i].arg2);
        else
        printf("%s = %s \n", quadTable[i].result, quadTable[i].arg1);
        //printf("%c ", quadTable[i].op);
    }
}
void optimize_code() {
    int i, j;
    for (i = 0; i < ncode; i++) {
        // Check for constant folding 
        if (quadTable[i].op == '+' || quadTable[i].op == '-' || quadTable[i].op == '*' || quadTable[i].op == '/') {
            int arg1 = atoi(quadTable[i].arg1);
            int arg2 = atoi(quadTable[i].arg2);
            if (isdigit(quadTable[i].arg1[0]) && isdigit(quadTable[i].arg2[0])) {
                int result;
                switch (quadTable[i].op) {
                    case '+':
                        result = arg1 + arg2;
                        break;
                    case '-':
                        result = arg1 - arg2;
                        break;
                    case '*':
                        result = arg1 * arg2;
                        break;
                    case '/':
                        result = arg1 / arg2;
                        break;
                }
                sprintf(quadTable[i].arg1, "%d", result);
                quadTable[i].arg2[0] = '\0';
            }
        } 
    }
}    
void elCSandDeadcode() {
    unordered_map<string, string> exprTable;
    int quadIndex = 0;
    while (quadIndex < ncode) {
        string currExprKey = string(1, quadTable[quadIndex].op) + quadTable[quadIndex].arg1 + quadTable[quadIndex].arg2;
        if (exprTable.find(currExprKey) != exprTable.end()) {
            string eliminatedVar = string(quadTable[quadIndex].result);
            strcpy(quadTable[quadIndex].result, exprTable[currExprKey].c_str());
            for (int i = quadIndex + 1; i < quadTable.size(); i++) {
                if (string(quadTable[i].arg1) == eliminatedVar) {
                    strcpy(quadTable[i].arg1, quadTable[quadIndex].result);
                }
                if (string(quadTable[i].arg2) == eliminatedVar) {
                    strcpy(quadTable[i].arg2, quadTable[quadIndex].result);
                }
            }
            quadTable.erase(quadTable.begin() + quadIndex);
            ncode--;
        }
        else {
            exprTable[currExprKey] = quadTable[quadIndex].result;
            quadIndex++;
        }
    }
    unordered_map<string, bool> usedVars;
    for (int i = ncode - 1; i >= 0; i--) {
        if (quadTable[i].op == '=') {
            usedVars[quadTable[i].result] = false;
        }
        else {
            usedVars[quadTable[i].arg1] = true;
            usedVars[quadTable[i].arg2] = true;
        }
        if (!usedVars[quadTable[i].result]) {
            quadTable.erase(quadTable.begin() + i);
            ncode--;
        }
    }
}
void math() {
    for (int i = 0; i < ncode; i++) {
        code& q = quadTable[i];
        if (quadTable[i].op == '+') {
            if (strcmp(quadTable[i].arg2, "0") == 0) {
                strcpy(quadTable[i].arg2, "");
            }
            else if (strcmp(quadTable[i].arg1, "0") == 0) {
                strcpy(quadTable[i].arg1, "");
            }
        }
        else if (quadTable[i].op == '*') {
            if (strcmp(quadTable[i].arg2, "1") == 0) {
                strcpy(quadTable[i].arg2, "");
            }
            else if (strcmp(quadTable[i].arg1, "1") == 0) {
                strcpy(quadTable[i].arg1, "");

            }
        }
    }
}

%}
%union{
    char* str;
    struct arg{
        char arg1[10];
        char arg2[10];
        char op;
    } ar;
}
%token <str>NUM 
%token EOL
%token <str> ID
%type <ar> expr
%type <str>term
%start program
%%
program: /* empty */
    |ID '=' expr EOL { gen_code($3.op, $3.arg1, $3.arg2, $1);}  program 
    |  ID '=' expr EOL { gen_code($3.op, $3.arg1, $3.arg2, $1);} 
    |  ID '=' expr { gen_code($3.op, $3.arg1, $3.arg2, $1);} 
    ;
expr:    term '+' term
      { strcpy($$.arg1, $1); strcpy($$.arg2, $3); $$.op = '+';} 
    | term '-' term 
  { strcpy($$.arg1, $1); strcpy($$.arg2, $3); $$.op = '-';}
    | term '*' term
   { strcpy($$.arg1, $1); strcpy($$.arg2, $3); $$.op = '*';}
    | term '/' term 
    { strcpy($$.arg1, $1); strcpy($$.arg2, $3); $$.op = '/';}
    ;

term: ID {$$ = $1;}
    | NUM {$$ = $1;}
    ;
%%

int main(int argc, char **argv) {
    FILE *inp;
    inp = fopen(argv[1], "r");

    char c;
    printf("INPUT \n");
    c = fgetc(inp);
    while (c != EOF)
    {
        printf ("%c", c);
        c = fgetc(inp);
    }
  
    fclose(inp);
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("fopen");
        return 1;
    }

    int ret = yyparse();
    fclose(yyin);
   /* if(ret){
        exit(0);
    }*/
    printf("\nQuadruples \n");
    print_code();
    printf("optimized code \n");
    optimize_code();
    elCSandDeadcode();
    math();
    print_proper_code();
    return 0;
}

int yyerror(char *s) {
    printf("%s\n", s);
    return 1;
}
