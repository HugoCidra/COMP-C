digit [0-9]
clit_digit [0-7]
letter [a-zA-Z]
v_identifier [a-zA-Z][a-zA-Z0-9_]*
keywords int|char|double|if|then|else|while|short|return|void
spaces [ ]
newline [\n]
tokens [()=,*/+-]
exp [eE]
signal [+-]

%X LINE_COMMENT
%X BLOCK_COMMENT

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
{digit}+                    { printf("NATURAL (%s)\n", yytext); col += yyleng;}
{keywords}                  { printf("%s\n", toUpper(yytext)); col += yyleng;}
{v_identifier}*             { printf("IDENTIFIER (%s)\n", yytext); col += yyleng;}
{spaces}                    {col += yyleng;}
{newline}                   {line++; col = 1;}
"//"                        {BEGIN LINE_COMMENT;}
<LINE_COMMENT>.             {col += yyleng;}
<LINE_COMMENT>\n            {BEGIN 0; line++;}
"/*"                        {BEGIN BLOCK_COMMENT;}
<BLOCK_COMMENT>.            {; col += yyleng;}
<BLOCK_COMMENT>\n           {; line++;}
<BLOCK_COMMENT>"*/"         {BEGIN 0;}
(\'+{letter}+\'+|\'+{digit}+\'+|\\+("n"|"t"|\\|\'|\"|{clit_digit}{3}))            { printf ("CHARLIT(%s)\n", yytext); col += yyleng;}
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