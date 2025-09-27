%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>   
    #include<bits/stdc++.h>
    using namespace std;
  int yylex();
void yyerror(char *msg);
  int sCount=0;
  int qCount=0;
  int temp_var=0;
  void addQuadruple(char,char [],char [],char []);
  void display_Quadruple();
  void push(char*);
  char* pop();
  void display_Code();
  struct Quadruple
  {
    char op;
    char arg1[10];
    char arg2[10];
    char result[10];
  };
  vector<Quadruple> QUAD(50);
  void optimize_code() {
    int i, j;
    for (i = 0; i < qCount; i++) {
        // Check for constant folding 
        if (QUAD[i].op == '+' || QUAD[i].op == '-' || QUAD[i].op == '*' || QUAD[i].op == '/') {
            int arg1 = atoi(QUAD[i].arg1);
            int arg2 = atoi(QUAD[i].arg2);
            if (isdigit(QUAD[i].arg1[0]) && isdigit(QUAD[i].arg2[0])) {
                int result;
                switch (QUAD[i].op) {
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
                sprintf(QUAD[i].arg1, "%d", result);
                QUAD[i].arg2[0] = '\0';
            }
        } 
    }
}    
void DeadCodeAndCommonSUb() {
    unordered_map<string, bool> usedVars;
   usedVars[QUAD[qCount-1].result] = true;
    for (int i = qCount - 1; i >= 0; i--) {
       
        if (QUAD[i].op == '=' &&  (usedVars.find(QUAD[i].result) == usedVars.end()) && i != qCount-1){
            usedVars[QUAD[i].result] = false;
        }
        else {
            if(strcmp(QUAD[i].arg1,""))
            usedVars[QUAD[i].arg1] = true;
            if(strcmp(QUAD[i].arg2,""))
            usedVars[QUAD[i].arg2] = true;
        }
        if (!usedVars[QUAD[i].result]) {  
            QUAD.erase(QUAD.begin() + i);
            qCount--;
        }
    }


    unordered_map<string, string> exprTable;
    int quadIndex = 0;
    while (quadIndex < qCount) {
        int flag = 0;
        string currExprKey = string(1, QUAD[quadIndex].op) + QUAD[quadIndex].arg1 + QUAD[quadIndex].arg2;
        if (exprTable.find(currExprKey) != exprTable.end() ) {
            for(int i= quadIndex - 1; i>-1; i--){
                if(!strcmp(QUAD[quadIndex].arg1 ,QUAD[i].result) || !strcmp(QUAD[quadIndex].arg2,QUAD[i].result)){
                     flag = 1;
                      break;  
                }
                if(!strcmp(QUAD[quadIndex].arg1,QUAD[i].arg1) && !strcmp(QUAD[quadIndex].arg2,QUAD[i].arg2) && QUAD[quadIndex].op == QUAD[i].op)
                {
                    break;
                }
            }    
            if(flag) {
                exprTable[currExprKey] = QUAD[quadIndex].result;
                quadIndex++;
                break;

            }    
            string eliminatedVar = string(QUAD[quadIndex].result);
            strcpy(QUAD[quadIndex].result, exprTable[currExprKey].c_str());
            for (int i = quadIndex + 1; i < QUAD.size(); i++) {

                 if(QUAD[quadIndex].arg1 == QUAD[i].result || QUAD[quadIndex].arg2 == QUAD[i].result){
                    //cout<<"yes "<<QUAD[quadIndex].arg1<<" "<< QUAD[quadIndex].arg2 <<" "<<  QUAD[i].result;
                      break;  
                }
                if (string(QUAD[i].arg1) == eliminatedVar) {
                    strcpy(QUAD[i].arg1, QUAD[quadIndex].result);
                }
                if (string(QUAD[i].arg2) == eliminatedVar) {
                    strcpy(QUAD[i].arg2, QUAD[quadIndex].result);
                }
            }
            QUAD.erase(QUAD.begin() + quadIndex);
            qCount--;
            // quadIndex++;
        }
        else {
            exprTable[currExprKey] = QUAD[quadIndex].result;
            quadIndex++;
        }
    }
    int q = qCount-1;
    while (q  >= 0) {
        if(QUAD[q].op == '=' && (!strcmp(QUAD[q].arg1,"") || !strcmp(QUAD[q].arg2,""))){
            int qi = q-1;
            char ar[50];
            if(strcmp(QUAD[q].arg1,""))
              strcpy(ar,QUAD[q].arg1);
            else
              strcpy(ar,QUAD[q].arg2);  
            while(qi >= 0 ){
              if(!strcmp(QUAD[qi].result, ar)){
                QUAD[q].op = QUAD[qi].op;
                strcpy(QUAD[q].arg1,QUAD[qi].arg1);
                strcpy(QUAD[q].arg2,QUAD[qi].arg2);
                QUAD.erase(QUAD.begin() + qi);
                qCount--;
                break;
              }
              qi--;
            } 
             
        }
         q--;
    }
}
void math() {
    for (int i = 0; i < qCount; i++) {
      Quadruple& q = QUAD[i];
        if (QUAD[i].op == '+') {
            if (strcmp(QUAD[i].arg2, "0") == 0) {
                strcpy(QUAD[i].arg2, "");
            }
            else if (strcmp(QUAD[i].arg1, "0") == 0) {
                strcpy(QUAD[i].arg1, "");
            }
        }
        else if (QUAD[i].op == '*') {
            if (strcmp(QUAD[i].arg2, "1") == 0) {
                strcpy(QUAD[i].arg2, "");
            }
            else if (strcmp(QUAD[i].arg1, "1") == 0) {
                strcpy(QUAD[i].arg1, "");

            }
        }
    }
}

 struct Stack
  {
    char *items[10];
    int top;
  }Stk;
%}

