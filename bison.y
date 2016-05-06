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

%token<integer> S_INT
%token<pFloat> S_FLOAT

%token S_LS
%token S_PS
%token S_CD
%token S_KILL
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

%token S_PLUS
%token S_MINUS

%left S_PLUS
%left S_MINUS

%token S_ID
%token S_NEWLINE

%type<integer> expression
%type<pFloat> float_expression
%type<string> comand
%type<text> S_ID

%start soldishell

%%

soldishell: 
	   | soldishell line										
;

line: 
	S_NEWLINE	{ 
		start();
	}
	
	| 

	expression S_NEWLINE  { 
		printf("\n\nValor = %i \n\n\n", $1); 
		start();
	} 

	|

	float_expression S_NEWLINE{
		printf("\n\nValor = %f \n\n\n", $1); 
		start();
	}

	| 

	comand S_NEWLINE { 
		start();
	}
		  						
;

comand:  
		//Comando LS
		S_LS { 
			$$ = system("/bin/ls"); 
		}

		|

		// Comando PS
		S_PS { 
			$$ = system("/bin/ps"); 
		}

		| 

		// Comando CD
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

	   	// Comando KILL
	   	S_KILL S_ID {
	   		char comand[2048] = "kill "; 
			$$ = system(strcat(comand,$2));
	   	}

		| 

		// Comando TREE
		S_TREE { 
			$$ = system("tree");
		}

		| 

		// Comando RMDIR
		S_RMDIR S_ID { 
			//Testei sem criar essa variavel, 
			// porem nao funciona porque eh necessario alocar espaco de memoria
			char comand[2048] = "/bin/rmdir "; 	
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
		S_QUIT S_NEWLINE { 
			printf("Terminating Soldishell\n"); 
			exit(0); 
		}

		| 

		// Comando CLEAR
		S_CLEAR { 
			$$ = system("clear");  
		}
;

expression: 
	S_INT {
		printf("SOLDI\n");
		$$ = $1; 
	}

	|

	expression S_PLUS expression{
		$$ = $1 + $3;
	}

	|

	expression S_MINUS expression{
		$$ = $1 - $3;
	}
;

float_expression:
	S_FLOAT {
		$$ = $1;
	}

	|

	float_expression S_PLUS float_expression {
		$$ = $1 + $3;
	}

	|

	float_expression S_MINUS float_expression {
		$$ = $1 + $3;
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

