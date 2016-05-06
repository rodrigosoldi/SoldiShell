%{ 

	#include <stdio.h>
	#define YY_DECL int yylex()
	#include "bison.tab.h" 
 
%}

%option noyywrap
 
%%


"ls" {
	return S_LS; //--------Lista o conteúdo do diretório atual
}

"ps" {
	return S_PS; //--------Lista todos os processos do usuário
}

"cd" {
	return S_CD; //--------Entra em um diretorio
}

"kill"	{
	return S_KILL; //------Fecha um processo
}

"tree" {
	return S_TREE; //------Lista em forma de arvore
}

"mkdir"	{
	return S_MKDIR; //-----Cria um diretorio
}

"rmdir" {
	return S_RMDIR; //-----Remove o diretório 
}

"rm" {
	return S_RM; //-------Remove um arquivo
}	

"ifconfig" {
	return S_IFCONFIG; //--Exibe as informações de todas as interfaces de rede do sistema
}

"start"	{
	return S_START; //-----Invoca a execução do programa id
}

"echo" {
	return S_ECHO; //-----Imprime uma string na tela
}

"touch"	{
	return S_TOUCH; //-----Cria um arquivo com o nome id
}

"quit" {
	return S_QUIT; //------Encerra o shell
}

"clear" {
	return S_CLEAR; //-----Limpa o terminal
}


[ \t]        			;//---------------------Ignore	
\n						{return T_NEWLINE;}//--- To line break
[~a-zA-Z0-9\.-]*		{yylval.text = (yytext); return S_ID;}//-------- Type input String


%%