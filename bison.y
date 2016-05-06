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
%token S_CD
%token S_RM
%token S_TREE 
%token S_RMDIR
%token S_MKDIR
%token S_IFCONFIG
%token S_TOUCH
%token S_START
%token S_ECHO
%token S_QUIT
%token S_CLEAR 

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


comand:  
		//Comando LS
		S_LS { 
			$$ = system("/bin/ls"); 
		}

		|

		//Comando PS
		S_PS { 
			$$ = system("/bin/ps"); 
		}

		| 

		//Comando CD
		S_CD S_ID 	{ 
			char comand[2048];
		  	int isValidComand;
		 	int aux = strcmp("..",$2); // Comparando se eh pra voltar uma pasta
			int aux2 = strcmp("~",$2); // Comparando se eh pra ir para a root

			if(aux == 0){ // Se o usuario estiver tentando voltar um nivel na hierarquia
				isValidComand = chdir($2);
			}else if(aux2 == 0){ // Se o usuario estiver tentando ir para o root folder
				isValidComand = chdir("/home");
			}else{
				getcwd(comand, sizeof(comand));
	   			strcat(comand,"/");
	   			strcat(comand,$2); // result /~ 
	   			isValidComand = chdir(comand);
	   		}
	   											  
	   		if(isValidComand != 0){
				printf("Diretorio %s nao encontrado, ou invalido\n",$2);
				system("/bin/ls"); // Para listar os diretorios disponiveis
	   		}
	   	}

		| 

		// Comando TREE
		S_TREE { 
			$$ = system("tree");
		}

		| 

		// Comando RMDIR
		S_RMDIR S_ID { 
			char comand[2048] = "/bin/rmdir "; 	//Testei sem criar essa variavel, porem nao funciona porque eh necessario alocar espaco de memoria
			$$ = system(strcat(comand,$2)); 
		}

		| 

		// Comando MKDIR
		S_MKDIR S_ID { 
			char comand[2048] = "/bin/mkdir "; 	//Idem acima
			$$ = system(strcat(comand,$2)); 
		}

		| 

		// Comando IFCONFIG
		S_IFCONFIG 	{ 
			$$ = system("ifconfig"); 
		}

		| 

		// Comando RM
		S_RM S_ID {
			char comand[2048] = "/bin/rm "; 
			$$ = system(strcat(comand,$2));
		}

		| 

		//Comando TOUCH
		S_TOUCH S_ID { 
			char comand[2048] = "/bin/touch "; 	
			$$ = system(strcat(comand,$2)); 
		}

		| 

		// Comando ECHO
		S_ECHO S_ID { 
			char comand[2048] = "/bin/echo "; 	
												  $$ = system(strcat(comand,$2)); 
		}

		| 

		// Comando START
		S_START S_ID { 
			$$ = system(strcat($2,"&"));  // & no fim para tornar o shell independente da aplicacao
		}

		| 

		// Comando QUIT
		S_QUIT T_NEWLINE { 
			printf("Terminating Soldishell\n"); 
			exit(0); 
		}

		| 

		// Comando CLEAR
		S_CLEAR { 
			$$ = system("clear");  
		}
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

