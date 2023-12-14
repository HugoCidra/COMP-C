%{
    /*
     * Hugo Batista Cidra Duarte - 2020219765
     * Nuno Carvalho do Nascimento - 2020219249
    */

    #include "y.tab.h"
    #include "AbsTree.h"
    #include "semantics.h"
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>

    extern struct node* program;
    extern struct node* temp;
    int yyparse(void);
    void yyerror(char*);
    #define PASS_TOKEN() yylval.info = strdup (yytext);

    int line = 1; int col = 1;
    int c_line = 1; int c_col = 1;
    int l = 0, t = 1, s = 0;
    int errors = 0;

    char* toUpper(char* temp) {
        for(int i = 0; temp[i]; ++i) {
            temp[i] -= 32;
        }

        return temp;
    }
%}

digit [0-9]
clit_digit [0-7]
letter [a-zA-Z]
v_identifier [a-zA-Z_][a-zA-Z0-9_]*

INT         int
CHAR        char
DOUBLE      double
IF          if
ELSE        else
WHILE       while
SHORT       short
RETURN      return
VOID        void

reserved auto|break|case|const|continue|default|do|enum|extern|float|for|goto|inline|long|register|signed|sizeof|static|struct|switch|typedef|union|unsigned|volatile|_Packed|"--"|"++"|"["|"]"|restrict|_Bool|_Complex|_Imaginary
    
spaces [\r\t ]
newline \r\n|\r|\n
exp [eE]
signal [+-]
escape n|t|\\|\'|\"|{clit_digit}{1,3}
escape_nd n|t|\\|\'|\"

%X LINE_COMMENT
%X BLOCK_COMMENT

%%
{spaces}                    {col += yyleng;}
{newline}                   {line++; col = 1;}

"&"                         { if(l > 0) printf ("BITWISEAND\n"); col += yyleng;         if(t > 0) return BITWISEAND;}
"|"                         { if(l > 0) printf ("BITWISEOR\n"); col += yyleng;          if(t > 0) return BITWISEOR;}
"^"                         { if(l > 0) printf ("BITWISEXOR\n"); col += yyleng;         if(t > 0) return BITWISEXOR;}
"&&"                        { if(l > 0) printf ("AND\n"); col += yyleng;                if(t > 0) return AND;}
"="                         { if(l > 0) printf ("ASSIGN\n"); col += yyleng;             if(t > 0) return ASSIGN;}
"*"                         { if(l > 0) printf ("MUL\n"); col += yyleng;                if(t > 0) return MUL;}
","                         { if(l > 0) printf ("COMMA\n"); col += yyleng;              if(t > 0) return COMMA;}
"/"                         { if(l > 0) printf ("DIV\n"); col += yyleng;                if(t > 0) return DIV;}
"=="                        { if(l > 0) printf ("EQ\n"); col += yyleng;                 if(t > 0) return EQ;}
">="                        { if(l > 0) printf ("GE\n"); col += yyleng;                 if(t > 0) return GE;}
">"                         { if(l > 0) printf ("GT\n"); col += yyleng;                 if(t > 0) return GT;}
"{"                         { if(l > 0) printf ("LBRACE\n"); col += yyleng;             if(t > 0) return LBRACE;}
"<="                        { if(l > 0) printf ("LE\n"); col += yyleng;                 if(t > 0) return LE;}
"("                         { if(l > 0) printf ("LPAR\n"); col += yyleng;               if(t > 0) return LPAR;}
"<"                         { if(l > 0) printf ("LT\n"); col += yyleng;                 if(t > 0) return LT;}
"-"                         { if(l > 0) printf ("MINUS\n"); col += yyleng;              if(t > 0) return MINUS;}
"%"                         { if(l > 0) printf ("MOD\n"); col += yyleng;                if(t > 0) return MOD;}
"!="                        { if(l > 0) printf ("NE\n"); col += yyleng;                 if(t > 0) return NE;}
"!"                         { if(l > 0) printf ("NOT\n"); col += yyleng;                if(t > 0) return NOT;}
"||"                        { if(l > 0) printf ("OR\n"); col += yyleng;                 if(t > 0) return OR;}
"+"                         { if(l > 0) printf ("PLUS\n"); col += yyleng;               if(t > 0) return PLUS;}
"}"                         { if(l > 0) printf ("RBRACE\n"); col += yyleng;             if(t > 0) return RBRACE;}
")"                         { if(l > 0) printf ("RPAR\n"); col += yyleng;               if(t > 0) return RPAR;}
";"                         { if(l > 0) printf ("SEMI\n"); col += yyleng;               if(t > 0) return SEMI;}

