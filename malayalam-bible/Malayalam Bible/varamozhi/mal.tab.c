/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



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




/* Copy the first part of user declarations.  */
#line 25 "mal.y"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "strlist.h"
#include "strpair.h"
#include "mal-type.h"
#include "mal-decl.h"

#define HAVE_PARTS(i) ((map[i][LEFT][0] != 0) || (map[i][RIGHT][0] != 0))
#define HAVE_CHILL(i) (map[i][CHILL][0] != 0)
#define HAVE_R_DOT(i) (map[i][R_DOT][0] != 0)
#define CAN_R_DOT(i)  (allowRdot && HAVE_R_DOT(i))

#define RULE_DUMP { if (debug) { fprintf(stderr, "rule at %s:%u\n", __FILE__, __LINE__ ); } }

static STRPAIR append_syllable_add2add(STRPAIR p, UINT secindex, APPEND_MODE mode);
static STRPAIR append_syllable_noadd2add(STRPAIR p, UINT secindex, APPEND_MODE mode);
static STRPAIR append_syllable_add2noadd(STRPAIR p, UINT secindex, APPEND_MODE mode);
static STRPAIR append_syllable_noadd2noadd(STRPAIR p, UINT secindex, APPEND_MODE mode);
static STRPAIR create_syllable(UINT index, CREATE_MODE mode);
static STRLIST create_nonsyllable(UINT index,  COMPONENT mode);
static STRLIST extern_fn(STRLIST slist, EXTERN_TRANS_FN func);
static void    yyerror(char msg[]);

static int dqcount;
static int sqcount;
static char* mal_out_text;
static STATUS status;
static BOOLEAN allowRdot;
static BOOLEAN processmacro;

extern BOOLEAN carrycomment; /* defined in yylex() */

Private         private;
EXTERN_TRANS_FN fn_eng_trans;
EXTERN_TRANS_FN fn_mal_trans;
STRSTRUCT       halfcooked;
BOOLEAN         debug;



