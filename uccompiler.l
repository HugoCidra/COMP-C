digit [0-9]
clit_digit [0-7]
letter [a-zA-Z]
v_identifier [a-zA-Z][a-zA-Z0-9_]*
keywords int|char|double|if|then|else|while|short|return|void
reserved auto|break|case|const|continue|default|do|enum|extern|float|for|goto|long|register|signed|sizeof|static|struct|switch|typedef|union|unsigned|volatile|_Packed|"--"|"++"|"["|"]"
    
spaces [\t ]
newline [\n]
tokens [()=,*/+-]
exp [eE]
signal [+-]
chrlit [n|t|\\|\'|\"]

%X LINE_COMMENT
%X BLOCK_COMMENT
%X CHRLIT

%{
    int line = 1; int col = 1;

    char* toUpper(char* temp) {
        for(int i = 0; temp[i]; ++i) {
            temp[i] -= 32;
        }

        return temp;
    }
%}

%%
{digit}*("."*{digit}*{exp}+{signal}*{digit}+|"."{digit}+|{digit}+".")         { printf("DECIMAL (%s)\n", yytext); col += yyleng;}
{digit}+                    { printf("NATURAL(%s)\n", yytext); col += yyleng;}
{reserved}                  { printf("RESERVED(%s)\n", yytext); col += yyleng;}
{keywords}                  { printf("%s\n", toUpper(yytext)); col += yyleng;}
{v_identifier}*             { printf("IDENTIFIER(%s)\n", yytext); col += yyleng;}
{spaces}                    {col += yyleng;}
{newline}                   {line++; col = 1;}

"&"                         {printf ("BITWISEAND\n"); col += yyleng;}
"|"                         {printf ("BITWISEOR\n"); col += yyleng;}
"^"                         {printf ("BITWISEXOR\n"); col += yyleng;}
"&&"                        {printf ("AND\n"); col += yyleng;}
"="                         {printf ("ASSIGN\n"); col += yyleng;}
"*"                         {printf ("MUL\n"); col += yyleng;}
","                         {printf ("COMMA\n"); col += yyleng;}
"/"                         {printf ("DIV\n"); col += yyleng;}
"=="                        {printf ("EQ\n"); col += yyleng;}
">="                        {printf ("GE\n"); col += yyleng;}
">"                         {printf ("GT\n"); col += yyleng;}
"{"                         {printf ("LBRACE\n"); col += yyleng;}
"<="                        {printf ("LE\n"); col += yyleng;}
"("                         {printf ("LPAR\n"); col += yyleng;}
"<"                         {printf ("LT\n"); col += yyleng;}
"-"                         {printf ("MINUS\n"); col += yyleng;}
"%"                         {printf ("MOD\n"); col += yyleng;}
"!="                        {printf ("NE\n"); col += yyleng;}
"!"                         {printf ("NOT\n"); col += yyleng;}
"||"                        {printf ("OR\n"); col += yyleng;}
"+"                         {printf ("PLUS\n"); col += yyleng;}
"}"                         {printf ("RBRACE\n"); col += yyleng;}
")"                         {printf ("RPAR\n"); col += yyleng;}
";"                         {printf ("SEMI\n"); col += yyleng;}

"//"                        {BEGIN LINE_COMMENT;}
<LINE_COMMENT>.             {col += yyleng;}
<LINE_COMMENT>\n            {BEGIN 0; line++;}
"/*"                        {BEGIN BLOCK_COMMENT;}
<BLOCK_COMMENT>.            {; col += yyleng;}
<BLOCK_COMMENT>\n           {; line++;}
<BLOCK_COMMENT>"*/"         {BEGIN 0;}

\'[^\\]{1}\'                                            { printf("CHRLIT(%s)\n", yytext); col += yyleng;}
\'\\({chrlit}|{clit_digit}{1,3})\'                      { printf("CHRLIT(%s)\n", yytext); col += yyleng;}
\'([^\\|\']{1}|\\({chrlit}|{clit_digit}{1,3}))[^\']     { printf("Line %d, column %d: unterminated char constant\n", line, col); col += yyleng;}
\'[^\\].+\'|\'\\+({chrlit}+|{clit_digit}+)\'|\'\'       { printf("Line %d, column %d: invalid char constant (%s)\n", line, col, yytext); col += yyleng;}                    

{tokens}*                   { printf("%s\n", yytext); col += yyleng;}
.                           { printf("Line %d, column %d: unrecognized character (%s)\n", line, col, yytext); col += yyleng;}
%%
extern int yylex();
int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}