%{
    #include<stdio.h>
    #include<string.h>
    char name[100][20],datatype[100][20],scope[100][10];
    char lexeme[100];
    int offset[100],size[100];
    int i=0,count=0,arrayFlag=0,arraySize=0;
    extern char* yytext;
    extern char* yylval;
    extern FILE* yyin;
%}
%token INTDT CHARDT FLOATDT DOUBLEDT
%token INTEGER CHAR NUMERIC
%token IDENTIFIER ARRAYDEC COM SC EQ
%define api.value.type { char* }
%start START
%%

START : S1              {printf("\nParsing Successful\n\n");return 0;}
S1 : S2 S1
    | S2
S2 : INTDT R1 SC
    | FLOATDT R2 SC
    | CHARDT R3 SC
    | DOUBLEDT R4 SC

R1 : R1 COM IDENTIFIER  {strcpy(lexeme,yylval);} OPT {insert(0);}
    | IDENTIFIER        {strcpy(lexeme,yylval);} OPT {insert(0);} 
R2 : R2 COM IDENTIFIER  {strcpy(lexeme,yylval);} OPT {insert(1);}
    | IDENTIFIER        {strcpy(lexeme,yylval);} OPT {insert(1);}
R3 : R3 COM IDENTIFIER  {strcpy(lexeme,yylval);} OPT {insert(2);}
    |IDENTIFIER         {strcpy(lexeme,yylval);} OPT {insert(2);}
R4 : R4 COM IDENTIFIER  {strcpy(lexeme,yylval);} OPT {insert(3);}
    |IDENTIFIER         {strcpy(lexeme,yylval);} OPT {insert(3);}

OPT : EQ INTEGER        
    | EQ NUMERIC
    | EQ CHAR
    | ARRAYDEC          {arrayFlag=1;arraySize=calcSize(yylval);}
    |                   ;

%%

int main(){
    yyin=fopen("file.c","r");
    yyparse();
    /*printf("\n\t\t\t\tSymbol Table\n\n");
    printf("Identifier\tType\t\tOffset\t\tSize\t\tScope\n");
    printf("----------------------------------------------\n");
    for(i=0;i<count;i++){
        printf("%s\t\t%s\t\t%d\t\t%d\t\t%s\n",name[i],datatype[i],offset[i],size[i],scope[i]);
    }
    printf("\n");*/
    return 0;
}
void insert(int type){
    for(i=0;i<count;i++){
        if(strcmp(lexeme,name[i])==0)
        {
                printf("Error- Redeclaration of variable:%s\n",lexeme);
                exit(0);
        }
    }

    strcpy(name[count],lexeme);
    if(type==0){
        strcpy(datatype[count],"int");
        //If its not an array, arraySize is set to 1
        size[count]=2*arraySize;
    }
    else if(type==1){
        strcpy(datatype[count],"float");
        size[count]=4*arraySize; 
    }
    else if(type==2){
        strcpy(datatype[count],"char");
        size[count]=1*arraySize;   
    }
    else{
        strcpy(datatype[count],"double");
        size[count]=8*arraySize; 
    }

    if(arrayFlag==1){
        strcat(datatype[count]," array");
    }

    if(count==0){
        offset[count]=0;
    }
    else{
        offset[count]=offset[count-1]+size[count-1];
    }

    strcpy(scope[count],"local");
    count++;
    
    arrayFlag=0;
}

int yyerror(char* s) {
    printf("\nInput is invalid. Parsing failed.\n");
}
int yywrap(){
    return 1;
}