%{
#include <stdio.h>
#include "Variables.h"

%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_NUM TOK_PRINT
 token TOK_START TOK_END TOK_MAIN TOK_FLOAT TOK_EQUAL TOK_ID
       TOK_PAREN_START TOK_PAREN_END
%union{
        float float_val;
        char* string_val;
}

/*%type <int_val> expr TOK_NUM*/
%type <float_val> expr TOK_NUM
%type <string_val> name TOK_ID


%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%

prog:
    |TOK_MAIN TOK_START stmts TOK_END
;
stmts:
    | stmt TOK_SEMICOLON stmts
;
stmt:
    | TOK_FLOAT name { newVariable($2,0.0,VarTypeDefault);}
    | name TOK_EQUAL expr {updateVariable($1,$3);}
    | TOK_PRINT name  {
        float value = getValueOfName($2);
        fprintf(stdout, "the %s is %.2f\n", $2, value);}
    | TOK_START stmts TOK_END
;

name:
    |TOK_ID {$$ = $1;}
;

expr:
    |TOK_NUM { $$ = $1; }
    |TOK_ID { $$ = getValueOfName($1); }
	|expr TOK_ADD expr
	  {
		$$ = $1 + $3;
	  }
	| expr TOK_SUB expr
	  {
		$$ = $1 - $3;
	  }
	| expr TOK_MUL expr
	  {
		$$ = $1 * $3;
	  }
	| expr TOK_DIV expr
	  {
		$$ = $1 * 1.0/ $3;
	  }

;

%%

int yyerror(char *s)
{
	printf("syntax error\n");
	return 0;
}

int main()
{
   yyparse();
   return 0;
}
