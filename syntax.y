%{

#include <stdlib.h>
#include <stdio.h>

int yylex(void);
void yyerror(char *);

double sMem[256];
%}

%token INT FLOAT VAR
%left '+' '-'
%left '*' '/'

%union {
    int ival;
    float fval;
    char *sval;
}
%token INT
%token FLOAT
%token VAR


%%
program
        : program statement
        |
        ;

statement
        : expr              {   }
        | VAR '=' expr      { sMem[$1]=$3;}
        | statement '\n'    {   }
        ;

expr
        : FLOAT         { $$ = $1;  }
        | VAR           { $$ = sMem[$1]; }
        | expr '*' expr { $$ = $1 * $3; }
        | expr '/' expr { $$ = $1 / $3; }
        | expr '+' expr { $$ = $1 + $3; }
        | expr '-' expr { $$ = $1 - $3; }
        | '(' expr ')'  { $$ = $2;     }
        ;

%%

void yyerror(char *s) {
    printf("%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}


