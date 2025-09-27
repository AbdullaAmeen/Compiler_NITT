%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>   

  struct Symbol_Table
  {
     char name[10];
     char type[10];
     double value;
  }Sym[10];

  int sCount=0;
  int qCount=0;
  int temp_var=0;
   
  int search_symbol(char []);
  void enter_to_symb(char [],char [],double);
  void display_sym_tab();  
  void addQuadruple(char [],char [],char [],char []);
  void display_Quadruple();
  void push(char*);
  char* pop();
 
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
%token <string> TYPE
%token <string> ID
%type <string> varlist
%type <string> expr
%token MAIN
%left '+' '-'
%left '*' '/'
%%
start:MAIN '('')''{' body '}'
;
body: vars stmtlist
;

vars: vard vars|
;

vard:TYPE varlist ';'
;

varlist: varlist ',' ID {                int i;
                                         i=search_symbol($3);
                                         if(i!=-1)
                                         printf("\n Multiple Declaration of Variable");
                                         else
                                         enter_to_symb($3,$<string>0,0);
                        }

| ID'='NUMBER            {

                     int i;
                                         i=search_symbol($1);
                                         if(i!=-1)
                                         printf("\n Multiple Declaration of Variable");
                                         else
                                         enter_to_symb($1,$<string>0,$3);
                                         }

|varlist ',' ID '=' NUMBER {

                                         int i;
                                         i=search_symbol($3);
                                         if(i!=-1)
                                         printf("\n Multiple Declaration of Variable");
                                         else
                                         enter_to_symb($3,$<string>0,$5);
                                         }

|ID                     {                int i=search_symbol($1);
                                         if(i!=-1)
                                         printf("\n Multiple Declaration of Variable");
                                         else
                                         enter_to_symb($1,$<string>0,0);
                         }
;

stmtlist: stmt stmtlist|
;

stmt : ID '=' NUMBER ';' {
                                        int i=search_symbol($1);
                                        if(i==-1)
                                        printf("\n Undefined Variable");
                                        else
                    {
                      char temp[10];
                      if(strcmp(Sym[i].type,"int")==0)
                      sprintf(temp,"%d",(int)$3);
                      else
                                          snprintf(temp,10,"%f",$3);
                                          addQuadruple("=","",temp,$1);
                    }
                   }
| ID '=' ID ';'{


                                        int i,j;
                                        i=search_symbol($1);
                    j=search_symbol($3);
                                        if(i==-1 || j==-1)
                                        printf("\n Undefined Variable");
                                        else
                    addQuadruple("=","",$3,$1);
                                                        
                   

}
| ID '=' expr ';'                 { addQuadruple("=","",pop(),$1); }
                    
;

expr :expr '+' expr             {
                    char str[5],str1[5]="t";
                    sprintf(str, "%d", temp_var);   
                        strcat(str1,str);
                    temp_var++;
                    addQuadruple("+",pop(),pop(),str1);                               
                    push(str1);
                    }
|expr '-' expr                 {
                    char str[5],str1[5]="t";
                            sprintf(str, "%d", temp_var);   
                        strcat(str1,str);
                    temp_var++;
                                addQuadruple("-",pop(),pop(),str1);
                                           push(str1);

                }  

|expr '*' expr {
        char str[5],str1[5]="t";
                sprintf(str, "%d", temp_var);       

            strcat(str1,str);
        temp_var++;
        addQuadruple("*",pop(),pop(),str1);
                                push(str1);

                }      
|expr '/' expr {
        char str[5],str1[5]="t";
                sprintf(str, "%d", temp_var);       

            strcat(str1,str);
        temp_var++;
        addQuadruple("/",pop(),pop(),str1);
             push(str1);

                }    
   
|ID {                     int i;
                                        i=search_symbol($1);
                                        if(i==-1)
                                        printf("\n Undefined Variable");
                    else
                    push($1);
                   
    }

|NUMBER {       char temp[10];
                snprintf(temp,10,"%f",$1);   
        push(temp);
                   
}
;
%%
extern FILE *yyin;
int main()
{
   
  Stk.top = -1;
  yyin = fopen("input.txt","r");
  yyparse();
  display_sym_tab();
  printf("\n\n");
display_Quadruple();
 printf("\n\n");
  return(0);
}

int search_symbol(char sym[10])
{
  int i,flag=0;
  for(i=0;i<sCount;i++)
  {
    if(strcmp(Sym[i].name,sym)==0)
    {
      flag=1;
      break;
    }
  }
  if(flag==0)
    return(-1);
  else
    return(i);
}

void enter_to_symb(char sym[10],char dtype[10],double val)
{
  strcpy(Sym[sCount].name,sym);
  strcpy(Sym[sCount].type,dtype);
  Sym[sCount].value=val;
  sCount++;
}


void display_sym_tab()
{
  int i;
  printf("\n\n The Symbol Table  \n\n");
  printf(" | Name \t|Type \t|Value |");
  for(i=0;i<sCount;i++)
    printf("\n | %s \t|%s \t|%f |",Sym[i].name,Sym[i].type,Sym[i].value);
}
void display_Quadruple()
{
  int i;
  printf("\n\n The INTERMEDIATE CODE Is : \n\n");
  printf("\n\n The Quadruple Table \n\n");
  printf("\n | Result \t|Operator \t|Operand1 \t|Operand2 |");
  for(i=0;i<qCount;i++)
    printf("\n %d \t|%s \t|%s \t|%s \t|%s |",i,QUAD[i].result,QUAD[i].operator,QUAD[i].operand1,QUAD[i].operand2);
}
int yyerror()
{
   printf("\nERROR!!\n");
   return(1);
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