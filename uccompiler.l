digit [0-9]
v_identifier [a-zA-Z][a-zA-Z0-9_]*
keywords integer|double|if|then|else
spaces [\t ]
newline [\n]
tokens [()=,*/+-]

%{
 int line = 1; int col = 1;
%}

%%
{digit}+                { printf("NATURAL (%s)\n", yytext); col += yyleng;}
{digit}*"."{digit}+     { printf("DECIMAL (%s)\n", yytext); col += yyleng;}
{keywords}              { printf("KEYWORD (%s)\n", yytext); col += yyleng;}
{v_identifier}*         { printf("IDENTIFIER (%s)\n", yytext); col += yyleng;}
{spaces}                {col += yyleng;}
{newline}               {line++; col = 1;}
{tokens}*               { printf("%s\n", yytext); col += yyleng;}
.                       { printf("Urecognized character '%s' (line %d, column %d)\n", yytext, line, col);}
%%
extern int yylex();
int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}