%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int yylex();

#define NVARS 100
char *vars[NVARS]; double vals[NVARS]; int IsvalsDouble[NVARS]; int Isvals64[NVARS];

int nvars=0;

int IsTermDouble = 0;
int IsMuldivDouble = 0;
int IsExprDouble = 0;

%}

%union { double dval; int ivar; }
%token <dval> FLOAT
%token <dval> INT; 
%token <ivar> VARIABLE
%token <ivar> FLOAT32;
%token <ivar> FLOAT64;
%type <dval> expr
%type <dval> muldiv
%type <dval> term


%%
program
	: statement program
	|
	;
statement
	: expr '\n'					{ printf("%g\n",$1); IsExprDouble = 0; } 
	| FLOAT32 VARIABLE '=' expr '\n' 	{ printf("Variable Update: %g, it is a 32 float\n", $4); vals[$2] = $4; IsvalsDouble[$2] = IsExprDouble; Isvals64[$2] = 0;} 
	| FLOAT64 VARIABLE '=' expr '\n' 	{ printf("Variable Update: %g, it is a 64 float\n", $4); vals[$2] = $4; IsvalsDouble[$2] = IsExprDouble; Isvals64[$2] = 1;} 
	;

expr
	: expr '+' muldiv {  if(IsMuldivDouble == 1) IsExprDouble = 1; if(IsMuldivDouble == 0){int c1 = $1; int c2 = $3; $$ = c1 + c2;} else $$ = $1 + $3; }
	| expr '-' muldiv { if(IsMuldivDouble == 1) IsExprDouble = 1; if(IsMuldivDouble == 0){int c1 = $1; int c2 = $3; $$ = c1 - c2;} else $$ = $1 - $3; }
	| muldiv { if(IsMuldivDouble == 1) IsExprDouble = 1;$$ = $1; }
	;
muldiv
	: muldiv '*' term { if(IsTermDouble == 1) IsMuldivDouble = 1; if(IsMuldivDouble == 0){int c1 = $1; int c2 = $3; $$ = c1*c2;} else $$ = $1 * $3; }
	| muldiv '/' term { if(IsTermDouble == 1) IsMuldivDouble = 1; if(IsMuldivDouble == 0){int c1 = $1; int c2 = $3; $$ = (c1/c2);} else $$ = $1 / $3;; }
	| term { if(IsTermDouble == 1) IsMuldivDouble = 1; $$ = $1; }
	;
term
	: '(' expr ')' { $$ = $2; IsTermDouble = IsExprDouble; }
	| VARIABLE {  $$ = vals[$1]; IsTermDouble = IsvalsDouble[$1];  }
	| FLOAT { $$ = $1;IsTermDouble = 1; }
;
%%


int varindex(char *varname)
{
int i;
for (i=0; i<nvars; i++)
if (strcmp(varname,vars[i])==0)
return i;
vars[nvars] = strdup(varname);
return nvars++;
}
int yyerror(char *s) {
    printf("%s\n", s);
}
int main(void)
{
yyparse();
return 0;
}