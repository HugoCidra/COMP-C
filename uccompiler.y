%{
    #include "AbsTree.h"
    #include <stdio.h>
    struct node* program;
    int yylex(void);
    void yyerror(char*);
%}

%type <node> Program
/*
%type <node> FunctionsAndDeclarations
%type <node> FunctionDefinition
%type <node> FunctionBody
%type <node> DeclarationsAndStatements
%type <node> FunctionDeclaration
%type <node> FunctionDeclarator
%type <node> ParameterList
%type <node> ParameterDeclaration
%type <node> Declaration
%type <node> TypeSpec
%type <node> Declarator
*/
%type <node> Statement
%type <node> Expr

/*
%type <node> ParameterDeclarationRECUR
%type <node> DeclarationRECUR
%type <node> DeclaratorRECUR
*/
%type <node> ExprRECUR

%token BITWISEAND
%token BITWISEOR
%token BITWISEXOR
%token AND
%token ASSIGN
%token MUL
%token DIV
%token EQ
%token GE
%token GT
%token LBRACE
%token LE
%token LPAR
%token LT
%token MINUS
%token MOD
%token NE
%token NOT
%token OR
%token PLUS
%token RBRACE
%token RPAR
%token SEMI

%token <info> NATURAL
%token <info> DECIMAL
%token <info> IDENTIFIER
%token <info> CHRLIT

%token INT
%token CHAR
%token VOID
%token RESERVED
%token SHORT
%token DOUBLE
%token IF
%token ELSE
%token WHILE
%token RETURN

%left   COMMA
%right  ASSIGN
%left   OR
%left   AND
%left   BITWISEOR
%left   BITWISEXOR
%left   BITWISEAND
%left   EQ NE
%left   LE LT GE GT
%left   PLUS MINUS
%left   MUL DIV MOD
%right  NOT
%left   LPAR
%left   RPAR

%nonassoc LOWER
%nonassoc ELSE
%nonassoc HIGHER

%union {
     char* info;
     struct node* node;
}

%%
Program : Statement               {$$ = program = newnode(Program, NULL);
                                   addchild($$, $1);} 
        | Program  Statement      {$$ = $1;
                                   addchild($$, $2);}                        
     ;

Statement : SEMI {$$ = NULL;}
          | Expr SEMI {$$ = $1;}
          | LBRACE RBRACE {$$ = NULL;}
          | LBRACE Statement RBRACE {$$ = ;}
          | IF LPAR Expr RPAR Statement {;}
          | IF LPAR Expr RPAR Statement ELSE Statement {;}
          | WHILE LPAR Expr RPAR Statement {;}
          | RETURN SEMI {$$ = newnode(Return, NULL);
                         addchild($$, newnode(Null, NULL));}
          | RETURN Expr SEMI {$$ = newnode(Return, NULL);
                              addchild($$, $2);}
          ;

Expr : Expr ASSIGN Expr { $$ = newnode(Store, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr COMMA Expr {  $$ = newnode(Comma, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr PLUS Expr {$$ = newnode(Add, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr MINUS Expr {$$ = newnode(Sub, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr MUL Expr {$$ = newnode(Mul, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr DIV Expr {$$ = newnode(Div, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr MOD Expr {$$ = newnode(Mod, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr OR Expr {$$ = newnode(Or, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr AND Expr {$$ = newnode(And, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr BITWISEAND Expr {$$ = newnode(BitWiseAnd, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr BITWISEOR Expr {$$ = newnode(BitWiseOr, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr BITWISEXOR Expr {$$ = newnode(BitWiseXor, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr EQ Expr {$$ = newnode(Eq, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr NE Expr {$$ = newnode(Ne, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr LE Expr {$$ = newnode(Le, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr GE Expr {$$ = newnode(Ge, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr LT Expr {$$ = newnode(Lt, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | Expr GT Expr {$$ = newnode(Gt, NULL);
                              addchild($$, $1);
                              addchild($$, $3);}
     | PLUS Expr {$$ = newnode(Plus, NULL);
                              addchild($$, $2);}

     | MINUS Expr {$$ = newnode(Minus, NULL);
                              addchild($$, $2);}
     | NOT Expr {$$ = newnode(Not, NULL);
                              addchild($$, $2);}
     | IDENTIFIER LPAR RPAR {$$ = newnode(Call, NULL);
                              addchild($$, newnode(Identifier, $1));}
     | IDENTIFIER LPAR Expr RPAR {$$ = newnode(Call, NULL);
                                   addchild($$, newnode(Identifier, $1));
                                   addchild($$, $3);}
     /*
     | IDENTIFIER LPAR Expr COMMA ExprRECUR RPAR {$$ = newnode(Call, NULL);
                                   addchild($$, newnode(Identifier, $1));
                                   addchild($$, $3);
                                   addchild($$, $5);}
     */
     | IDENTIFIER { $$ = newnode(Identifier, $1);}
     | NATURAL { $$ = newnode(Natural, $1);}
     | CHRLIT { $$ = newnode(ChrLit, $1);}
     | DECIMAL { $$ = newnode(Decimal, $1);}
     | LPAR Expr RPAR { $$ = $2;}
     ;

/*
ExprRECUR : Expr %prec LOWER { $$ = newnode(Aux, NULL);
                    addchild($$, $1);}
          | ExprRECUR COMMA Expr %prec HIGHER { $$ = $1;
                                   addchild($$, $3);}
          ;
*/
%%