%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>   
    #include<bits/stdc++.h>
    using nammespace std;


  int sCount=0;
  int qCount=0;
  int temp_var=0;
  void addQuadruple(char [],char [],char [],char []);
  void display_Quadruple();
  void push(char*);
  char* pop();
  void display_Code();
  struct Quadruple
  {
    char operator[5];
    char operand1[10];
    char operand2[10];
    char result[10];
  }QUAD[100];
// void print_proper_code() {
//     int i;
//     for (i = 0; i < ncode; i++) {
//         if(!strcmp(QUAD[i].arg2, "")){
//             if(QUAD[i].op == 'l'){
//                 printf("%s: \n", QUAD[i].result);
//             }
//             else
               
//                 printf("%s = %s \n", QUAD[i].result, QUAD[i].arg1);

//         }
//         else{
//             if(QUAD[i].op == '<' || QUAD[i].op == '>'){
//                 printf("if %s %c %s  goto %s \n",QUAD[i].arg1, QUAD[i].op, QUAD[i].arg2,QUAD[i].result );
//             }
        
//             else
//                  printf("%s = %s %c %s\n", QUAD[i].result, QUAD[i].arg1, QUAD[i].op, QUAD[i].arg2);
        
//         }
//         //printf("%c ", QUAD[i].op);
//     }
// }
void optimize_code() {
    int i, j;
    for (i = 0; i < ncode; i++) {
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
void elCSandDeadcode() {
    unordered_map<string, bool> usedVars;
    for (int i = ncode - 2; i >= 0; i--) {
        if (QUAD[i].op == '=') {
            usedVars[QUAD[i].result] = false;
        }
        else {
            usedVars[QUAD[i].arg1] = true;
            usedVars[QUAD[i].arg2] = true;
        }
        if (!usedVars[QUAD[i].result]) {
             if(QUAD[i].op == '<' || QUAD[i].op == '>' || QUAD[i].op == 'l' ){
                break;
            }
        
            QUAD.erase(QUAD.begin() + i);
            ncode--;
        }
    }


    unordered_map<string, string> exprTable;
    int quadIndex = 0;
    while (quadIndex < ncode) {
        int flag = 0;
        string currExprKey = string(1, QUAD[quadIndex].op) + QUAD[quadIndex].arg1 + QUAD[quadIndex].arg2;
                   // cout<<"outsideifyes "<<QUAD[quadIndex].arg1<<" "<< QUAD[quadIndex].arg2 <<" "<<  QUAD[quadIndex].result<<endl;

        if (exprTable.find(currExprKey) != exprTable.end() ) {
            //cout<<"quadINdex"<<quadIndex<<" "<<currExprKey<<endl;
            //cout<<"helloyes "<<QUAD[quadIndex].arg1<<" "<< QUAD[quadIndex].arg2 <<" "<<  QUAD[quadIndex].result<<endl;
            for(int i= quadIndex - 1; i>-1; i--){
                if(!strcmp(QUAD[quadIndex].arg1 ,QUAD[i].result) || !strcmp(QUAD[quadIndex].arg2,QUAD[i].result)){
                    //cout<<"yes "<<QUAD[quadIndex].arg1<<" "<< QUAD[quadIndex].arg2 <<" "<<  QUAD[i].result;
                     flag = 1;
                      break;  
                }
                if(!strcmp(QUAD[quadIndex].arg1,QUAD[i].arg1) && !strcmp(QUAD[quadIndex].arg2,QUAD[i].arg2) && QUAD[quadIndex].op == QUAD[i].op)
                {
                    //cout<<"findcesyes "<<QUAD[quadIndex].arg1<<" "<< QUAD[quadIndex].arg2 <<" "<<  QUAD[i].result;
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
            ncode--;
            // quadIndex++;
        }
        else {
            exprTable[currExprKey] = QUAD[quadIndex].result;
            quadIndex++;
        }
    }
    
}
void math() {
    for (int i = 0; i < ncode; i++) {
        code& q = QUAD[i];
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
  addQuadruple("=","",temp,$1);
}
| ID '=' NUMBER ';' {
  char temp[10];
  snprintf(temp,10,"%f",$3);
  addQuadruple("=","",temp,$1);
}
| ID '=' ID ';'{
  int i,j;
  addQuadruple("=","",$3,$1);
}
| ID '=' expr ';' { 
  char * tmp = pop();
  addQuadruple("=","",tmp,$1); 
};

expr :expr '+' expr {
  char str[5],str1[5]="t";
  sprintf(str, "%d", temp_var);   
  strcat(str1,str);
  temp_var++;
  addQuadruple("+",pop(),pop(),str1);   
  int cur = qCount - 1;
                          
  push(str1);
  }
|expr '-' expr                 {
  char str[5],str1[5]="t";
  sprintf(str, "%d", temp_var);   
  strcat(str1,str);
  temp_var++;
   int cur = qCount - 1;
  addQuadruple("-",pop(),pop(),str1);
  push(str1);
  }  

|expr '*' expr {
  char str[5],str1[5]="t";
  sprintf(str, "%d", temp_var);       
  strcat(str1,str);
  temp_var++;
   int cur = qCount - 1;
  addQuadruple("*",pop(),pop(),str1);
  push(str1);
  }      
|expr '/' expr {
  char str[5],str1[5]="t";
  sprintf(str, "%d", temp_var);       
  strcat(str1,str);
  temp_var++;
   int cur = qCount - 1;  
  addQuadruple("/",pop(),pop(),str1);
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
  printf("\nAFTER OPTIMIZATION CODE : \n");
  optimize_code();
  elCSandDeadcode();
  math();
  display_Code();
  return(0);
}
void display_Code()
{
  int i;

  for(i=0;i<qCount;i++){
    if(!strcmp(QUAD[i].operator,"="))
      printf("\n %s := %s",QUAD[i].result,QUAD[i].operand1);
    else
    printf("\n %s := %s %s %s",QUAD[i].result,QUAD[i].operand1,QUAD[i].operator,QUAD[i].operand2);

  }
}
void display_Quadruple()
{
  int i;
  printf("\nThe Quadruple Table \n");
  printf("\n   |Res\t|Op\t|Opr1\t|Opr2\t|");
  for(i=0;i<qCount;i++)
    printf("\n %d |%s \t|%s \t|%s \t|%s\t|",i,QUAD[i].result,QUAD[i].operator,QUAD[i].operand1,QUAD[i].operand2);
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
 void addQuadruple(char op[10],char op2[10],char op1[10],char res[10]){
                                        strcpy(QUAD[qCount].operator,op);
                                        strcpy(QUAD[qCount].operand2,op2);
                                        strcpy(QUAD[qCount].operand1,op1);
                                        strcpy(QUAD[qCount].result,res);
                    qCount++;
}