/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 67 "mal.y"
{
     int     val;
     UCHAR*  str;
     STRLIST slist;
     STRPAIR pair;
}
/* Line 193 of yacc.c.  */
#line 191 "mal.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 204 "mal.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1057

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  24
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  34
/* YYNRULES -- Number of rules.  */
#define YYNRULES  251
/* YYNRULES -- Number of states.  */
#define YYNSTATES  181

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   278

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     8,    12,    13,    15,    17,    20,
      22,    25,    29,    30,    32,    34,    36,    38,    40,    43,
      45,    47,    50,    53,    56,    58,    60,    63,    66,    68,
      70,    72,    74,    76,    78,    80,    82,    84,    86,    88,
      90,    92,    94,    96,    98,   100,   102,   104,   106,   108,
     110,   112,   114,   116,   119,   122,   125,   128,   131,   134,
     137,   140,   143,   145,   148,   151,   154,   157,   160,   163,
     166,   169,   172,   174,   177,   180,   183,   186,   189,   192,
     195,   198,   201,   203,   206,   209,   212,   215,   218,   221,
     224,   227,   230,   232,   235,   238,   241,   244,   247,   250,
     253,   256,   259,   261,   264,   267,   270,   273,   276,   279,
     282,   285,   288,   290,   293,   296,   299,   302,   305,   308,
     311,   314,   317,   319,   322,   325,   328,   331,   334,   337,
     340,   343,   346,   348,   351,   354,   357,   360,   363,   366,
     369,   372,   375,   377,   380,   383,   386,   389,   392,   395,
     398,   401,   404,   406,   409,   412,   415,   418,   421,   424,
     427,   430,   433,   435,   438,   441,   444,   447,   450,   453,
     456,   459,   462,   464,   467,   470,   473,   476,   479,   482,
     485,   488,   491,   493,   495,   497,   499,   501,   504,   507,
     510,   513,   516,   519,   522,   525,   528,   531,   534,   537,
     540,   543,   546,   549,   552,   555,   558,   561,   564,   567,
     570,   573,   576,   579,   582,   585,   588,   591,   594,   597,
     600,   603,   606,   609,   612,   615,   618,   621,   624,   627,
     630,   633,   636,   638,   641,   644,   647,   650,   653,   656,
     659,   662,   665,   667,   670,   673,   676,   679,   682,   685,
     688,   691
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      25,     0,    -1,    26,    -1,    27,    29,    -1,    27,    29,
      28,    -1,    -1,    22,    -1,    30,    -1,    31,    32,    -1,
      31,    -1,    31,    33,    -1,    31,    32,    33,    -1,    -1,
      34,    -1,    21,    -1,    23,    -1,    19,    -1,    20,    -1,
      35,    41,    -1,    35,    -1,    41,    -1,    35,    36,    -1,
      35,     5,    -1,    35,    39,    -1,    36,    -1,    37,    -1,
      40,    38,    -1,    40,     3,    -1,    39,    -1,     5,    -1,
       4,    -1,     5,    -1,     4,    -1,     3,    -1,    42,    -1,
      44,    -1,    46,    -1,    48,    -1,    50,    -1,    52,    -1,
      55,    -1,    56,    -1,    57,    -1,    43,    -1,    45,    -1,
      47,    -1,    49,    -1,    51,    -1,    54,    -1,    55,    -1,
      56,    -1,    57,    -1,    15,    -1,    42,    15,    -1,    45,
      15,    -1,    47,    15,    -1,    49,    15,    -1,    51,    15,
      -1,    53,    15,    -1,    55,    15,    -1,    56,    15,    -1,
      57,    15,    -1,    15,    -1,    42,    15,    -1,    45,    15,
      -1,    47,    15,    -1,    49,    15,    -1,    51,    15,    -1,
      53,    15,    -1,    55,    15,    -1,    56,    15,    -1,    57,
      15,    -1,    14,    -1,    43,    14,    -1,    44,    14,    -1,
      47,    14,    -1,    48,    14,    -1,    51,    14,    -1,    53,
      14,    -1,    55,    14,    -1,    56,    14,    -1,    57,    14,
      -1,    14,    -1,    43,    14,    -1,    44,    14,    -1,    47,
      14,    -1,    48,    14,    -1,    51,    14,    -1,    53,    14,
      -1,    55,    14,    -1,    56,    14,    -1,    57,    14,    -1,
      13,    -1,    43,    13,    -1,    45,    13,    -1,    46,    13,
      -1,    49,    13,    -1,    51,    13,    -1,    53,    13,    -1,
      55,    13,    -1,    56,    13,    -1,    57,    13,    -1,    13,
      -1,    43,    13,    -1,    45,    13,    -1,    46,    13,    -1,
      49,    13,    -1,    51,    13,    -1,    53,    13,    -1,    55,
      13,    -1,    56,    13,    -1,    57,    13,    -1,    16,    -1,
      43,    16,    -1,    45,    16,    -1,    46,    16,    -1,    48,
      16,    -1,    51,    16,    -1,    53,    16,    -1,    55,    16,
      -1,    56,    16,    -1,    57,    16,    -1,    16,    -1,    43,
      16,    -1,    45,    16,    -1,    46,    16,    -1,    48,    16,
      -1,    51,    16,    -1,    53,    16,    -1,    55,    16,    -1,
      56,    16,    -1,    57,    16,    -1,    17,    -1,    43,    17,
      -1,    45,    17,    -1,    47,    17,    -1,    50,    17,    -1,
      48,    17,    -1,    53,    17,    -1,    55,    17,    -1,    56,
      17,    -1,    57,    17,    -1,    17,    -1,    43,    17,    -1,
      45,    17,    -1,    47,    17,    -1,    53,    17,    -1,    48,
      17,    -1,    50,    17,    -1,    55,    17,    -1,    56,    17,
      -1,    57,    17,    -1,    18,    -1,    42,    18,    -1,    44,
      18,    -1,    47,    18,    -1,    48,    18,    -1,    50,    18,
      -1,    52,    18,    -1,    55,    18,    -1,    56,    18,    -1,
      57,    18,    -1,    18,    -1,    42,    18,    -1,    44,    18,
      -1,    47,    18,    -1,    48,    18,    -1,    50,    18,    -1,
      52,    18,    -1,    55,    18,    -1,    56,    18,    -1,    57,
      18,    -1,    18,    -1,    42,    18,    -1,    44,    18,    -1,
      47,    18,    -1,    48,    18,    -1,    50,    18,    -1,    52,
      18,    -1,    55,    18,    -1,    56,    18,    -1,    57,    18,
      -1,    12,    -1,     6,    -1,     7,    -1,     9,    -1,     8,
      -1,    42,    12,    -1,    42,     9,    -1,    42,     8,    -1,
      43,     6,    -1,    43,     7,    -1,    44,    12,    -1,    45,
       6,    -1,    45,     7,    -1,    45,     8,    -1,    45,     9,
      -1,    46,    12,    -1,    47,     6,    -1,    47,     7,    -1,
      47,     8,    -1,    47,     9,    -1,    49,    12,    -1,    49,
       6,    -1,    49,     7,    -1,    49,     8,    -1,    49,     9,
      -1,    51,    12,    -1,    51,     6,    -1,    51,     7,    -1,
      51,     8,    -1,    51,     9,    -1,    53,    12,    -1,    53,
       6,    -1,    53,     7,    -1,    53,     8,    -1,    53,     9,
      -1,    55,    12,    -1,    55,     6,    -1,    55,     7,    -1,
      55,     8,    -1,    55,     9,    -1,    56,    12,    -1,    56,
       6,    -1,    56,     7,    -1,    56,     8,    -1,    56,     9,
      -1,    57,    12,    -1,    57,     6,    -1,    57,     7,    -1,
      57,     8,    -1,    57,     9,    -1,    11,    -1,    42,    11,
      -1,    44,    11,    -1,    46,    11,    -1,    48,    11,    -1,
      50,    11,    -1,    52,    11,    -1,    55,    11,    -1,    56,
      11,    -1,    57,    11,    -1,    10,    -1,    43,    10,    -1,
      44,    10,    -1,    47,    10,    -1,    49,    10,    -1,    51,
      10,    -1,    53,    10,    -1,    55,    10,    -1,    56,    10,
      -1,    57,    10,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   126,   126,   131,   137,   142,   147,   155,   160,   164,
     169,   173,   178,   183,   189,   192,   195,   200,   207,   208,
     209,   212,   213,   214,   215,   216,   219,   220,   223,   224,
     227,   228,   231,   232,   237,   238,   239,   240,   241,   242,
     243,   244,   245,   248,   249,   250,   251,   252,   253,   254,
     255,   256,   261,   262,   263,   264,   265,   266,   267,   268,
     269,   270,   273,   274,   275,   276,   277,   278,   279,   280,
     281,   282,   286,   287,   288,   289,   290,   291,   292,   293,
     294,   295,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   312,   313,   314,   315,   316,   317,   318,   319,
     320,   321,   324,   325,   326,   327,   328,   329,   330,   331,
     332,   333,   339,   340,   341,   342,   343,   344,   345,   346,
     347,   348,   351,   352,   353,   354,   355,   356,   357,   358,
     359,   360,   366,   367,   368,   369,   370,   371,   372,   373,
     374,   375,   378,   379,   380,   381,   382,   383,   384,   385,
     386,   387,   392,   393,   394,   395,   396,   397,   398,   399,
     400,   401,   404,   405,   406,   407,   408,   409,   410,   411,
     412,   413,   416,   417,   418,   419,   420,   421,   422,   423,
     424,   425,   430,   431,   432,   433,   434,   436,   437,   438,
     439,   440,   442,   443,   444,   445,   446,   448,   449,   450,
     451,   452,   454,   455,   456,   457,   458,   460,   461,   462,
     463,   464,   466,   467,   468,   469,   470,   472,   473,   474,
     475,   476,   478,   479,   480,   481,   482,   484,   485,   486,
     487,   488,   493,   494,   495,   496,   497,   498,   499,   500,
     501,   502,   507,   508,   509,   510,   511,   512,   513,   514,
     515,   516
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "AAA", "VOWEL", "SVARKOOT", "BAKKI",
  "GSs", "DA", "DDD", "THA", "YZH", "VVV", "lll", "nnn", "NNN", "MMM",
  "LLL", "RRR", "DQ", "SQ", "SYMBOL", "ENGLISH", "UNKNOWN", "$accept",
  "START", "text", "text1", "eng_", "mal_", "mal", "mal1", "wordstr",
  "rest", "word", "wordv", "canaddv", "vowelak", "vowelk", "vowela",
  "canadd", "noadd", "addNNN", "noaddNNN", "addnnn", "noaddnnn", "addlll",
  "noaddlll", "addMMM", "noaddMMM", "addLLL", "noaddLLL", "addRRR",
  "noaddRRR", "lastRRR", "endGEN", "endYZH", "endTHA", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    24,    25,    26,    27,    27,    28,    29,    30,    30,
      31,    31,    31,    32,    33,    33,    33,    33,    34,    34,
      34,    35,    35,    35,    35,    35,    36,    36,    37,    37,
      38,    38,    39,    39,    40,    40,    40,    40,    40,    40,
      40,    40,    40,    41,    41,    41,    41,    41,    41,    41,
      41,    41,    42,    42,    42,    42,    42,    42,    42,    42,
      42,    42,    43,    43,    43,    43,    43,    43,    43,    43,
      43,    43,    44,    44,    44,    44,    44,    44,    44,    44,
      44,    44,    45,    45,    45,    45,    45,    45,    45,    45,
      45,    45,    46,    46,    46,    46,    46,    46,    46,    46,
      46,    46,    47,    47,    47,    47,    47,    47,    47,    47,
      47,    47,    48,    48,    48,    48,    48,    48,    48,    48,
      48,    48,    49,    49,    49,    49,    49,    49,    49,    49,
      49,    49,    50,    50,    50,    50,    50,    50,    50,    50,
      50,    50,    51,    51,    51,    51,    51,    51,    51,    51,
      51,    51,    52,    52,    52,    52,    52,    52,    52,    52,
      52,    52,    53,    53,    53,    53,    53,    53,    53,    53,
      53,    53,    54,    54,    54,    54,    54,    54,    54,    54,
      54,    54,    55,    55,    55,    55,    55,    55,    55,    55,
      55,    55,    55,    55,    55,    55,    55,    55,    55,    55,
      55,    55,    55,    55,    55,    55,    55,    55,    55,    55,
      55,    55,    55,    55,    55,    55,    55,    55,    55,    55,
      55,    55,    55,    55,    55,    55,    55,    55,    55,    55,
      55,    55,    56,    56,    56,    56,    56,    56,    56,    56,
      56,    56,    57,    57,    57,    57,    57,    57,    57,    57,
      57,    57
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     3,     0,     1,     1,     2,     1,
       2,     3,     0,     1,     1,     1,     1,     1,     2,     1,
       1,     2,     2,     2,     1,     1,     2,     2,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     1,     1,     1,     1,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       5,     0,     2,    12,     1,     3,     7,     9,     6,     4,
      33,    32,    29,   183,   184,   186,   185,   242,   232,   182,
     102,    82,    62,   122,   142,   162,    16,    17,    14,    15,
       8,    10,    13,    19,    24,    25,    28,     0,    20,    34,
      43,    35,    44,    36,    45,    37,    46,    38,    47,    39,
       0,    48,    49,    50,    51,    11,    22,    21,    23,    18,
      27,    30,    31,    26,   189,   188,   233,   187,    63,   163,
     190,   191,   243,   103,    83,   123,   143,   244,   234,   192,
      84,   164,   193,   194,   195,   196,   104,    64,   124,   144,
     235,   197,   105,   125,   198,   199,   200,   201,   245,    85,
      65,   145,   165,   236,    86,   126,   147,   166,   203,   204,
     205,   206,   246,   202,   106,    66,   237,   148,   167,   208,
     209,   210,   211,   247,   207,   107,    87,    67,   127,   238,
     168,   213,   214,   215,   216,   248,   212,   108,    88,    68,
     128,   146,   218,   219,   220,   221,   249,   239,   217,   109,
      89,    69,   129,   149,   169,   223,   224,   225,   226,   250,
     240,   222,   110,    90,    70,   130,   150,   170,   228,   229,
     230,   231,   251,   241,   227,   111,    91,    71,   131,   151,
     171
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     1,     2,     3,     9,     5,     6,     7,    30,    31,
      32,    33,    34,    35,    63,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -21