{digit}+"."|{digit}*"."{digit}+|({digit}+"."{digit}*|"."{digit}+|{digit}+){exp}{signal}?{digit}+         { if(l > 0) printf("DECIMAL(%s)\n", yytext); col += yyleng; PASS_TOKEN(); if(t > 0) return DECIMAL;}   
{digit}+                    { if(l > 0) printf("NATURAL(%s)\n", yytext); col += yyleng; PASS_TOKEN(); if(t > 0) return NATURAL;}
{reserved}                  { if(l > 0) printf("RESERVED(%s)\n", yytext); col += yyleng;    if(t > 0) return RESERVED;}

{INT}                       { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return INT;}
{CHAR}                      { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return CHAR;}
{DOUBLE}                    { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return DOUBLE;}
{IF}                        { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return IF;}
{ELSE}                      { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return ELSE;}
{WHILE}                     { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return WHILE;}
{SHORT}                     { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return SHORT;}
{RETURN}                    { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return RETURN;}
{VOID}                      { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     if(t > 0) return VOID;}

{v_identifier}              { if(l > 0) printf("IDENTIFIER(%s)\n", yytext); col += yyleng; PASS_TOKEN(); if(t > 0) return IDENTIFIER;}

"//"                        { BEGIN LINE_COMMENT;}
<LINE_COMMENT>.             { col += yyleng;}
<LINE_COMMENT>{newline}     { line++; col = 1; BEGIN 0;}
"/*"                        { BEGIN BLOCK_COMMENT; c_line = line; c_col = col; col += yyleng;}
<BLOCK_COMMENT>{newline}    { col = 1; line++;}
<BLOCK_COMMENT><<EOF>>      { printf("Line %d, column %d: unterminated comment\n", c_line, c_col); BEGIN 0;}
<BLOCK_COMMENT>"*/"         { col += yyleng; BEGIN 0;}
<BLOCK_COMMENT>.            { col += yyleng;}

\'(\\{escape}|[^\\\r\n\'])\'        { if(l > 0) printf("CHRLIT(%s)\n", yytext); col += yyleng; PASS_TOKEN(); if(t > 0) return CHRLIT;}
'([^\n\'\\]|\\.)*\\?{newline}       { printf("Line %d, column %d: unterminated char constant\n", line, col); col += yyleng; col = 1; line++;}
'([^\n\'\\]|\\.)*'                  { printf("Line %d, column %d: invalid char constant (%s)\n", line, col, yytext); col += yyleng;}


.                           { printf("Line %d, column %d: unrecognized character (%s)\n", line, col, yytext); col += yyleng;}
%%
extern int yylex();
int main(int argc, char** argv) {
    if(argc > 1) {
        if(!strcmp(argv[1],"-l")) {
        l = 1;
        t = 0;
        }
        
        if(!strcmp(argv[1],"-t")) t = 2;

        if(!strcmp(argv[1],"-s")) s = 1;
    }

    yyparse();
    if(l > 0) yylex();
    else {
        if(errors == 0 && t > 1) {
            if(!program) return 0;
            
            printAbsTree(program, 0);
            //freeAbsTree(program);
            free(temp);
        }
        if(errors == 0 && s > 0) {
            if(!program) return 0;

            show_symbol_table();
            //printAbsTree();
            free(temp);
        }
    }
    
    return 0;
}

int yywrap() {
    return 1;
}
void yyerror(char* error){
    errors++;
    printf("Line %d, column %lu: %s: %s\n", line, col-strlen(yytext), error, yytext);
}