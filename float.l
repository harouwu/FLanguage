%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "float.tab.h"
	int varindex(char * var);
%}

%%

FLOAT32			{return FLOAT32;}

FLOAT64			{return FLOAT64;}

[ \t]			;

[0-9]+			{yylval.dval = atoi(yytext); return INT;}

[0-9]+\.[0-9]+	{yylval.dval = atof(yytext); return FLOAT;}

[-+()=/*\n]		{return *yytext;}

[a-z]			{yylval.ivar = varindex(yytext); return VARIABLE;}

.				{;}

%%

int yywrap(void) {
	return 1;
}