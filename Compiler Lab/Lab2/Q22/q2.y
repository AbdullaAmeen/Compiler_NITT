%{
    #include<stdio.h>
    #include<string.h>
    extern FILE* yyin;
    struct S_TABLE {
        char name[100],datatype[100],scope[100];
        int offset,size;
    } sTable[20];
    
    char lexeme[100];
    extern char* yytext;
    extern char* yylval;
    
    int i=0,count=0;
    extern char* yytext;
    int flag = 1;
%}
%token INT CHART FLOAT DOUBLE
%token INTEGER CHAR NUMERIC
%token IDENTIFIER  
%define api.value.type { char* }
%start S
%%

S : S1              {printf("\nExpression is VALID \n");return 0;}
S1 : S2 S1
    | S2
S2 : INT R1 ';'
    | FLOAT R2 ';'
    | CHART R3 ';'
    | DOUBLE R4 ';'

R1 : R1 ',' IDENTIFIER  {strcpy(lexeme,yylval);} OPT {insert(0);}
    | IDENTIFIER        {strcpy(lexeme,yylval);} OPT {insert(0);} 
R2 : R2 ',' IDENTIFIER  {strcpy(lexeme,yylval);} OPT {insert(1);}
    | IDENTIFIER        {strcpy(lexeme,yylval);} OPT {insert(1);}
R3 : R3 ',' IDENTIFIER  {strcpy(lexeme,yylval);} OPT {insert(2);}
    |IDENTIFIER         {strcpy(lexeme,yylval);} OPT {insert(2);}
R4 : R4 ',' IDENTIFIER  {strcpy(lexeme,yylval);} OPT {insert(3);}
    |IDENTIFIER         {strcpy(lexeme,yylval);} OPT {insert(3);}

OPT : '=' INTEGER        
    | '=' NUMERIC
    | '=' CHAR
    |                   ;

%%

int main(){
    yyin=fopen("file.c","r");
    yyparse();
    if(flag){
        
        printf("\n::::::Symbol Table:::::\n");
        printf("|ID\t|Type\t|Offset\t|Size\t|Scope|\n");
        for(i=0;i<count;i++){
            printf("|%s\t|%s\t|%d\t|%d\t|%s|\n",sTable[i].name,sTable[i].datatype,sTable[i].offset,sTable[i].size,sTable[i].scope);
        }
        printf("\n");
    }
    return 0;
}
void insert(int type){
    for(i=0;i<count;i++){
        if(strcmp(lexeme,sTable[i].name)==0)
        {
                printf("ERROR: VAR ALREADY FOUND:%s\n",lexeme);
                exit(0);
        }
    }

    strcpy(sTable[count].name,lexeme);
    if(type==0){
        sTable[count].size=2;
        strcpy(sTable[count].datatype,"int");
   }
    else if(type==1){
        sTable[count].size=4; 
        strcpy(sTable[count].datatype,"float");
    }
    else if(type==2){
        sTable[count].size=1;   
        strcpy(sTable[count].datatype,"char");
 
    }
    else{
        sTable[count].size=8; 
        strcpy(sTable[count].datatype,"double");
    }

    if(count==0){
        sTable[count].offset=0;
    }
    else{
        sTable[count].offset=sTable[count-1].offset+sTable[count-1].size;
    }

    strcpy(sTable[count].scope,"local");
    count++;
    
}
int calcSize(char *temp){
    char *result=temp+1;
    result[strlen(result)-1]='\0';
    return atoi(result);
} 
int yyerror(char* s) {
    printf("\nEnter VALID INPUT.\n");
    flag = 0;
    exit(0);
}
int yywrap(){
    return 1;
}