static const yytype_int16 yypact[] =
{
     -21,     1,   -21,   -21,   -21,   -20,   -21,   237,   -21,   -21,
     -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,
     845,   482,   322,   494,   750,     0,   -21,   -21,   -21,   -21,
      66,   -21,   -21,   258,   -21,   -21,   -21,    36,   -21,    -2,
    1019,    20,  1007,    68,   982,    44,  1042,    -3,  1031,    15,
     995,   -21,   274,   290,   306,   -21,   -21,   -21,   -21,   -21,
     -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,   338,    24,
     -21,   -21,   -21,   859,   510,   522,   766,   -21,   -21,   -21,
     538,    48,   -21,   -21,   -21,   -21,   873,   354,   550,   769,
     -21,   -21,   887,   566,   -21,   -21,   -21,   -21,   -21,   582,
     370,   785,    72,   -21,   594,   606,   788,    96,   -21,   -21,
     -21,   -21,   -21,   -21,   901,   386,   -21,   804,   120,   -21,
     -21,   -21,   -21,   -21,   -21,   915,   622,   402,   634,   -21,
     144,   -21,   -21,   -21,   -21,   -21,   -21,   929,   650,   418,
     662,   807,   -21,   -21,   -21,   -21,   -21,   -21,   -21,   943,
     678,   434,   690,   823,   168,   -21,   -21,   -21,   -21,   -21,
     -21,   -21,   957,   706,   450,   718,   826,   192,   -21,   -21,
     -21,   -21,   -21,   -21,   -21,   971,   734,   466,   746,   842,
     216
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,   -18,
     -21,   -21,   -16,   -21,   -21,    -8,   -21,     3,   -21,   -21,
     -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,   -21,
     -21,   -21,   -21,   -21
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -182
static const yytype_int16 yytable[] =
{
    -172,     4,     8,  -152,  -152,  -152,    64,    65,   116,    66,
      67,  -152,    55,    68,   117,   118,    69,    57,  -152,  -172,
    -172,  -172,  -172,  -172,  -173,    58,   129,  -153,  -153,  -153,
      77,    78,    79,   130,    80,  -153,    59,     0,    81,    60,
      61,    62,  -153,  -173,  -173,  -173,  -173,  -173,  -174,     0,
       0,  -154,  -154,  -154,     0,   103,     0,     0,   104,  -154,
     105,   106,   107,     0,     0,     0,  -154,  -174,  -174,  -174,
    -174,  -174,  -175,     0,     0,  -155,  -155,  -155,     0,    90,
      91,    92,     0,  -155,    93,    26,    27,    28,     0,    29,
    -155,  -175,  -175,  -175,  -175,  -175,  -176,     0,     0,  -156,
    -156,  -156,     0,     0,     0,     0,     0,  -156,     0,     0,
       0,     0,     0,     0,  -156,  -176,  -176,  -176,  -176,  -176,
    -177,     0,     0,  -157,  -157,  -157,     0,     0,     0,     0,
       0,  -157,     0,     0,     0,     0,     0,     0,  -157,  -177,
    -177,  -177,  -177,  -177,  -178,     0,     0,  -158,  -158,  -158,
       0,     0,     0,     0,     0,  -158,     0,     0,     0,     0,
       0,     0,  -158,  -178,  -178,  -178,  -178,  -178,  -179,     0,
       0,  -159,  -159,  -159,     0,     0,     0,     0,     0,  -159,
       0,     0,     0,     0,     0,     0,  -159,  -179,  -179,  -179,
    -179,  -179,  -180,     0,     0,  -160,  -160,  -160,     0,     0,
       0,     0,     0,  -160,     0,     0,     0,     0,     0,     0,
    -160,  -180,  -180,  -180,  -180,  -180,  -181,     0,     0,  -161,
    -161,  -161,     0,     0,     0,     0,     0,  -161,     0,     0,
       0,     0,     0,     0,  -161,  -181,  -181,  -181,  -181,  -181,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,     0,
      29,    10,    11,    56,    13,    14,    15,    16,    17,    18,
      19,    20,    21,    22,    23,    24,    25,   -40,   -40,   -40,
     142,   143,   144,   145,   146,   147,   148,   149,   150,   151,
     152,   153,   154,   -41,   -41,   -41,   155,   156,   157,   158,
     159,   160,   161,   162,   163,   164,   165,   166,   167,   -42,
     -42,   -42,   168,   169,   170,   171,   172,   173,   174,   175,
     176,   177,   178,   179,   180,   -52,   -52,   -52,     0,     0,
     -52,   -52,     0,   -52,   -52,     0,     0,   -52,     0,     0,
     -52,   -53,   -53,   -53,     0,     0,   -53,   -53,     0,   -53,
     -53,     0,     0,   -53,     0,     0,   -53,   -54,   -54,   -54,
       0,     0,   -54,   -54,     0,   -54,   -54,     0,     0,   -54,
       0,     0,   -54,   -55,   -55,   -55,     0,     0,   -55,   -55,
       0,   -55,   -55,     0,     0,   -55,     0,     0,   -55,   -56,
     -56,   -56,     0,     0,   -56,   -56,     0,   -56,   -56,     0,
       0,   -56,     0,     0,   -56,   -57,   -57,   -57,     0,     0,
     -57,   -57,     0,   -57,   -57,     0,     0,   -57,     0,     0,
     -57,   -58,   -58,   -58,     0,     0,   -58,   -58,     0,   -58,
     -58,     0,     0,   -58,     0,     0,   -58,   -59,   -59,   -59,
       0,     0,   -59,   -59,     0,   -59,   -59,     0,     0,   -59,
       0,     0,   -59,   -60,   -60,   -60,     0,     0,   -60,   -60,
       0,   -60,   -60,     0,     0,   -60,     0,     0,   -60,   -61,
     -61,   -61,     0,     0,   -61,   -61,     0,   -61,   -61,     0,
       0,   -61,     0,     0,   -61,   -72,   -72,   -72,     0,     0,
       0,     0,   -72,   -72,   -72,     0,   -72,  -112,  -112,  -112,
     -72,     0,     0,     0,     0,  -112,     0,     0,  -112,     0,
    -112,  -112,  -112,   -73,   -73,   -73,     0,     0,     0,     0,
     -73,   -73,   -73,     0,   -73,  -113,  -113,  -113,   -73,     0,
       0,     0,     0,  -113,     0,     0,  -113,     0,  -113,  -113,
    -113,   -74,   -74,   -74,     0,     0,     0,     0,   -74,   -74,
     -74,     0,   -74,  -114,  -114,  -114,   -74,     0,     0,     0,
       0,  -114,     0,     0,  -114,     0,  -114,  -114,  -114,  -115,
    -115,  -115,     0,     0,     0,     0,     0,  -115,     0,     0,
    -115,     0,  -115,  -115,  -115,   -75,   -75,   -75,     0,     0,
       0,     0,   -75,   -75,   -75,     0,   -75,   -76,   -76,   -76,
     -75,     0,     0,     0,   -76,   -76,   -76,     0,   -76,  -116,
    -116,  -116,   -76,     0,     0,     0,     0,  -116,     0,     0,
    -116,     0,  -116,  -116,  -116,   -77,   -77,   -77,     0,     0,
       0,     0,   -77,   -77,   -77,     0,   -77,  -117,  -117,  -117,
     -77,     0,     0,     0,     0,  -117,     0,     0,  -117,     0,
    -117,  -117,  -117,   -78,   -78,   -78,     0,     0,     0,     0,
     -78,   -78,   -78,     0,   -78,  -118,  -118,  -118,   -78,     0,
       0,     0,     0,  -118,     0,     0,  -118,     0,  -118,  -118,
    -118,   -79,   -79,   -79,     0,     0,     0,     0,   -79,   -79,
     -79,     0,   -79,  -119,  -119,  -119,   -79,     0,     0,     0,
       0,  -119,     0,     0,  -119,     0,  -119,  -119,  -119,   -80,
     -80,   -80,     0,     0,     0,     0,   -80,   -80,   -80,     0,
     -80,  -120,  -120,  -120,   -80,     0,     0,     0,     0,  -120,
       0,     0,  -120,     0,  -120,  -120,  -120,   -81,   -81,   -81,
       0,     0,     0,     0,   -81,   -81,   -81,     0,   -81,  -121,
    -121,  -121,   -81,  -132,  -132,  -132,     0,  -121,     0,     0,
    -121,  -132,  -121,  -121,  -121,     0,     0,  -132,  -132,  -133,
    -133,  -133,  -134,  -134,  -134,     0,     0,  -133,     0,     0,
    -134,     0,     0,  -133,  -133,     0,  -134,  -134,  -135,  -135,
    -135,  -137,  -137,  -137,     0,     0,  -135,     0,     0,  -137,
       0,     0,  -135,  -135,     0,  -137,  -137,  -136,  -136,  -136,
    -138,  -138,  -138,     0,     0,  -136,     0,     0,  -138,     0,
       0,  -136,  -136,     0,  -138,  -138,  -139,  -139,  -139,  -140,
    -140,  -140,     0,     0,  -139,     0,     0,  -140,     0,     0,
    -139,  -139,     0,  -140,  -140,  -141,  -141,  -141,   -92,   -92,
     -92,     0,     0,  -141,     0,     0,   -92,   -92,   -92,  -141,
    -141,   -92,   -93,   -93,   -93,     0,     0,     0,     0,     0,
     -93,   -93,   -93,     0,     0,   -93,   -94,   -94,   -94,     0,
       0,     0,     0,     0,   -94,   -94,   -94,     0,     0,   -94,
     -95,   -95,   -95,     0,     0,     0,     0,     0,   -95,   -95,
     -95,     0,     0,   -95,   -96,   -96,   -96,     0,     0,     0,
       0,     0,   -96,   -96,   -96,     0,     0,   -96,   -97,   -97,
     -97,     0,     0,     0,     0,     0,   -97,   -97,   -97,     0,
       0,   -97,   -98,   -98,   -98,     0,     0,     0,     0,     0,
     -98,   -98,   -98,     0,     0,   -98,   -99,   -99,   -99,     0,
       0,     0,     0,     0,   -99,   -99,   -99,     0,     0,   -99,
    -100,  -100,  -100,     0,     0,     0,     0,     0,  -100,  -100,
    -100,     0,     0,  -100,  -101,  -101,  -101,     0,     0,     0,
       0,     0,  -101,  -101,  -101,     0,     0,  -101,    94,    95,
      96,    97,    98,     0,     0,     0,    99,   100,     0,   101,
     102,   131,   132,   133,   134,   135,     0,   136,   137,   138,
     139,   140,   141,    82,    83,    84,    85,     0,     0,     0,
      86,     0,    87,    88,    89,    70,    71,     0,     0,    72,
       0,     0,    73,    74,     0,    75,    76,   119,   120,   121,
     122,   123,     0,   124,   125,   126,   127,   128,   108,   109,
     110,   111,   112,     0,   113,   114,     0,   115
};

static const yytype_int8 yycheck[] =
{
       0,     0,    22,     3,     4,     5,     8,     9,    11,    11,
      12,    11,    30,    15,    17,    18,    18,    33,    18,    19,
      20,    21,    22,    23,     0,    33,    11,     3,     4,     5,
      10,    11,    12,    18,    14,    11,    33,    -1,    18,     3,
       4,     5,    18,    19,    20,    21,    22,    23,     0,    -1,
      -1,     3,     4,     5,    -1,    11,    -1,    -1,    14,    11,
      16,    17,    18,    -1,    -1,    -1,    18,    19,    20,    21,
      22,    23,     0,    -1,    -1,     3,     4,     5,    -1,    11,
      12,    13,    -1,    11,    16,    19,    20,    21,    -1,    23,
      18,    19,    20,    21,    22,    23,     0,    -1,    -1,     3,
       4,     5,    -1,    -1,    -1,    -1,    -1,    11,    -1,    -1,
      -1,    -1,    -1,    -1,    18,    19,    20,    21,    22,    23,
       0,    -1,    -1,     3,     4,     5,    -1,    -1,    -1,    -1,
      -1,    11,    -1,    -1,    -1,    -1,    -1,    -1,    18,    19,
      20,    21,    22,    23,     0,    -1,    -1,     3,     4,     5,
      -1,    -1,    -1,    -1,    -1,    11,    -1,    -1,    -1,    -1,
      -1,    -1,    18,    19,    20,    21,    22,    23,     0,    -1,
      -1,     3,     4,     5,    -1,    -1,    -1,    -1,    -1,    11,
      -1,    -1,    -1,    -1,    -1,    -1,    18,    19,    20,    21,
      22,    23,     0,    -1,    -1,     3,     4,     5,    -1,    -1,
      -1,    -1,    -1,    11,    -1,    -1,    -1,    -1,    -1,    -1,
      18,    19,    20,    21,    22,    23,     0,    -1,    -1,     3,
       4,     5,    -1,    -1,    -1,    -1,    -1,    11,    -1,    -1,
      -1,    -1,    -1,    -1,    18,    19,    20,    21,    22,    23,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,    21,    -1,
      23,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,     3,     4,     5,    -1,    -1,
       8,     9,    -1,    11,    12,    -1,    -1,    15,    -1,    -1,
      18,     3,     4,     5,    -1,    -1,     8,     9,    -1,    11,
      12,    -1,    -1,    15,    -1,    -1,    18,     3,     4,     5,
      -1,    -1,     8,     9,    -1,    11,    12,    -1,    -1,    15,
      -1,    -1,    18,     3,     4,     5,    -1,    -1,     8,     9,
      -1,    11,    12,    -1,    -1,    15,    -1,    -1,    18,     3,
       4,     5,    -1,    -1,     8,     9,    -1,    11,    12,    -1,
      -1,    15,    -1,    -1,    18,     3,     4,     5,    -1,    -1,
       8,     9,    -1,    11,    12,    -1,    -1,    15,    -1,    -1,
      18,     3,     4,     5,    -1,    -1,     8,     9,    -1,    11,
      12,    -1,    -1,    15,    -1,    -1,    18,     3,     4,     5,
      -1,    -1,     8,     9,    -1,    11,    12,    -1,    -1,    15,
      -1,    -1,    18,     3,     4,     5,    -1,    -1,     8,     9,
      -1,    11,    12,    -1,    -1,    15,    -1,    -1,    18,     3,
       4,     5,    -1,    -1,     8,     9,    -1,    11,    12,    -1,
      -1,    15,    -1,    -1,    18,     3,     4,     5,    -1,    -1,
      -1,    -1,    10,    11,    12,    -1,    14,     3,     4,     5,
      18,    -1,    -1,    -1,    -1,    11,    -1,    -1,    14,    -1,
      16,    17,    18,     3,     4,     5,    -1,    -1,    -1,    -1,
      10,    11,    12,    -1,    14,     3,     4,     5,    18,    -1,
      -1,    -1,    -1,    11,    -1,    -1,    14,    -1,    16,    17,
      18,     3,     4,     5,    -1,    -1,    -1,    -1,    10,    11,
      12,    -1,    14,     3,     4,     5,    18,    -1,    -1,    -1,
      -1,    11,    -1,    -1,    14,    -1,    16,    17,    18,     3,
       4,     5,    -1,    -1,    -1,    -1,    -1,    11,    -1,    -1,
      14,    -1,    16,    17,    18,     3,     4,     5,    -1,    -1,
      -1,    -1,    10,    11,    12,    -1,    14,     3,     4,     5,
      18,    -1,    -1,    -1,    10,    11,    12,    -1,    14,     3,
       4,     5,    18,    -1,    -1,    -1,    -1,    11,    -1,    -1,
      14,    -1,    16,    17,    18,     3,     4,     5,    -1,    -1,
      -1,    -1,    10,    11,    12,    -1,    14,     3,     4,     5,
      18,    -1,    -1,    -1,    -1,    11,    -1,    -1,    14,    -1,
      16,    17,    18,     3,     4,     5,    -1,    -1,    -1,    -1,
      10,    11,    12,    -1,    14,     3,     4,     5,    18,    -1,
      -1,    -1,    -1,    11,    -1,    -1,    14,    -1,    16,    17,
      18,     3,     4,     5,    -1,    -1,    -1,    -1,    10,    11,
      12,    -1,    14,     3,     4,     5,    18,    -1,    -1,    -1,
      -1,    11,    -1,    -1,    14,    -1,    16,    17,    18,     3,
       4,     5,    -1,    -1,    -1,    -1,    10,    11,    12,    -1,
      14,     3,     4,     5,    18,    -1,    -1,    -1,    -1,    11,
      -1,    -1,    14,    -1,    16,    17,    18,     3,     4,     5,
      -1,    -1,    -1,    -1,    10,    11,    12,    -1,    14,     3,
       4,     5,    18,     3,     4,     5,    -1,    11,    -1,    -1,
      14,    11,    16,    17,    18,    -1,    -1,    17,    18,     3,
       4,     5,     3,     4,     5,    -1,    -1,    11,    -1,    -1,
      11,    -1,    -1,    17,    18,    -1,    17,    18,     3,     4,
       5,     3,     4,     5,    -1,    -1,    11,    -1,    -1,    11,
      -1,    -1,    17,    18,    -1,    17,    18,     3,     4,     5,
       3,     4,     5,    -1,    -1,    11,    -1,    -1,    11,    -1,
      -1,    17,    18,    -1,    17,    18,     3,     4,     5,     3,
       4,     5,    -1,    -1,    11,    -1,    -1,    11,    -1,    -1,
      17,    18,    -1,    17,    18,     3,     4,     5,     3,     4,
       5,    -1,    -1,    11,    -1,    -1,    11,    12,    13,    17,
      18,    16,     3,     4,     5,    -1,    -1,    -1,    -1,    -1,
      11,    12,    13,    -1,    -1,    16,     3,     4,     5,    -1,
      -1,    -1,    -1,    -1,    11,    12,    13,    -1,    -1,    16,
       3,     4,     5,    -1,    -1,    -1,    -1,    -1,    11,    12,
      13,    -1,    -1,    16,     3,     4,     5,    -1,    -1,    -1,
      -1,    -1,    11,    12,    13,    -1,    -1,    16,     3,     4,
       5,    -1,    -1,    -1,    -1,    -1,    11,    12,    13,    -1,
      -1,    16,     3,     4,     5,    -1,    -1,    -1,    -1,    -1,
      11,    12,    13,    -1,    -1,    16,     3,     4,     5,    -1,
      -1,    -1,    -1,    -1,    11,    12,    13,    -1,    -1,    16,
       3,     4,     5,    -1,    -1,    -1,    -1,    -1,    11,    12,
      13,    -1,    -1,    16,     3,     4,     5,    -1,    -1,    -1,
      -1,    -1,    11,    12,    13,    -1,    -1,    16,     6,     7,
       8,     9,    10,    -1,    -1,    -1,    14,    15,    -1,    17,
      18,     6,     7,     8,     9,    10,    -1,    12,    13,    14,
      15,    16,    17,     6,     7,     8,     9,    -1,    -1,    -1,
      13,    -1,    15,    16,    17,     6,     7,    -1,    -1,    10,
      -1,    -1,    13,    14,    -1,    16,    17,     6,     7,     8,
       9,    10,    -1,    12,    13,    14,    15,    16,     6,     7,
       8,     9,    10,    -1,    12,    13,    -1,    15
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    25,    26,    27,     0,    29,    30,    31,    22,    28,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,    21,    23,
      32,    33,    34,    35,    36,    37,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    33,     5,    36,    39,    41,
       3,     4,     5,    38,     8,     9,    11,    12,    15,    18,
       6,     7,    10,    13,    14,    16,    17,    10,    11,    12,
      14,    18,     6,     7,     8,     9,    13,    15,    16,    17,
      11,    12,    13,    16,     6,     7,     8,     9,    10,    14,
      15,    17,    18,    11,    14,    16,    17,    18,     6,     7,
       8,     9,    10,    12,    13,    15,    11,    17,    18,     6,
       7,     8,     9,    10,    12,    13,    14,    15,    16,    11,
      18,     6,     7,     8,     9,    10,    12,    13,    14,    15,
      16,    17,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 126 "mal.y"
    { RULE_DUMP
                                 mal_out_text = strlist2string((yyvsp[(1) - (1)].slist), &status);
                               ;}
    break;

  case 3:
#line 131 "mal.y"
    { RULE_DUMP
                                 strlist_concat( (yyvsp[(1) - (2)].slist), (yyvsp[(2) - (2)].slist) );
                                 (yyval.slist) = (yyvsp[(1) - (2)].slist);
                               ;}
    break;

  case 4:
#line 137 "mal.y"
    { RULE_DUMP
                                 strlist_concat( (yyvsp[(1) - (3)].slist), (yyvsp[(2) - (3)].slist) );
                                 strlist_concat( (yyvsp[(1) - (3)].slist), (yyvsp[(3) - (3)].slist) );
                                 (yyval.slist) = (yyvsp[(1) - (3)].slist);
                               ;}
    break;

  case 5:
#line 142 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = strlist_create(NULL, RO_STR, &status);
                               ;}
    break;

  case 6:
#line 147 "mal.y"
    { 
                                 STRLIST s;
                                 RULE_DUMP
                                 s  = strlist_create( (yyvsp[(1) - (1)].str), RO_STR, &status );
                                 (yyval.slist) = extern_fn( s, fn_eng_trans );
                               ;}
    break;

  case 7:
#line 155 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = extern_fn( (yyvsp[(1) - (1)].slist), fn_mal_trans );
                               ;}
    break;

  case 8:
#line 160 "mal.y"
    { RULE_DUMP
                                 strlist_concat( (yyvsp[(1) - (2)].slist), (yyvsp[(2) - (2)].slist) );
                                 (yyval.slist) = (yyvsp[(1) - (2)].slist) ;
                               ;}
    break;

  case 9:
#line 164 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = (yyvsp[(1) - (1)].slist)
                               ;}
    break;

  case 10:
#line 169 "mal.y"
    { RULE_DUMP
                                 strlist_concat( (yyvsp[(1) - (2)].slist), (yyvsp[(2) - (2)].slist) );
                                 (yyval.slist) = (yyvsp[(1) - (2)].slist) ;
                               ;}
    break;

  case 11:
#line 173 "mal.y"
    { RULE_DUMP 
                                 strlist_concat( (yyvsp[(1) - (3)].slist), (yyvsp[(2) - (3)].slist) );
                                 strlist_concat( (yyvsp[(1) - (3)].slist), (yyvsp[(3) - (3)].slist) );
                                 (yyval.slist) = (yyvsp[(1) - (3)].slist);
                               ;}
    break;

  case 12:
#line 178 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = strlist_create(NULL, RO_STR, &status);
                               ;}
    break;

  case 13:
#line 183 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = strpair2strlist((yyvsp[(1) - (1)].pair));
                               ;}
    break;

  case 14:
#line 189 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = create_nonsyllable((yyvsp[(1) - (1)].val), MAIN);
                               ;}
    break;

  case 15:
#line 192 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = strlist_create((yyvsp[(1) - (1)].str), RO_STR, &status);
                               ;}
    break;

  case 16:
#line 195 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = (dqcount++ % 2) ?
                                      create_nonsyllable((yyvsp[(1) - (1)].val), LEFT):
                                      create_nonsyllable((yyvsp[(1) - (1)].val), RIGHT);
                               ;}
    break;

  case 17:
#line 200 "mal.y"
    { RULE_DUMP
                                 (yyval.slist) = (sqcount++ % 2) ?
                                      create_nonsyllable((yyvsp[(1) - (1)].val), LEFT):
                                      create_nonsyllable((yyvsp[(1) - (1)].val), RIGHT);
                               ;}
    break;

  case 18:
#line 207 "mal.y"
    { RULE_DUMP (yyval.pair) = strpair_concat((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].pair), AA_BB); ;}
    break;

  case 19:
#line 208 "mal.y"
    { RULE_DUMP (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 20:
#line 209 "mal.y"
    { RULE_DUMP (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 21:
#line 212 "mal.y"
    { RULE_DUMP (yyval.pair) = strpair_concat((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].pair), AA_BB); ;}
    break;

  case 22:
#line 213 "mal.y"
    { RULE_DUMP (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 23:
#line 214 "mal.y"
    { RULE_DUMP (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP_ELONG); ;}
    break;

  case 24:
#line 215 "mal.y"
    { RULE_DUMP (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 25:
#line 216 "mal.y"
    { RULE_DUMP (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 26:
#line 219 "mal.y"
    { RULE_DUMP (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 27:
#line 220 "mal.y"
    { RULE_DUMP (yyval.pair) = (yyvsp[(1) - (2)].pair) ;}
    break;

  case 28:
#line 223 "mal.y"
    { RULE_DUMP (yyval.val) = (yyvsp[(1) - (1)].val) ;}
    break;

  case 29:
#line 224 "mal.y"
    { RULE_DUMP (yyval.val) = (yyvsp[(1) - (1)].val) ;}
    break;

  case 30:
#line 227 "mal.y"
    { RULE_DUMP (yyval.val) = (yyvsp[(1) - (1)].val) ;}
    break;

  case 31:
#line 228 "mal.y"
    { RULE_DUMP (yyval.val) = (yyvsp[(1) - (1)].val) ;}
    break;

  case 32:
#line 231 "mal.y"
    { RULE_DUMP (yyval.val) = (yyvsp[(1) - (1)].val) ;}
    break;

  case 33:
#line 232 "mal.y"
    { RULE_DUMP (yyval.val) = (yyvsp[(1) - (1)].val) ;}
    break;

  case 34:
#line 237 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 35:
#line 238 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 36:
#line 239 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 37:
#line 240 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 38:
#line 241 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 39:
#line 242 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 40:
#line 243 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 41:
#line 244 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 42:
#line 245 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 43:
#line 248 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 44:
#line 249 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 45:
#line 250 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 46:
#line 251 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 47:
#line 252 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 48:
#line 253 "mal.y"
    { RULE_DUMP  (yyval.pair) = (yyvsp[(1) - (1)].pair) ;}
    break;

  case 49:
#line 254 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (1)].pair), samindex, WRAP); ;}
    break;

  case 50:
#line 255 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (1)].pair), samindex, WRAP); ;}
    break;

  case 51:
#line 256 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (1)].pair), samindex, WRAP); ;}
    break;

  case 52:
#line 261 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 53:
#line 262 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 54:
#line 263 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 55:
#line 264 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 56:
#line 265 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 57:
#line 266 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 58:
#line 267 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 59:
#line 268 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 60:
#line 269 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 61:
#line 270 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 62:
#line 273 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), NOADD); ;}
    break;

  case 63:
#line 274 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 64:
#line 275 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 65:
#line 276 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 66:
#line 277 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 67:
#line 278 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 68:
#line 279 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 69:
#line 280 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 70:
#line 281 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 71:
#line 282 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 72:
#line 286 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 73:
#line 287 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 74:
#line 288 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 75:
#line 289 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 76:
#line 290 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 77:
#line 291 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 78:
#line 292 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 79:
#line 293 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 80:
#line 294 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 81:
#line 295 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 82:
#line 298 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), NOADD); ;}
    break;

  case 83:
#line 299 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 84:
#line 300 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 85:
#line 301 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 86:
#line 302 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 87:
#line 303 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 88:
#line 304 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 89:
#line 305 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 90:
#line 306 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 91:
#line 307 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 92:
#line 312 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 93:
#line 313 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE);         ;}
    break;

  case 94:
#line 314 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE);         ;}
    break;

  case 95:
#line 315 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add(  (yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO);    ;}
    break;

  case 96:
#line 316 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE);         ;}
    break;

  case 97:
#line 317 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE);         ;}
    break;

  case 98:
#line 318 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 99:
#line 319 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add(  (yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP);         ;}
    break;

  case 100:
#line 320 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add(  (yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO);    ;}
    break;

  case 101:
#line 321 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add(  (yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP);         ;}
    break;

  case 102:
#line 324 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), NOADD); ;}
    break;

  case 103:
#line 325 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 104:
#line 326 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 105:
#line 327 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd(  (yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO);    ;}
    break;

  case 106:
#line 328 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 107:
#line 329 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 108:
#line 330 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 109:
#line 331 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd(  (yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP);         ;}
    break;

  case 110:
#line 332 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd(  (yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 111:
#line 333 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd(  (yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP);         ;}
    break;

  case 112:
#line 339 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 113:
#line 340 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 114:
#line 341 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 115:
#line 342 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 116:
#line 343 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 117:
#line 344 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 118:
#line 345 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 119:
#line 346 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 120:
#line 347 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 121:
#line 348 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 122:
#line 351 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), NOADD); ;}
    break;

  case 123:
#line 352 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 124:
#line 353 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 125:
#line 354 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 126:
#line 355 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 127:
#line 356 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 128:
#line 357 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 129:
#line 358 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 130:
#line 359 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 131:
#line 360 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 132:
#line 366 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 133:
#line 367 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 134:
#line 368 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 135:
#line 369 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 136:
#line 370 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 137:
#line 371 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 138:
#line 372 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 139:
#line 373 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 140:
#line 374 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 141:
#line 375 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 142:
#line 378 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), NOADD); ;}
    break;

  case 143:
#line 379 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 144:
#line 380 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 145:
#line 381 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 146:
#line 382 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 147:
#line 383 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 148:
#line 384 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 149:
#line 385 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 150:
#line 386 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 151:
#line 387 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 152:
#line 392 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 153:
#line 393 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 154:
#line 394 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 155:
#line 395 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 156:
#line 396 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 157:
#line 397 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 158:
#line 398 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 159:
#line 399 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 160:
#line 400 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 161:
#line 401 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 162:
#line 404 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), NOADD_R_DOT); ;}
    break;

  case 163:
#line 405 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), R_WRAP); ;}
    break;

  case 164:
#line 406 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), R_WRAP); ;}
    break;

  case 165:
#line 407 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_R_DOT); ;}
    break;

  case 166:
#line 408 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), R_WRAP); ;}
    break;

  case 167:
#line 409 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), R_WRAP); ;}
    break;

  case 168:
#line 410 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), R_DOT_DOUBLE); ;}
    break;

  case 169:
#line 411 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), R_WRAP); ;}
    break;

  case 170:
#line 412 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), R_WRAP); ;}
    break;

  case 171:
#line 413 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), R_WRAP); ;}
    break;

  case 172:
#line 416 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), NOADD); ;}
    break;

  case 173:
#line 417 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 174:
#line 418 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 175:
#line 419 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 176:
#line 420 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 177:
#line 421 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 178:
#line 422 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), APPEND_CHILL); ;}
    break;

  case 179:
#line 423 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 180:
#line 424 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 181:
#line 425 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2noadd((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 182:
#line 430 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 183:
#line 431 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 184:
#line 432 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 185:
#line 433 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 186:
#line 434 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 187:
#line 436 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 188:
#line 437 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 189:
#line 438 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 190:
#line 439 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 191:
#line 440 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 192:
#line 442 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 193:
#line 443 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 194:
#line 444 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 195:
#line 445 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 196:
#line 446 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 197:
#line 448 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 198:
#line 449 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 199:
#line 450 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 200:
#line 451 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 201:
#line 452 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 202:
#line 454 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 203:
#line 455 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 204:
#line 456 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 205:
#line 457 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 206:
#line 458 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 207:
#line 460 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 208:
#line 461 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 209:
#line 462 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 210:
#line 463 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 211:
#line 464 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 212:
#line 466 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 213:
#line 467 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 214:
#line 468 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 215:
#line 469 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 216:
#line 470 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 217:
#line 472 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 218:
#line 473 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 219:
#line 474 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 220:
#line 475 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 221:
#line 476 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 222:
#line 478 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 223:
#line 479 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 224:
#line 480 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 225:
#line 481 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 226:
#line 482 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 227:
#line 484 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 228:
#line 485 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 229:
#line 486 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 230:
#line 487 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 231:
#line 488 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 232:
#line 493 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 233:
#line 494 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 234:
#line 495 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 235:
#line 496 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 236:
#line 497 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 237:
#line 498 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 238:
#line 499 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 239:
#line 500 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 240:
#line 501 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), POSSIBLE_DOUBLE); ;}
    break;

  case 241:
#line 502 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 242:
#line 507 "mal.y"
    { RULE_DUMP  (yyval.pair) = create_syllable((yyvsp[(1) - (1)].val), ADDABLE); ;}
    break;

  case 243:
#line 508 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 244:
#line 509 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), SAMVRUTHO); ;}
    break;

  case 245:
#line 510 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 246:
#line 511 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 247:
#line 512 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), NONE); ;}
    break;

  case 248:
#line 513 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_noadd2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), BEFORE_R_DOT); ;}
    break;

  case 249:
#line 514 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 250:
#line 515 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), WRAP); ;}
    break;

  case 251:
#line 516 "mal.y"
    { RULE_DUMP  (yyval.pair) = append_syllable_add2add((yyvsp[(1) - (2)].pair), (yyvsp[(2) - (2)].val), POSSIBLE_DOUBLE); ;}
    break;


/* Line 1267 of yacc.c.  */
#line 3128 "mal.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


#line 518 "mal.y"



STRPAIR create_syllable(UINT index,  CREATE_MODE mode)
{
     STRPAIR p = NULL;

     switch (mode)
     {
     case ADDABLE:
          p = strpair_create(NULL, map[index][MAIN]);        
          break;

     case LEFT_ONLY:
          p = strpair_create(NULL, map[index][LEFT]);        
          break;

     case RIGHT_ONLY:
          p = strpair_create(NULL, map[index][RIGHT]);        
          break;

     case NOADD:
          if (HAVE_CHILL(index))
          {
               p = strpair_create(map[index][CHILL], NULL);
          }
          else
          {
               p = strpair_create(map[index][MAIN], map[samindex][MAIN] );  
               strpair_str_mix(p, NULL, AA_S);
          }
          break;

     case NOADD_R_DOT:
          if (CAN_R_DOT(index))
          {
               p = strpair_create(NULL, map[index][R_DOT]);
          }
          else
          {
               p = create_syllable(index, NOADD);
          }
          break;

     default:
          break;
     }

     return p;
}

STRPAIR append_syllable_noadd2noadd(STRPAIR p, UINT secindex, APPEND_MODE mode)
{
     switch (mode)
     {
     case APPEND_CHILL:
          if (HAVE_CHILL(secindex))
          {
               strpair_str_mix(p, map[secindex][CHILL], AA_S);
               strpair_str_mix(p, NULL, AA_S);
          }
          else
          {
               strpair_str_mix(p, map[secindex][MAIN], AA_S);
               strpair_str_mix(p, map[samindex][MAIN], AA_S);
               strpair_str_mix(p, NULL, AA_S);
          }
          break;

     case BEFORE_R_DOT:
          if (HAVE_CHILL(secindex))
          {
               strpair_str_mix(p, map[secindex][CHILL], A_SA);
               strpair_str_mix(p, NULL, AA_S);
          }
          else
          {
               strpair_str_mix(p, map[secindex][MAIN], A_SA);
               strpair_str_mix(p, map[samindex][MAIN], AA_S);
               strpair_str_mix(p, NULL, AA_S);
          }
          break;

     case APPEND_R_DOT:
          if (CAN_R_DOT(secindex))
          {
               strpair_str_mix(p, map[secindex][R_DOT], AA_S);
          }
          else
          {
               p = append_syllable_noadd2noadd(p, secindex, APPEND_CHILL);
          }
          break;

     default:
          break;
     }

     return p;
}

STRPAIR append_syllable_add2noadd(STRPAIR p, UINT secindex, APPEND_MODE mode)
{
     switch (mode)
     {
     case WRAP:
          if (HAVE_PARTS(secindex))
          {
               strpair_str_mix(p, map[secindex][LEFT], A_SA );
               strpair_str_mix(p, map[secindex][RIGHT], A_AS );
               strpair_str_mix(p, map[samindex][MAIN], AA_S);
               strpair_str_mix(p, NULL, AA_S);
          }
          else
          {
               p = append_syllable_add2noadd(p, secindex, APPEND_CHILL);
          }
          break;

     case APPEND_CHILL:
          if (HAVE_CHILL(secindex))
          {
               strpair_str_mix(p, map[samindex][MAIN], AA_S);
               strpair_str_mix(p, map[secindex][CHILL], AA_S);
               strpair_str_mix(p, NULL, AA_S);
          }
          else
          {
               p = append_syllable_add2noadd(p, secindex, SAMVRUTHO);
          }
          break;

     case R_WRAP:
          if (! HAVE_PARTS(secindex) && CAN_R_DOT(secindex))
          {
               strpair_str_mix(p, map[samindex][MAIN], AA_S);
               strpair_str_mix(p, map[secindex][R_DOT], AA_S);
          }
          else
          {
               p = append_syllable_add2noadd(p, secindex, WRAP);
          }
          break;

     case R_DOT_DOUBLE:
          if (CAN_R_DOT(secindex))
          {
               strpair_str_mix(p, map[samindex][MAIN], AA_S);
               strpair_str_mix(p, map[secindex][R_DOT], AA_S);
          }
          else
          {
               p = append_syllable_add2noadd(p, secindex, APPEND_CHILL);
          }
          break;

     case SAMVRUTHO:
          strpair_str_mix(p, map[samindex][MAIN], AA_S);
          strpair_str_mix(p, map[secindex][MAIN], AA_S);
          strpair_str_mix(p, map[samindex][MAIN], AA_S);
          strpair_str_mix(p, NULL, AA_S);
          break;

     case POSSIBLE_DOUBLE:
          if (0 == strpair_str_cmp( p, map[secindex][MAIN], RIGHT))
          {
               p = append_syllable_add2noadd(p, secindex, APPEND_CHILL);
          }
          else
          {
               p = append_syllable_add2noadd(p, secindex, WRAP);
          }

     default:
          break;
     }

     return p;
}

STRPAIR append_syllable_noadd2add(STRPAIR p, UINT secindex, APPEND_MODE mode)
{
     switch (mode)
     {
     case BEFORE_R_DOT:
          strpair_str_mix(p, map[secindex][MAIN], A_SA);
          break;

     case NONE:
     default:
          strpair_str_mix(p, map[secindex][MAIN], AA_S);
          break;
     }

     return p;
}


STRPAIR append_syllable_add2add(STRPAIR p, UINT secindex, APPEND_MODE mode)
{
     BOOLEAN append_with_samvrutho_first;

     switch (mode)
     {
     case POSSIBLE_DOUBLE:
          append_with_samvrutho_first =
               (0 == strpair_str_cmp( p, map[secindex][MAIN], RIGHT));
          break;

     case SAMVRUTHO:
          append_with_samvrutho_first = TRUE;
          break;

     case NONE:
          strpair_str_mix(p, map[secindex][MAIN], AA_S);
          return p;
          break;

     case WRAP_ELONG:
          strpair_str_mix( p, map[secindex][ELONG], A_AS);
          return p;
          break;

     case WRAP:
     default:
          append_with_samvrutho_first = FALSE;
          break;
     }

     if (!append_with_samvrutho_first && HAVE_PARTS(secindex))
     {
          strpair_str_mix( p, map[secindex][LEFT], A_SA );
          strpair_str_mix( p, map[secindex][RIGHT], A_AS );
     }
     else
     {
          strpair_str_mix(p, map[samindex][MAIN], AA_S);
          strpair_str_mix(p, map[secindex][MAIN], AA_S);
     }
     return p;
}

STRLIST create_nonsyllable(UINT index,  COMPONENT mode)
{
     switch (mode)
     {
     case LEFT:
          return strlist_create(map[index][LEFT], RO_STR, &status);        
          break;

     case RIGHT:
          return strlist_create(map[index][RIGHT], RO_STR, &status);        
          break;

     case MAIN:
          return strlist_create(map[index][MAIN], RO_STR, &status);        
          break;

     default:
          return NULL;
          break;
     }
}

STRLIST extern_fn(STRLIST slist, EXTERN_TRANS_FN func)
{
     STATUS status;
     UCHAR *str, *newstr;
     int   len,  newlen;

     if (func != NULL)
     {
          str = strlist_str_get(slist);
          len = strlist_len(slist);
          (*func)(str, len, &newstr, &newlen); /* ignore error */
          status = strlist_replace(slist, newstr, newlen, RW_STR);
     }

     return slist;
}

char* mal_parse(char* mal_in_text, long flags)
{

     struct yy_buffer_state *buffer_state;

     allowRdot    = (flags & FL_ALLOW_RDOT)    ? TRUE : FALSE;
     carrycomment = (flags & FL_CARRY_COMMENT) ? TRUE : FALSE;
     processmacro = (flags & FL_PROCESS_MACRO) ? TRUE : FALSE;
     debug        = (flags & FL_DEBUG)         ? TRUE : FALSE;

     /* macro processing */
     if ( processmacro )
     {
          /* phase 1 */

          buffer_state = macro_scan_bytes( mal_in_text,
                                           strlen(mal_in_text) + 1 );

          halfcooked = str_create("", RO_STR, &status);


          macro_switch_to_buffer( buffer_state );
          while( macrolex());
          macro_delete_buffer( buffer_state );


          if (debug)
          {
               char *halfcooked_str = str_get_data( halfcooked );
               if (strcmp(halfcooked_str, "\n") != 0)
               {
                    fprintf(stderr, "text-substitution output: %s", halfcooked_str);
               }
          }

#if 0

          /* phase 2 */

          /*  second pass spoils # functionality */

          /* if second pass is really required,
           * we can introduce a global variable and
           * prevent # getting removed in the first pass */

          buffer_state = macro_scan_bytes( str_get_data( halfcooked ),
                                           str_get_len( halfcooked ) + 1 );

          str_free( halfcooked );
          halfcooked = str_create("", RO_STR, &status);


          macro_switch_to_buffer( buffer_state );
          while( macrolex());
          macro_delete_buffer( buffer_state );

#endif /* 0 */


          buffer_state = yy_scan_bytes( str_get_data( halfcooked ),
                                        str_get_len( halfcooked ) + 1 );
          str_free( halfcooked );
     }
     else
     {
          /* printf( "macro not processed\n" ); */
          buffer_state = yy_scan_bytes( mal_in_text,
                                        strlen(mal_in_text) + 1 );
     }

     /* font processing */

     dqcount = sqcount = 1;
     mal_out_text      = NULL;

     yy_switch_to_buffer( buffer_state );
     while (yyparse());
     yy_delete_buffer( buffer_state );


     return mal_out_text;
}

void yyerror( char msg[] )
{
          fprintf(stderr, "%s\n", msg);
}
          