%union
{
    int ival;          
    double dval;
        char string[10];
}


%token <dval> NUMBER
%token <dval> INT
%token <string> ID
%type <string> expr
%token MAIN
%left '+' '-'
%left '*' '/'
%%
start:MAIN '('')''{' body '}'
;
body: stmtlist
;

stmtlist: stmt stmtlist|
;

stmt : ID '=' INT ';' {
  char temp[10];
  sprintf(temp,"%d",(int)$3);
  addQuadruple('=',"",temp,$1);
}
| ID '=' NUMBER ';' {
  char temp[10];
  snprintf(temp,10,"%f",$3);
  addQuadruple('=',"",temp,$1);
}
| ID '=' ID ';'{
  int i,j;
  addQuadruple('=',"",$3,$1);
}
| ID '=' expr ';' { 
  char * tmp = pop();
  addQuadruple('=',"",tmp,$1); 
};

expr :expr '+' expr {
  char str[5],str1[5]="t";
  sprintf(str, "%d", temp_var);   
  strcat(str1,str);
  temp_var++;
  addQuadruple('+',pop(),pop(),str1);   
  int cur = qCount - 1;
                          
  push(str1);
  }
|expr '-' expr                 {
  char str[5],str1[5]="t";
  sprintf(str, "%d", temp_var);   
  strcat(str1,str);
  temp_var++;
   int cur = qCount - 1;
  addQuadruple('-',pop(),pop(),str1);
  push(str1);
  }  

|expr '*' expr {
  char str[5],str1[5]="t";
  sprintf(str, "%d", temp_var);       
  strcat(str1,str);
  temp_var++;
   int cur = qCount - 1;
  addQuadruple('*',pop(),pop(),str1);
  push(str1);
  }      
|expr '/' expr {
  char str[5],str1[5]="t";
  sprintf(str, "%d", temp_var);       
  strcat(str1,str);
  temp_var++;
   int cur = qCount - 1;  
  addQuadruple('/',pop(),pop(),str1);
  push(str1);
}    
   
|ID {  push($1);  
    }

|NUMBER {       
  char temp[10];
  snprintf(temp,10,"%f",$1);   
  push(temp);   
}
| INT {
  char temp[10];
  sprintf(temp,"%d",(int)$1);
  push(temp);
}
;
%%
extern FILE *yyin;
int main()
{
   
  Stk.top = -1;
  yyin = fopen("input.txt","r");
  printf("\nINTERMEDIATE CODE : \n");
  yyparse();
  display_Code();
  printf("\n\n");
  display_Quadruple();
  printf("\n\n");
  printf("\nAFTER OPTIMIZATION: \n");
  printf("\n\n");
  math();
  optimize_code();
  DeadCodeAndCommonSUb();
  display_Code();
  printf("\n\n");
    return(0);
}
void display_Code()
{
  int i;

  for(i=0;i<qCount;i++){
    if(!strcmp(QUAD[i].arg2, "")){
      printf("\n %s := %s",QUAD[i].result,QUAD[i].arg1);
    }
    else if (!strcmp(QUAD[i].arg1, "")){
      printf("\n %s := %s",QUAD[i].result,QUAD[i].arg2);
    }
    else
      printf("\n %s := %s %c %s",QUAD[i].result,QUAD[i].arg2,QUAD[i].op,QUAD[i].arg1);

    
  }
}
void display_Quadruple()
{
  int i;
  printf("\nThe Quadruple Table \n");
  printf("\n   |Res\t|Op\t|Opr1\t|Opr2\t|");
  for(i=0;i<qCount;i++)
    printf("\n %d |%s \t|%c \t|%s \t|%s\t|",i,QUAD[i].result,QUAD[i].op,QUAD[i].arg1,QUAD[i].arg2);
}
void yyerror(char *msg) {
 //if(flag)
 printf("Syntax error: %s\n", msg);
}

void push(char *str)
{
  Stk.top++;
    Stk.items[Stk.top]=(char *)malloc(strlen(str)+1);
  strcpy(Stk.items[Stk.top],str);
}
char * pop()
{
  int i;
  if(Stk.top==-1)
  {
     printf("\nStack Empty!! \n");
     exit(0);
  }
  char *str=(char *)malloc(strlen(Stk.items[Stk.top])+1);;
strcpy(str,Stk.items[Stk.top]);
  Stk.top--;
  return(str);
}
 void addQuadruple(char op,char op2[10],char op1[10],char res[10]){
                                        QUAD[qCount].op=op;
                                        strcpy(QUAD[qCount].arg1,op1);
                                        strcpy(QUAD[qCount].arg2,op2);
                                        strcpy(QUAD[qCount].result,res);
                    qCount++;
}