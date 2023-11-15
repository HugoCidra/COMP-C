/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    BITWISEAND = 258,              /* BITWISEAND  */
    BITWISEOR = 259,               /* BITWISEOR  */
    BITWISEXOR = 260,              /* BITWISEXOR  */
    AND = 261,                     /* AND  */
    ASSIGN = 262,                  /* ASSIGN  */
    MUL = 263,                     /* MUL  */
    DIV = 264,                     /* DIV  */
    EQ = 265,                      /* EQ  */
    GE = 266,                      /* GE  */
    GT = 267,                      /* GT  */
    LBRACE = 268,                  /* LBRACE  */
    LE = 269,                      /* LE  */
    LPAR = 270,                    /* LPAR  */
    LT = 271,                      /* LT  */
    MINUS = 272,                   /* MINUS  */
    MOD = 273,                     /* MOD  */
    NE = 274,                      /* NE  */
    NOT = 275,                     /* NOT  */
    OR = 276,                      /* OR  */
    PLUS = 277,                    /* PLUS  */
    RBRACE = 278,                  /* RBRACE  */
    RPAR = 279,                    /* RPAR  */
    SEMI = 280,                    /* SEMI  */
    NATURAL = 281,                 /* NATURAL  */
    DECIMAL = 282,                 /* DECIMAL  */
    IDENTIFIER = 283,              /* IDENTIFIER  */
    CHRLIT = 284,                  /* CHRLIT  */
    INT = 285,                     /* INT  */
    CHAR = 286,                    /* CHAR  */
    VOID = 287,                    /* VOID  */
    RESERVED = 288,                /* RESERVED  */
    SHORT = 289,                   /* SHORT  */
    DOUBLE = 290,                  /* DOUBLE  */
    IF = 291,                      /* IF  */
    ELSE = 292,                    /* ELSE  */
    WHILE = 293,                   /* WHILE  */
    RETURN = 294,                  /* RETURN  */
    COMMA = 295,                   /* COMMA  */
    LOWER = 296,                   /* LOWER  */
    HIGHER = 297                   /* HIGHER  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define BITWISEAND 258
#define BITWISEOR 259
#define BITWISEXOR 260
#define AND 261
#define ASSIGN 262
#define MUL 263
#define DIV 264
#define EQ 265
#define GE 266
#define GT 267
#define LBRACE 268
#define LE 269
#define LPAR 270
#define LT 271
#define MINUS 272
#define MOD 273
#define NE 274
#define NOT 275
#define OR 276
#define PLUS 277
#define RBRACE 278
#define RPAR 279
#define SEMI 280
#define NATURAL 281
#define DECIMAL 282
#define IDENTIFIER 283
#define CHRLIT 284
#define INT 285
#define CHAR 286
#define VOID 287
#define RESERVED 288
#define SHORT 289
#define DOUBLE 290
#define IF 291
#define ELSE 292
#define WHILE 293
#define RETURN 294
#define COMMA 295
#define LOWER 296
#define HIGHER 297

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 92 "uccompiler.y"

     char* info;
     struct node* node;

#line 156 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
