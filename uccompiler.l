digit [0-9]
v_identifier [a-zA-Z][a-zA-Z0-9_]*
keywords int|char|double|if|then|else|while|short|return|void
spaces [\t ]
newline [\n]
tokens [()=,*/+-]
exp [eE]
signal [+-]

%X LINE_COMMENT
%X BLOCK_COMMENT

%{
    #include <string.h>

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
{digit}+                    { printf("NATURAL (%s)\n", yytext); col += yyleng;}
{keywords}                  { printf("%s\n", toUpper(yytext)); col += yyleng;}
{v_identifier}*             { printf("IDENTIFIER (%s)\n", yytext); col += yyleng;}
{spaces}                    {col += yyleng;}
{newline}                   {line++; col = 1;}
"//"                        {BEGIN LINE_COMMENT;}
<LINE_COMMENT>.             {;}
<LINE_COMMENT>\n            {BEGIN 0;}
"/*"                        {BEGIN BLOCK_COMMENT;}
<BLOCK_COMMENT>.            {;}
<BLOCK_COMMENT>"*/"         {BEGIN 0;}
{tokens}*                   { printf("%s\n", yytext); col += yyleng;}
.                           { printf("Urecognized character '%s' (line %d, column %d)\n", yytext, line, col); col += yyleng;}
%%
extern int yylex();
int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}