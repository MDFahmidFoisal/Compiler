%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<math.h>
    int data[60];

    void yyerror(const char *s);
%}

/* bison declarations */

%token NUM VAR IF ELSE MAIN INT FLOAT CHAR START END MAX MIN PF
%nonassoc IFX
%nonassoc ELSE
%left '<' '>'
%left '+' '-'
%left '*' '/'

%%

program: MAIN ':' START cstatement END
     ;

cstatement: /* NULL */
    | cstatement statement
    ;

statement: ';'           
    | declaration ';'       { printf("Declaration\n"); }

    | expression ';'            {   printf("value of expression: %d\n", $1); $$=$1;}
    
    | VAR '=' expression ';' { 
                            data[$1] = $3; 
                            printf("Value of the variable: %d\t\n",$3);
                            $$=$3;
                        } 
   
    | IF '(' expression ')' START expression ';' END %prec IFX {
                                if($3){
                                    printf("\nvalue of expression in IF: %d\n",$6);
                                }
                                else{
                                    printf("condition value zero in IF block\n");
                                }
                            }

    | IF '(' expression ')' START expression ';' END ELSE START expression ';' END {
                                if($3){
                                    printf("value of expression in IF: %d\n",$6);
                                }
                                else{
                                    printf("value of expression in ELSE: %d\n",$11);
                                }
                            }
    | PF '(' expression ')' ';' {printf("Print Expression %d\n",$3);}
    ;
    
declaration : TYPE ID1   
             ;


TYPE : INT   
     | FLOAT  
     | CHAR   
     ;



ID1 : ID1 ',' VAR  
    |VAR  
    ;

expression: NUM                    { $$ = $1;    }

    | VAR                        { $$ = data[$1]; }
    
    | expression '+' expression    { $$ = $1 + $3; }

    | expression '-' expression    { $$ = $1 - $3; }

    | expression '*' expression    { $$ = $1 * $3; }

    | expression '/' expression    { if($3){
                                        $$ = $1 / $3;
                                    }
                                    else{
                                        $$ = 0;
                                        printf("\ndivision by zero\t");
                                    }   
                                }
    | expression '%' expression    { if($3){
                                        $$ = $1 % $3;
                                    }
                                    else{
                                        $$ = 0;
                                        printf("\nMOD by zero\t");
                                    }   
                                }
    | expression '^' expression    { $$ = pow($1 , $3);}
    | expression '<' expression    { $$ = $1 < $3; }
    
    | expression '>' expression    { $$ = $1 > $3; }

    | '(' expression ')'        { $$ = $2;    }
    | MAX '(' expression ',' expression ')'    { $$ = ($3 > $5) ? $3 : $5; }
    | MIN '(' expression ',' expression ')'    { $$ = ($3 < $5) ? $3 : $5; }
    ;
%%


void yyerror(const char *s){
    fprintf(stderr, "%s\n", s);
}
