%{
    /*
     * Hugo Batista Cidra Duarte - 2020219765
     * Nuno Carvalho do Nascimento - 2020219249
    */

    #include "y.tab.h"
    #include "AbsTree.h"

    extern struct node* program;
    int yyparse(void);
    void yyerror(char*);
    #define PASS_TOKEN() yylval.info = strdup (yytext);

    int line = 1; int col = 1;
    int c_line = 1; int c_col = 1;
    int l = 0;

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
%X CHRLIT

%%
{spaces}                    {col += yyleng;}
{newline}                   {line++; col = 1;}

"&"                         { if(l > 0) printf ("BITWISEAND\n"); col += yyleng;         return BITWISEAND;}
"|"                         { if(l > 0) printf ("BITWISEOR\n"); col += yyleng;          return BITWISEOR;}
"^"                         { if(l > 0) printf ("BITWISEXOR\n"); col += yyleng;         return BITWISEXOR;}
"&&"                        { if(l > 0) printf ("AND\n"); col += yyleng;                return AND;}
"="                         { if(l > 0) printf ("ASSIGN\n"); col += yyleng;             return ASSIGN;}
"*"                         { if(l > 0) printf ("MUL\n"); col += yyleng;                return MUL;}
","                         { if(l > 0) printf ("COMMA\n"); col += yyleng;              return COMMA;}
"/"                         { if(l > 0) printf ("DIV\n"); col += yyleng;                return DIV;}
"=="                        { if(l > 0) printf ("EQ\n"); col += yyleng;                 return EQ;}
">="                        { if(l > 0) printf ("GE\n"); col += yyleng;                 return GE;}
">"                         { if(l > 0) printf ("GT\n"); col += yyleng;                 return GT;}
"{"                         { if(l > 0) printf ("LBRACE\n"); col += yyleng;             return LBRACE;}
"<="                        { if(l > 0) printf ("LE\n"); col += yyleng;                 return LE;}
"("                         { if(l > 0) printf ("LPAR\n"); col += yyleng;               return LPAR;}
"<"                         { if(l > 0) printf ("LT\n"); col += yyleng;                 return LT;}
"-"                         { if(l > 0) printf ("MINUS\n"); col += yyleng;              return MINUS;}
"%"                         { if(l > 0) printf ("MOD\n"); col += yyleng;                return MOD;}
"!="                        { if(l > 0) printf ("NE\n"); col += yyleng;                 return NE;}
"!"                         { if(l > 0) printf ("NOT\n"); col += yyleng;                return NOT;}
"||"                        { if(l > 0) printf ("OR\n"); col += yyleng;                 return OR;}
"+"                         { if(l > 0) printf ("PLUS\n"); col += yyleng;               return PLUS;}
"}"                         { if(l > 0) printf ("RBRACE\n"); col += yyleng;             return RBRACE;}
")"                         { if(l > 0) printf ("RPAR\n"); col += yyleng;               return RPAR;}
";"                         { if(l > 0) printf ("SEMI\n"); col += yyleng;               return SEMI;}

{digit}+"."|{digit}*"."{digit}+|({digit}+"."{digit}*|"."{digit}+|{digit}+){exp}{signal}?{digit}+         { if(l > 0) printf("DECIMAL(%s)\n", yytext); col += yyleng; PASS_TOKEN(); return DECIMAL;}   
{digit}+                    { if(l > 0) printf("NATURAL(%s)\n", yytext); col += yyleng; PASS_TOKEN(); return NATURAL;}
{reserved}                  { if(l > 0) printf("RESERVED(%s)\n", yytext); col += yyleng;    return RESERVED;}

{INT}                       { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return INT;}
{CHAR}                      { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return CHAR;}
{DOUBLE}                    { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return DOUBLE;}
{IF}                        { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return IF;}
{ELSE}                      { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return ELSE;}
{WHILE}                     { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return WHILE;}
{SHORT}                     { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return SHORT;}
{RETURN}                    { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return RETURN;}
{VOID}                      { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;     return VOID;}

{v_identifier}              { if(l > 0) printf("IDENTIFIER(%s)\n", yytext); col += yyleng; PASS_TOKEN(); return IDENTIFIER;}

"//"                        {BEGIN LINE_COMMENT;}
<LINE_COMMENT>.             {col += yyleng;}
<LINE_COMMENT>{newline}     {line++; col = 1; BEGIN 0;}
"/*"                        {BEGIN BLOCK_COMMENT; c_line = line; c_col = col; col += yyleng;}
<BLOCK_COMMENT>{newline}    {col = 1; line++;}
<BLOCK_COMMENT><<EOF>>      { printf("Line %d, column %d: unterminated comment\n", c_line, c_col); BEGIN 0;}
<BLOCK_COMMENT>"*/"         {col += yyleng; BEGIN 0;}
<BLOCK_COMMENT>.            {col += yyleng;}

\'(\\{escape}|[^\\\r\n\'])\'        { if(l > 0) printf("CHRLIT(%s)\n", yytext); col += yyleng; PASS_TOKEN(); return CHRLIT;}
'([^\n\'\\]|\\.)*\\?{newline}       { printf("Line %d, column %d: unterminated char constant\n", line, col); col += yyleng; col = 1; line++;}
'([^\n\'\\]|\\.)*'                  { printf("Line %d, column %d: invalid char constant (%s)\n", line, col, yytext); col += yyleng;}


.                           { printf("Line %d, column %d: unrecognized character (%s)\n", line, col, yytext); col += yyleng;}
%%
extern int yylex();
int main(int argc, char** argv) {
    if(argc > 1) 
        if(!strcmp(argv[1],"-l")) l = 1;
    
    //yylex();
    yyparse();
    printAbsTree(program, 0);
    return 0;
}

int yywrap() {
    return 1;
}
void yyerror(char* error){

    ;
}