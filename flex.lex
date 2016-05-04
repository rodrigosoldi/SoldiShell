%{ 

	#include <stdio.h>
	#define YY_DECL int yylex()
	#include "bison.tab.h" 
 
%}

%option noyywrap
 
%%

"ls"			{return S_LS;}//--------Lista o conteúdo do diretório atual
"ps"			{return S_PS;}//--------Lista todos os processos do usuário
"tree"			{return S_TREE;}//------Lista em forma de arvore
"ifconfig"		{return S_IFCONFIG;}//--Exibe as informações de todas as interfaces de rede do sistema
"touch"			{return S_TOUCH;}//-----Cria um arquivo com o nome id
"quit"			{return S_QUIT;}//------Encerra o shell


[ \t]        			;//---------------------Ignore	
\n						{return T_NEWLINE;}//--- To line break
[~a-zA-Z0-9\.-]*		{yylval.text = (yytext); return S_ID;}//-------- Type input String


%%