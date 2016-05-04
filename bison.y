%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void start(){
	char directory[8196];
	getcwd(directory, sizeof(directory));
	strcat(directory,"$ ");
	printf("Soldishell:~%s",directory);
}

void yyerror(const char* s);
%}

%union {
	int integer;
	float pFloat;
	char string;
	char* text;
}

%token<integer> T_INT
%token<pFloat> T_FLOAT

%token S_LS
%token S_PS 
%token S_IFCONFIG
%token S_QUIT 

%token S_ID
%token T_NEWLINE

%type<string> comand
%type<text> S_ID
%start soldishell

%%

soldishell: 
	   | soldishell line										
;

line: T_NEWLINE												{ start();}
		  | comand T_NEWLINE								{ start();}		  						
;

comand:  S_LS 									{ $$ = system("/bin/ls"); }
		| S_PS									{ $$ = system("/bin/ps"); }
		| S_IFCONFIG 							{ $$ = system("ifconfig"); }
		| S_QUIT T_NEWLINE 						{ printf("Terminating Soldishell\n"); exit(0); }
;

%%

int main() {
	yyin = stdin;
	start();
	do { 
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "comando invalido: %s\n", s);
}

