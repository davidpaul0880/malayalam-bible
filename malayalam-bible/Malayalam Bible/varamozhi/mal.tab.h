/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     AAA = 258,
     VOWEL = 259,
     SVARKOOT = 260,
     BAKKI = 261,
     GSs = 262,
     DA = 263,
     DDD = 264,
     THA = 265,
     YZH = 266,
     VVV = 267,
     lll = 268,
     nnn = 269,
     NNN = 270,
     MMM = 271,
     LLL = 272,
     RRR = 273,
     DQ = 274,
     SQ = 275,
     SYMBOL = 276,
     ENGLISH = 277,
     UNKNOWN = 278
   };
#endif
/* Tokens.  */
#define AAA 258
#define VOWEL 259
#define SVARKOOT 260
#define BAKKI 261
#define GSs 262
#define DA 263
#define DDD 264
#define THA 265
#define YZH 266
#define VVV 267
#define lll 268
#define nnn 269
#define NNN 270
#define MMM 271
#define LLL 272
#define RRR 273
#define DQ 274
#define SQ 275
#define SYMBOL 276
#define ENGLISH 277
#define UNKNOWN 278




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 67 "mal.y"
{
     int     val;
     UCHAR*  str;
     STRLIST slist;
     STRPAIR pair;
}
/* Line 1529 of yacc.c.  */
#line 102 "mal.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

