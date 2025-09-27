%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int flag = 0;
    int yylex();
    int yyerror(const char *s);

    struct Node {
        char* val;
        struct Node *left;
        struct Node* right;
    };

    struct Node* newNode(char* val, struct Node* left, struct Node* right){
        struct Node* node = (struct Node*)malloc(sizeof(struct Node));
        node->val = strdup(val);
        node->left = left;
        node->right = right;
        return node;
    }

    struct Node* root;
    void inorder(struct Node* root);
    void postorder(struct Node* root);

%}

%left   '='
%left   OR
%left   AND
%left   EE NE
%left   '<' '>' GE LE
%left   '+' '-'
%left   '*' '/' '%'
%left   '!'
%left   '(' ')'

%union 
{
    int num;
    char ch;
    char str[32];
    struct Node* node;
}

%token  <str>   NUMBER
%token  <str>   IDENTIFIER
%token  <str>   DATATYPE
%type   <node>    Term
%type   <node>         Expressions
%type   <node>         Expression
%start           Expressions

%%
Expressions
: Expression {root = $1; inorder(root); printf(" postorder "); postorder(root); printf("\n"); }
| Expressions Expression {root = $2; inorder(root); printf(" postorder "); postorder(root); printf("\n");}
;

Expression  
: IDENTIFIER '=' Term ';' {$$ = newNode("=", newNode($1, NULL, NULL), $3);}
| DATATYPE IDENTIFIER '=' Term ';'{$$ = newNode("=", newNode($2, NULL, NULL), $4);}
| Term ';'                
;

Term 
: Term '+' Term     {$$ = newNode("+", $1, $3);}
| Term '-' Term     {$$ = newNode("-", $1, $3);}
| Term '*' Term     {$$ = newNode("*", $1, $3);}
| Term '/' Term     {$$ = newNode("/", $1, $3);}
| Term '%' Term     {$$ = newNode("%", $1, $3);}
| Term AND Term     {$$ = newNode("&&", $1, $3);}
| Term OR Term      {$$ = newNode("||", $1, $3);}
| Term '<' Term     {$$ = newNode("<", $1, $3);}
| Term '>' Term     {$$ = newNode(">", $1, $3);}
| Term LE Term      {$$ = newNode("<=", $1, $3);}
| Term GE Term      {$$ = newNode(">=", $1, $3);}
| Term EE Term      {$$ = newNode("==", $1, $3);}
| Term NE Term      {$$ = newNode("!=", $1, $3);}
| '(' Term ')'      {$$ = newNode("()", $2, NULL);}
| '!' Term          {$$ = newNode("!", $2, NULL);}
| NUMBER            {$$ = newNode($1, NULL, NULL);}
| IDENTIFIER        {$$ = newNode($1, NULL, NULL);}
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

int main()
{
    printf("\nEnter an expression with any of the binary operators:\n\n");
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