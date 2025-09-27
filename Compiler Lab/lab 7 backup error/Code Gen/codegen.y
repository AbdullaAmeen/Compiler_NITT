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
void gTC() {
    int nextRegister = 1;
    

    for (int i = 0; i < quadTable.size(); i++) {
        code& q = quadTable[i];
        string arg1Reg, arg2Reg, resultReg;
        if (q.arg1[0] == 't') {
            arg1Reg = "R";
            arg1Reg.append(1, q.arg1[1]);
            //nextRegister++;
        }
        else {
            arg1Reg = q.arg1.;
        }
        if (q.arg2[0] == 't') {
            arg1Reg = "R";
            arg1Reg.append(1, q.arg2[1]);
            //nextRegister++;
        }
        else {
            arg2Reg = q.arg2;
        }
        if (q.result[0] == 't') {
            resultReg = "R" + to_string(nextRegister);
            nextRegister++;
        }
        else {
            resultReg = q.result;
        }
        if (q.op == '+') {
            cout << "mov " << resultReg << ", " << arg1Reg << "\n";
            cout << "add " << resultReg << ", " << arg2Reg << "\n";
        }
        else if (q.op == '-') {
            cout << "mov " << resultReg << ", " << arg1Reg << "\n";
            cout << "sub " << resultReg << ", " << arg2Reg << "\n";
        }
        else if (q.op == '*') {
            cout << "mov " << resultReg << ", " << arg1Reg << "\n";
            cout << "imul " << resultReg << ", " << arg2Reg << "\n";
        }
        else if (q.op == '/') {
            cout << "mov " << resultReg << ", " << arg1Reg << "\n";
            cout << "idiv " << resultReg << ", " << arg2Reg << "\n";
        }
        else if (q.op == '=') {
            cout << "mov " << q.result << ", " << arg1Reg << "\n";
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
    printf("CODE GEN \n");
    gTC();
    return 0;
}

int yyerror(char *s) {
    printf("%s\n", s);
    return 1;
}
