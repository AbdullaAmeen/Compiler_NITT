%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int flag = 0;
    int yylex();
    int yyerror(const char *s);

    FILE *fp;

    int var_no = 0, label_no = 0;

    char* generate_var() {
        char *var = (char*)malloc(sizeof(char) * 32);
        sprintf(var, "var%d", var_no++);
        return var;
    }

    char* generate_label() {
        char *label = (char*)malloc(sizeof(char) * 32);
        sprintf(label, "label%d", label_no++);
        return label;
    }

    struct Node {
        char* val;
        char* var_name;
        struct Node *left;
        struct Node* right;
    };

    struct Node* newNode(char* val, struct Node* left, struct Node* right){
        struct Node* node = (struct Node*)malloc(sizeof(struct Node));
        node->val = strdup(val);
        node->left = left;
        node->right = right;
        if(left != NULL || right != NULL) {
            if(strcmp(val, "=") != 0)
                node->var_name = strdup(generate_var());
        } else {
            node->var_name = strdup(val);
        }
        return node;
    }
    char* nxt, *nxt1, *nxt2;

    struct Node* root;
    void inorder(struct Node* root);
    void postorder(struct Node* root);
    void generate_icg(struct Node* root);
%}

%left   ','
%left   '='
%left   OR
%left   AND
%left   EE NE
%left   '<' '>' GE LE
%left   '+' '-'
%left   '*' '/' '%'
%left   '!'
%left   UP UM
%left   '(' ')'
%nonassoc IF
%nonassoc ELSE

%union 
{
    int num;
    char ch;
    char* str;
    struct Node *node;
}

%token  <str>   NUMBER
%token  <str>   IDENTIFIER
%token  <str>   DATATYPE
%token          WHILE

%type    <node> LogicalAndAritmeticExpression
%type    <node> Term
%type    <node> Assignments
%type    <node> ExpressionLoop
%type    <node> DatatypeAssignments
%type    <node> Expression
%type    <node> Expressions
%type    <node> Statement
%start          Statement

%%
IfStmt
: If '(' Expression ')' Then Statement Done  %prec IF { printf("if\n"); }
| If '(' Expression ')' Then Statement Done Else Statement { printf("If else statement\n");}
;

If
:IF { fprintf(fp, "if "); }
;

Else
:ELSE 
;

Done
: {fprintf(fp, "%s:\n", nxt);}

Then
: {char* st = generate_label(); nxt = generate_label(); fprintf(fp, "goto %s\njmp %s\n%s:\n", st, nxt, st);}

WhileLoop
: While '(' Expression ')' Then1 Statement Done1 {}
;

While
: WHILE {nxt1 = generate_label(); nxt = generate_label(); fprintf(fp, "%s: if not ", nxt1);}
;

Then1
: {fprintf(fp, "goto %s\n", nxt, nxt1);}
;

Done1
: {fprintf(fp, "goto %s\n%s:\n",nxt1, nxt);}
;

Statement
: '{' StatementList '}' { $$ = NULL; }
| '{' '}' { $$ = NULL; }
| Expressions {$$ = NULL;}
| IfStmt {$$ = NULL;}
| WhileLoop {$$ = NULL;}
;

Expressions
: ';' {$$ = NULL;}
| Expression ';' {$$ = $1;}
;

StatementList
: StatementList Statement
| Statement
;

Expression  
: DatatypeAssignments { root = $1; generate_icg(root); var_no = 0; }
| Expression ',' DatatypeAssignments { root = $3; generate_icg(root); var_no = 0; }
;

DatatypeAssignments
: DATATYPE Assignments {$$ = $2;}
| Assignments {$$ = $1;}
;

Assignments
: ExpressionLoop {$$ = $1;}
| IDENTIFIER '=' Assignments {$$ = newNode("=", newNode($1, NULL, NULL), $3);}
;

ExpressionLoop
: LogicalAndAritmeticExpression {$$ = $1;}
| LogicalAndAritmeticExpression '?' ExpressionLoop ':' ExpressionLoop
;

LogicalAndAritmeticExpression
: Term AND Term {$$ = newNode("&&", $1, $3);}
| Term OR Term  {$$ = newNode("||", $1, $3);}
| Term EE Term  {$$ = newNode("==", $1, $3);}
| Term NE Term  {$$ = newNode("!=", $1, $3);}
| Term LE Term  {$$ = newNode("<=", $1, $3);}
| Term GE Term  {$$ = newNode(">=", $1, $3);}
| Term '<' Term {$$ = newNode("<", $1, $3);}
| Term '>' Term {$$ = newNode(">", $1, $3);}
| Term '|' Term {$$ = newNode("|", $1, $3);}
| Term '&' Term {$$ = newNode("&", $1, $3);}
| Term '^' Term {$$ = newNode("^", $1, $3);}
| Term '+' Term {$$ = newNode("+", $1, $3);}
| Term '-' Term {$$ = newNode("-", $1, $3);}
| Term '*' Term {$$ = newNode("*", $1, $3);}
| Term '/' Term {$$ = newNode("/", $1, $3);}
| Term '%' Term {$$ = newNode("%", $1, $3);}
| '!' Term {$$ = newNode("!", NULL, $2);}
|  UP Term {$$ = newNode("++", NULL, $2);}
|  UM Term {$$ = newNode("--", NULL, $2);}
|  Term UP {$$ = newNode("++", $1, NULL);}
|  Term UM {$$ = newNode("--", $1, NULL);}
|  Term {$$ = $1;}
;

Term
: NUMBER {$$ = newNode($1, NULL, NULL);}
| IDENTIFIER {$$ = newNode($1, NULL, NULL);}
| '-' NUMBER {$$ = newNode("-", NULL,  newNode($2, NULL, NULL));}
| '-' IDENTIFIER {$$ = newNode("-", NULL,  newNode($2, NULL, NULL));}
| '(' Expression ')' {$$ = $2;}
;
%%

void postorder(struct Node* root){
    if(root == NULL) return;
    postorder(root->left);
    postorder(root->right);
    printf("%s ", root->val);
}

void inorder(struct Node* root){
    if(root == NULL) return;
    inorder(root->left);
    printf("%s ", root->val);
    inorder(root->right);
}

void generate_icg(struct Node* root) {
    if(root == NULL || (root->left == NULL && root->right == NULL)) return;
    generate_icg(root->left);
    generate_icg(root->right);
    if(strcmp(root->val, "=") != 0)
        fprintf(fp, "%s = ", root->var_name);
    if(root->left != NULL) {
        fprintf(fp, "%s", root->left->var_name);
    }
    fprintf(fp, " %s ", root->val);
    if(root->right != NULL) {
        fprintf(fp, "%s\n", root->right->var_name);
    }
}

int main()
{
    printf("\nEnter an If statement:\n\n");
    fp = fopen("icg.txt", "w");
    yyparse();
    if (flag == 0)
    {
        printf("\nEntered expression is Valid\n\n");
    }
    return 0;
}

int yyerror(const char *s)
{
    printf("\nError: %s\n\n", s);
    flag = 1;
    exit(1);
    return 0;
}
