%{ 

	#include <stdio.h>
	#define YY_DECL int yylex()
	#include "bison.tab.h" 
 
%}

%option noyywrap

 
%%

"ls"			{return C_LS;}//--------Lista o conteúdo do diretório atual
"ps"			{return C_PS;}//--------Lista todos os processos do usuário
"quit"			{return C_QUIT;}//------Encerra o shell


[ \t]        			;//---------------------Ignore	
\n						{return T_NEWLINE;}//--- To line break
[~a-zA-Z0-9\.-]*		{yylval.text = (yytext); return C_ID;}//-------- Type input String


%%