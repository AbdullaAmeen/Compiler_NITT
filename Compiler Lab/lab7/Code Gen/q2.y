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
  struct Quadr
{
    string op;
    string arg1;
    string arg2;
    string result;
};

vector<Quadr> quad_table;

void generate_code()
{
    for(int i=0; i<qCount; i++){
      Quadr q;
      q.op = QUAD[i].op;
      string a1(QUAD[i].arg1),a2(QUAD[i].arg2),a3(QUAD[i].result);
      if(a2 == "" && a1 !=""){
        a2 = a1;
        a1 = "";
      }
      if(a2 == "" || a1 == ""){
        q.op = "=";
      }
      
      q.arg1 = a1;
      q.arg2 = a2;
    
      q.result = a3;
      quad_table.push_back(q);
    }
    ofstream txt_file("output2.txt");
    int reg_count = 0;        // count of available registers
    map<string, int> reg_map; // map of variable names to registers
    for (int i = 0; i < quad_table.size(); i++)
    {
        Quadr q = quad_table[i];
        txt_file << "| " << q.op << " " << q.arg1 << " " << q.arg2 << " " << q.result << " |" << endl;
        if (q.op == "=")
        {
            if (reg_map.count(q.result) != 0)
            {
                txt_file << "MOV R" << reg_map[q.result] << ", " << q.arg1 << endl;
            }
            else
            {
                reg_map[q.result] = ++reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg1 << endl;
            }
        }
        else if (q.op == "+")
        {
            int r1, r2, r3;
            if (reg_map.count(q.arg1) != 0 && reg_map.count(q.arg2) != 0)
            {
                r1 = reg_map[q.arg1];
                r2 = reg_map[q.arg2];
            }
            if (reg_map.count(q.arg1) == 0)
            {
                reg_map[q.arg1] = ++reg_count;
                r1 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg1 << endl;
            }
            if (reg_map.count(q.arg2) == 0)
            {
                reg_map[q.arg2] = ++reg_count;
                r2 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg2 << endl;
            }
            if (reg_map.count(q.result) == 0)
            {
                reg_map[q.result] = ++reg_count;
                r3 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.result << endl;
            }
            else
            {
                r3 = reg_map[q.result];
            }
            txt_file << "ADD R" << r3 << ", R" << r2 << ", R" << r1 << endl;
        }
        else if (q.op == "-")
        {
            int r1, r2, r3;
            if (reg_map.count(q.arg1) != 0 && reg_map.count(q.arg2) != 0)
            {
                r1 = reg_map[q.arg1];
                r2 = reg_map[q.arg2];
            }
            if (reg_map.count(q.arg1) == 0)
            {
                reg_map[q.arg1] = ++reg_count;
                r1 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg1 << endl;
            }
            if (reg_map.count(q.arg2) == 0)
            {
                reg_map[q.arg2] = ++reg_count;
                r2 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg2 << endl;
            }
            if (reg_map.count(q.result) == 0)
            {
                reg_map[q.result] = ++reg_count;
                r3 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.result << endl;
            }
            else
            {
                r3 = reg_map[q.result];
            }
            txt_file << "SUB R" << r3 << ", R" << r2 << ", R" << r1 << endl;
        }
        else if (q.op == "*")
        {
            int r1, r2, r3;
            if (reg_map.count(q.arg1) != 0 && reg_map.count(q.arg2) != 0)
            {
                r1 = reg_map[q.arg1];
                r2 = reg_map[q.arg2];
            }
            if (reg_map.count(q.arg1) == 0)
            {
                reg_map[q.arg1] = ++reg_count;
                r1 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg1 << endl;
            }
            if (reg_map.count(q.arg2) == 0)
            {
                reg_map[q.arg2] = ++reg_count;
                r2 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg2 << endl;
            }
            if (reg_map.count(q.result) == 0)
            {
                reg_map[q.result] = ++reg_count;
                r3 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.result << endl;
            }
            else
            {
                r3 = reg_map[q.result];
            }
            txt_file << "MUL R" << r3 << ", R" << r2 << ", R" << r1 << endl;
        }
        else if (q.op == "/")
        {
            int r1, r2, r3;
            if (reg_map.count(q.arg1) != 0 && reg_map.count(q.arg2) != 0)
            {
                r1 = reg_map[q.arg1];
                r2 = reg_map[q.arg2];
            }
            if (reg_map.count(q.arg1) == 0)
            {
                reg_map[q.arg1] = ++reg_count;
                r1 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg1 << endl;
            }
            if (reg_map.count(q.arg2) == 0)
            {
                reg_map[q.arg2] = ++reg_count;
                r2 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.arg2 << endl;
            }
            if (reg_map.count(q.result) == 0)
            {
                reg_map[q.result] = ++reg_count;
                r3 = reg_count;
                txt_file << "MOV R" << reg_count << ", " << q.result << endl;
            }
            else
            {
                r3 = reg_map[q.result];
            }
            txt_file << "DIV R" << r3 << ", R" << r2 << ", R" << r1 << endl;
        }
        else if (q.op == "<")
        {
            int r1, r2, r3;
            int f1, f2;
            if (q.arg1 >= "0" && q.arg1 <= "9")
            {
                r1 = stoi(q.arg1);
                f1 = 0;
            }
            else
            {
                if (reg_map.count(q.arg1) != 0)
                {
                    r1 = reg_map[q.arg1];
                }
                else
                {
                    reg_map[q.arg1] = ++reg_count;
                    r1 = reg_count;
                    txt_file << "MOV R" << reg_count << ", " << q.arg1 << endl;
                }
                f1 = 1;
            }
            if (q.arg2 >= "0" && q.arg2 <= "9")
            {
                r2 = stoi(q.arg2);
                f2 = 0;
            }
            else
            {
                if (reg_map.count(q.arg2) != 0)
                {
                    r2 = reg_map[q.arg2];
                }
                else
                {
                    reg_map[q.arg2] = ++reg_count;
                    r2 = reg_count;
                    txt_file << "MOV R" << reg_count << ", " << q.arg2 << endl;
                }
                f2 = 1;
            }

            if (f1 == 0 && f2 == 0)
            {
                txt_file << "CMP #" << r1 << ", #" << r2 << endl;
                txt_file << "JL " << q.result << endl;
            }
            else if (f1 == 0 && f2 == 1)
            {
                txt_file << "CMP #" << r1 << ", R" << r2 << endl;
                txt_file << "JL " << q.result << endl;
            }
            else if (f1 == 1 && f2 == 0)
            {
                txt_file << "CMP R" << r1 << ", #" << r2 << endl;
                txt_file << "JL " << q.result << endl;
            }
            else
            {
                txt_file << "CMP R" << r1 << ", R" << r2 << endl;
                txt_file << "JL " << q.result << endl;
            }
        }
        else if (q.op == ">")
        {
            int r1, r2, r3;
            int f1, f2;
            if (q.arg1 >= "0" && q.arg1 <= "9")
            {
                r1 = stoi(q.arg1);
                f1 = 0;
            }
            else
            {
                if (reg_map.count(q.arg1) != 0)
                {
                    r1 = reg_map[q.arg1];
                }
                else
                {
                    reg_map[q.arg1] = ++reg_count;
                    r1 = reg_count;
                    txt_file << "MOV R" << reg_count << ", " << q.arg1 << endl;
                }
                f1 = 1;
            }
            if (q.arg2 >= "0" && q.arg2 <= "9")
            {
                r2 = stoi(q.arg2);
                f2 = 0;
            }
            else
            {
                if (reg_map.count(q.arg2) != 0)
                {
                    r2 = reg_map[q.arg2];
                }
                else
                {
                    reg_map[q.arg2] = ++reg_count;
                    r2 = reg_count;
                    txt_file << "MOV R" << reg_count << ", " << q.arg2 << endl;
                }
                f2 = 1;
            }

            if (f1 == 0 && f2 == 0)
            {
                txt_file << "CMP #" << r1 << ", #" << r2 << endl;
                txt_file << "JG " << q.result << endl;
            }
            else if (f1 == 0 && f2 == 1)
            {
                txt_file << "CMP #" << r1 << ", R" << r2 << endl;
                txt_file << "JG " << q.result << endl;
            }
            else if (f1 == 1 && f2 == 0)
            {
                txt_file << "CMP R" << r1 << ", #" << r2 << endl;
                txt_file << "JG " << q.result << endl;
            }
            else
            {
                txt_file << "CMP R" << r1 << ", R" << r2 << endl;
                txt_file << "JG " << q.result << endl;
            }
        }
        else if (q.op == "==")
        {
            int r1, r2, r3;
            int f1, f2;
            if (q.arg1 >= "0" && q.arg1 <= "9")
            {
                r1 = stoi(q.arg1);
                f1 = 0;
            }
            else
            {
                if (reg_map.count(q.arg1) != 0)
                {
                    r1 = reg_map[q.arg1];
                }
                else
                {
                    reg_map[q.arg1] = ++reg_count;
                    r1 = reg_count;
                    txt_file << "MOV R" << reg_count << ", " << q.arg1 << endl;
                }
                f1 = 1;
            }
            if (q.arg2 >= "0" && q.arg2 <= "9")
            {
                r2 = stoi(q.arg2);
                f2 = 0;
            }
            else
            {
                if (reg_map.count(q.arg2) != 0)
                {
                    r2 = reg_map[q.arg2];
                }
                else
                {
                    reg_map[q.arg2] = ++reg_count;
                    r2 = reg_count;
                    txt_file << "MOV R" << reg_count << ", " << q.arg2 << endl;
                }
                f2 = 1;
            }

            if (f1 == 0 && f2 == 0)
            {
                txt_file << "CMP #" << r1 << ", #" << r2 << endl;
                txt_file << "JE " << q.result << endl;
            }
            else if (f1 == 0 && f2 == 1)
            {
                txt_file << "CMP #" << r1 << ", R" << r2 << endl;
                txt_file << "JE " << q.result << endl;
            }
            else if (f1 == 1 && f2 == 0)
            {
                txt_file << "CMP R" << r1 << ", #" << r2 << endl;
                txt_file << "JE " << q.result << endl;
            }
            else
            {
                txt_file << "CMP R" << r1 << ", R" << r2 << endl;
                txt_file << "JE " << q.result << endl;
            }
        }
        else if (q.op == "goto")
        {
            txt_file << "JMP " << q.result << endl;
        }
        else if (q.op == "label")
        {
            txt_file << q.result << ":" << endl;
        }

        txt_file << endl;
    }
    txt_file.close();
}

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
void elCSandDeadcode() {
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
  elCSandDeadcode();
  display_Code();
  printf("\n\n");
  generate_code();
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