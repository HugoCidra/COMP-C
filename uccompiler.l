digit [0-9]
clit_digit [0-7]
letter [a-zA-Z]
v_identifier [a-zA-Z_][a-zA-Z0-9_]*
keywords int|char|double|if|then|else|while|short|return|void
reserved auto|break|case|const|continue|default|do|enum|extern|float|for|goto|long|register|signed|sizeof|static|struct|switch|typedef|union|unsigned|volatile|_Packed|"--"|"++"|"["|"]"
    
spaces [\r\t ]
newline \r\n|\r|\n
exp [eE]
signal [+-]
escape n|t|\\|\'|\"|{clit_digit}{1,3}
escape_nd n|t|\\|\'|\"

%X LINE_COMMENT
%X BLOCK_COMMENT
%X CHRLIT

%{
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

%%
{digit}*("."*{digit}*{exp}+{signal}*{digit}+|"."{digit}+|{digit}+".")         { if(l > 0)printf("DECIMAL(%s)\n", yytext); col += yyleng;}
{digit}+                    { if(l > 0) printf("NATURAL(%s)\n", yytext); col += yyleng;}
{reserved}                  { if(l > 0) printf("RESERVED(%s)\n", yytext); col += yyleng;}
{keywords}                  { if(l > 0) printf("%s\n", toUpper(yytext)); col += yyleng;}
{v_identifier}*             { if(l > 0) printf("IDENTIFIER(%s)\n", yytext); col += yyleng;}
{spaces}                    {col += yyleng;}
{newline}                   {line++; col = 1;}

"&"                         { if(l > 0) printf ("BITWISEAND\n"); col += yyleng;}
"|"                         { if(l > 0) printf ("BITWISEOR\n"); col += yyleng;}
"^"                         { if(l > 0) printf ("BITWISEXOR\n"); col += yyleng;}
"&&"                        { if(l > 0) printf ("AND\n"); col += yyleng;}
"="                         { if(l > 0) printf ("ASSIGN\n"); col += yyleng;}
"*"                         { if(l > 0) printf ("MUL\n"); col += yyleng;}
","                         { if(l > 0) printf ("COMMA\n"); col += yyleng;}
"/"                         { if(l > 0) printf ("DIV\n"); col += yyleng;}
"=="                        { if(l > 0) printf ("EQ\n"); col += yyleng;}
">="                        { if(l > 0) printf ("GE\n"); col += yyleng;}
">"                         { if(l > 0) printf ("GT\n"); col += yyleng;}
"{"                         { if(l > 0) printf ("LBRACE\n"); col += yyleng;}
"<="                        { if(l > 0) printf ("LE\n"); col += yyleng;}
"("                         { if(l > 0) printf ("LPAR\n"); col += yyleng;}
"<"                         { if(l > 0) printf ("LT\n"); col += yyleng;}
"-"                         { if(l > 0) printf ("MINUS\n"); col += yyleng;}
"%"                         { if(l > 0) printf ("MOD\n"); col += yyleng;}
"!="                        { if(l > 0) printf ("NE\n"); col += yyleng;}
"!"                         { if(l > 0) printf ("NOT\n"); col += yyleng;}
"||"                        { if(l > 0) printf ("OR\n"); col += yyleng;}
"+"                         { if(l > 0) printf ("PLUS\n"); col += yyleng;}
"}"                         { if(l > 0) printf ("RBRACE\n"); col += yyleng;}
")"                         { if(l > 0) printf ("RPAR\n"); col += yyleng;}
";"                         { if(l > 0) printf ("SEMI\n"); col += yyleng;}

"//"                        {BEGIN LINE_COMMENT;}
<LINE_COMMENT>.             {col += yyleng;}
<LINE_COMMENT>{newline}     {line++; col = 1; BEGIN 0;}
"/*"                        {BEGIN BLOCK_COMMENT; c_line = line; c_col = col;}
<BLOCK_COMMENT>{newline}    {col = 1; line++; c_col = 1; c_line = 1;}
<BLOCK_COMMENT><<EOF>>      { printf("Line %d, column %d: unterminated comment\n", c_line, c_col); BEGIN 0;}
<BLOCK_COMMENT>"*/"         {BEGIN 0;}
<BLOCK_COMMENT>.            {col += yyleng; c_col += yyleng;}

\'(\\{escape}|[^\\|\'])\'                                                   { if(l > 0) printf("CHRLIT(%s)\n", yytext); col += yyleng;}
\'.?{newline}[^\']?                                                         { printf("Line %d, column %d: unterminated char constant\n", line, col); col += yyleng; line++; col = 1;}
\'([^\']*|\\+({escape_nd}+|{clit_digit}+|{newline}+|{spaces}+).*)?\'        { printf("Line %d, column %d: invalid char constant (%s)\n", line, col, yytext); col += yyleng;}

.                           { printf("Line %d, column %d: unrecognized character (%s)\n", line, col, yytext); col += yyleng;}
%%
extern int yylex();
int main(int argc, char** argv) {
    if(argc > 1) 
        if(!strcmp(argv[1],"-l")) l = 1;
    
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}