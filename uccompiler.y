%{
     /*
      * Hugo Batista Cidra Duarte - 2020219765
      * Nuno Carvalho do Nascimento - 2020219249
     */

    #include "AbsTree.h"
    #include <stdlib.h>

    struct node* program;
    struct node* temp;
    int yylex(void);
    void yyerror(char*);
%}

%type <node> Program
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
%type <node> Statement
%type <node> Expr

%type <node> ParameterDeclarationRECUR
%type <node> DeclarationRECUR
%type <node> StatementRECUR
%type <node> ExprRECUR

%type <node> ExprCOMMA

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
Program : FunctionDefinition                                                            { $$ = program = newnode(Program, NULL);        if($1->category == Aux) {adoptChildren($$, $1);} else{ addchild($$, $1);}}
        | FunctionDeclaration                                                           { $$ = program = newnode(Program, NULL);        if($1->category == Aux) {adoptChildren($$, $1);} else{ addchild($$, $1);};}
        | Declaration                                                                   { $$ = program = newnode(Program, NULL);        if($1->category == Aux) {adoptChildren($$, $1);} else{ addchild($$, $1);}}
        | Program FunctionDefinition                                                    { $$ = $1;                                      addchild($$, $2);}
        | Program FunctionDeclaration                                                   { $$ = $1;                                      addchild($$, $2);}
        | Program Declaration                                                           { $$ = $1;                                      adoptChildren($$, $2);}
        ;

FunctionDefinition : TypeSpec FunctionDeclarator FunctionBody                           { $$ = newnode(FuncDefinition, NULL);           addchild($$, $1); adoptChildren($$, $2); addchild($$, $3);}
                   ;

FunctionBody : LBRACE DeclarationsAndStatements RBRACE                                  { $$ = newnode(FuncBody, NULL);                 adoptChildren($$, $2);}
             | LBRACE RBRACE                                                            { $$ = newnode(FuncBody, NULL);}
             ;

DeclarationsAndStatements : Statement                                                   { $$ = newnode(Aux, NULL);                      addchild($$, $1);}
                          | Declaration                                                 { $$ = $1;}
                          | Statement DeclarationsAndStatements                         { $$ = newnode(Aux, NULL);                      addchild($$, $1); if($2->category == Aux) {adoptChildren($$, $2);} else {addchild($$, $2);}}
                          | Declaration DeclarationsAndStatements                       { $$ = newnode(Aux, NULL);                      adoptChildren($$, $1); adoptChildren($$, $2);}
                          ;

FunctionDeclaration : TypeSpec FunctionDeclarator SEMI                                  { $$ = newnode(FuncDeclaration, NULL);          addchild($$, $1); adoptChildren($$, $2);}
                    ;

FunctionDeclarator : IDENTIFIER LPAR ParameterList RPAR                                 { $$ = newnode(Aux, NULL);                      addchild($$, newnode(Identifier, $1)); addchild($$, $3);}
                   ;

ParameterList : ParameterDeclaration                                                    { $$ = newnode(ParamList, NULL);                addchild($$, $1);}
              | ParameterDeclaration ParameterDeclarationRECUR                          { $$ = newnode(ParamList, NULL);                addchild($$, $1); adoptChildren($$, $2);}
              ;

ParameterDeclarationRECUR : COMMA ParameterDeclaration                                  { $$ = newnode(Aux, NULL);                      addchild($$, $2);}
                          | ParameterDeclarationRECUR COMMA ParameterDeclaration        { $$ = $1;                                      addchild($$, $3);}
                          ;

ParameterDeclaration : TypeSpec                                                         { $$ = newnode(ParamDeclaration, NULL);         addchild($$, $1);}
                     | TypeSpec IDENTIFIER                                              { $$ = newnode(ParamDeclaration, NULL);         addchild($$, $1); addchild($$, newnode(Identifier, $2));}
                     ;

Declaration : error SEMI                                                                { $$ = newnode(Null, NULL);}
            | TypeSpec DeclarationRECUR SEMI                                            { $$ = $2;}
            ;

DeclarationRECUR : Declarator                                                           { $$ = newnode(Aux, NULL);                      addchild($$, $1);}
                 | DeclarationRECUR COMMA Declarator                                    { $$ = $1;                                      addchild($$, $3);}
                 ;

TypeSpec : CHAR                                                                         { $$ = temp = newnode(Char, NULL);}
         | INT                                                                          { $$ = temp = newnode(Int, NULL);}
         | VOID                                                                         { $$ = temp = newnode(Void, NULL);}
         | SHORT                                                                        { $$ = temp = newnode(Short, NULL);}
         | DOUBLE                                                                       { $$ = temp = newnode(Double, NULL);}
         ;

Declarator : IDENTIFIER                                                                 { $$ = newnode(Declaration, NULL);              addchild($$, newnode(temp->category, NULL)); addchild($$, newnode(Identifier, $1));}
           | IDENTIFIER ASSIGN Expr                                                     { $$ = newnode(Declaration, NULL);              addchild($$, newnode(temp->category, NULL)); addchild($$, newnode(Identifier, $1)); addchild($$, $3);}
           ;

