%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>   



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
  }QUAD[25];

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