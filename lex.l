%{

#include <stdlib.h>
#include "syntax.tab.h"

void yyerror(char *);
void add_buff(char *);

double FLOAT;

%}

%%

[a-z]        { yylval.sval = strdup(yytext); add_buff(yytext);  return VAR; }

[0-9]*\.[0-9]+"f"?	{ yylval.fval = atof(yytext); add_buff(yytext); return FLOAT; }

[-+()=*/]    { yylval.sval = strdup(yytext); add_buff(yytext); return *yytext; }

[\n]         ;

[\t]         ;/* 去除空格 */

.            yyerror("无效字符");

%%

void add_buff(char * buff) {
}

int yywrap(void) {
	return 1;
}