Statement : SEMI                                                                        { $$ = NULL;}
          | ExprCOMMA SEMI                                                              { $$ = $1;}
          | LBRACE RBRACE                                                               { $$ = NULL;}
          | LBRACE StatementRECUR RBRACE                                                { if(!$2) { $$ = NULL;} else if($2->category == Aux) {$$ = newnode(StatList, NULL); adoptChildren($$, $2);} else {$$ = $2;}}
          | IF LPAR ExprCOMMA RPAR Statement         %prec LOWER                        { $$ = newnode(If, NULL);                       addchild($$, $3); if($5 == NULL) {addchild($$, newnode(Null, NULL));} else {addchild($$,$5);}; addchild($$, newnode(Null, NULL));}
          | IF LPAR ExprCOMMA RPAR Statement ELSE Statement                             { $$ = newnode(If, NULL);                       addchild($$, $3); if($5 == NULL) {addchild($$, newnode(Null, NULL));} else {addchild($$,$5);}; if($7 == NULL) {addchild($$, newnode(Null, NULL));} else {addchild($$,$7);}}
          | WHILE LPAR ExprCOMMA RPAR Statement                                         { $$ = newnode(While, NULL);                    addchild($$, $3); if($5 == NULL) {addchild($$, newnode(Null, NULL));} else {addchild($$,$5);};}
          | RETURN SEMI                                                                 { $$ = newnode(Return, NULL);                   addchild($$, newnode(Null, NULL));}
          | RETURN ExprCOMMA SEMI                                                       { $$ = newnode(Return, NULL);                   addchild($$, $2);}
          ;

StatementRECUR : error SEMI                                                             { $$ = newnode(Null, NULL);}
               | error                                                                  { $$ = newnode(Null, NULL);}
               | Statement                                                              { $$ = $1;}
               | Statement StatementRECUR                                               { $$ = newnode(Aux, NULL);                     addchild($$, $1); if($2->category == Aux) {adoptChildren($$, $2);} else addchild($$, $2);}
               ;

Expr : Expr ASSIGN Expr                                                                 { $$ = newnode(Store, NULL);                    addchild($$, $1); addchild($$, $3);}
     | Expr PLUS Expr                                                                   { $$ = newnode(Add, NULL);                      addchild($$, $1); addchild($$, $3);}
     | Expr MINUS Expr                                                                  { $$ = newnode(Sub, NULL);                      addchild($$, $1); addchild($$, $3);}
     | Expr MUL Expr                                                                    { $$ = newnode(Mul, NULL);                      addchild($$, $1); addchild($$, $3);}
     | Expr DIV Expr                                                                    { $$ = newnode(Div, NULL);                      addchild($$, $1); addchild($$, $3);}
     | Expr MOD Expr                                                                    { $$ = newnode(Mod, NULL);                      addchild($$, $1); addchild($$, $3);}
     | Expr OR Expr                                                                     { $$ = newnode(Or, NULL);                       addchild($$, $1); addchild($$, $3);}
     | Expr AND Expr                                                                    { $$ = newnode(And, NULL);                      addchild($$, $1); addchild($$, $3);}
     | Expr BITWISEAND Expr                                                             { $$ = newnode(BitWiseAnd, NULL);               addchild($$, $1); addchild($$, $3);}
     | Expr BITWISEOR Expr                                                              { $$ = newnode(BitWiseOr, NULL);                addchild($$, $1); addchild($$, $3);}
     | Expr BITWISEXOR Expr                                                             { $$ = newnode(BitWiseXor, NULL);               addchild($$, $1); addchild($$, $3);}
     | Expr EQ Expr                                                                     { $$ = newnode(Eq, NULL);                       addchild($$, $1); addchild($$, $3);}
     | Expr NE Expr                                                                     { $$ = newnode(Ne, NULL);                       addchild($$, $1); addchild($$, $3);}
     | Expr LE Expr                                                                     { $$ = newnode(Le, NULL);                       addchild($$, $1); addchild($$, $3);}
     | Expr GE Expr                                                                     { $$ = newnode(Ge, NULL);                       addchild($$, $1); addchild($$, $3);}
     | Expr LT Expr                                                                     { $$ = newnode(Lt, NULL);                       addchild($$, $1); addchild($$, $3);}
     | Expr GT Expr                                                                     { $$ = newnode(Gt, NULL);                       addchild($$, $1); addchild($$, $3);}
     | PLUS Expr %prec NOT                                                              { $$ = newnode(Plus, NULL);                     addchild($$, $2);}
     | MINUS Expr %prec NOT                                                             { $$ = newnode(Minus, NULL);                    addchild($$, $2);}
     | NOT Expr                                                                         { $$ = newnode(Not, NULL);                      addchild($$, $2);}
     | IDENTIFIER LPAR RPAR                                                             { $$ = newnode(Call, NULL);                     addchild($$, newnode(Identifier, $1));}
     | IDENTIFIER LPAR ExprRECUR RPAR                                                   { $$ = newnode(Call, NULL);                     addchild($$, newnode(Identifier, $1)); adoptChildren($$, $3);}
     | IDENTIFIER                                                                       { $$ = newnode(Identifier, $1);}
     | NATURAL                                                                          { $$ = newnode(Natural, $1);}
     | CHRLIT                                                                           { $$ = newnode(ChrLit, $1);}
     | DECIMAL                                                                          { $$ = newnode(Decimal, $1);}
     | LPAR ExprCOMMA RPAR                                                              { $$ = $2;}
     ;

ExprRECUR : error                                                                       { $$ = newnode(Null, NULL);}
          | Expr %prec LOWER                                                            { $$ = newnode(Aux, NULL);                      addchild($$, $1);}
          | ExprRECUR COMMA Expr %prec HIGHER                                           { $$ = $1;                                      addchild($$, $3);}
          ;

ExprCOMMA : Expr                                                                        {$$ = $1;}
          | ExprCOMMA COMMA Expr                                                        {$$ = newnode(Comma, NULL);                     addchild($$, $1); addchild($$, $3);}

%%