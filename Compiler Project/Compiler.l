%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include "sun.tab.h"
%}

alpha [a-zA-Z]
digit [0-9]
header                  "import"[ ]*+[^\n]+[.h][ ]*
keyWord                 IF|ELSE|RETURN|INTEGER|FLOAT|CHAR|PF|MAX|MIN
singleLineComment       [ ]*[#][#][a-zA-Z0-9@$%^&*(){}_+-,.:\|?>< ]*
multipleLineComment     [ ]*[!][#][a-zA-Z0-9@$*(){}_+-,.:\|?><\n\t ]*[#][!]    

%%

{digit}+    { yylval = atoi(yytext); return NUM; }
{alpha}     { yylval = *yytext - 'a'; return    VAR; }

IF                  { return IF;   }
ELSE                { return ELSE; }
"{"                 { return START;  }
"}"                 { return END;    }
MAX                 { return MAX; }
MIN                 { return MIN; }
PF                  { return PF; }
"("                 { return '('; }
")"                 { return ')'; }
";"                 { return ';'; }
","                 { return ','; }
"="                 { return '='; }
INTEGER             { return INT; }
CHAR                { return CHAR; }
FLOAT               { return FLOAT; }
"main"              { return MAIN; }
[ ]*                {}
[\n]*               {}
[\t]*               {}
.                   {printf("%s --> invalid\n",yytext);}


%%
int yywrap()
{
    return 1;
}

int main()
{
    freopen("input.txt","r",stdin);
    freopen("out2.txt","w",stdout);
    yyparse();
    
    return 0;
}
