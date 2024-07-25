%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "syntaxique.tab.h"
#include "table.h"
extern col ;
extern nb_ligne;
extern YYSTYPE yylval;

bool traduireBool(char entite[]) {
    if (strcmp(entite, "TRUE") == 0) {
        return 1;
    } else if (strcmp(entite, "FALSE") == 0) {
        return 0;
    }
}

%}

lettrem [a-z]
lettreM [A-Z]
chiffre [0-9]
IDF ({lettrem}|{lettreM})({lettrem}|{lettreM}|{chiffre})* 
INTEGER -?{chiffre}+
BL ("TRUE"|"FALSE")
REAL {INTEGER}+"."{INTEGER}+
%%
{INTEGER}    {col = col + strlen(yytext);
			   if (atoi(yytext)<32767 && atoi(yytext)>-32768){
				  rechercher(yytext,"CST INTEGER","INTEGER",atoi(yytext), 0); 
				  yylval.INTEGER=atoi(yytext);
                  return cst_int;
			    }
			   else{
				printf("Warning: La valeur de l'entier a depasse l'intervalle des valeurs possibles a la ligne %d a la colonne %d \n", nb_ligne, col);
			    }
		    }
{REAL}      { rechercher(yytext,"CST REAL","REAL",atof(yytext), 0);    yylval.REAL=atof(yytext);             return cst_real;  }
{BL}        { rechercher(yytext,"LOGICAL","LOGICAL",atoi(yytext), 0);  yylval.LOGICAL=traduireBool(yytext);  return mc_bl;     }
INTEGER     { rechercher(yytext,"Mot Cle","",0,1);                     yylval.str=strdup(yytext);            return mc_int;    }
REAL        { rechercher(yytext,"Mot Cle","",0,1);                     yylval.str=strdup(yytext);            return mc_real;   }
LOGICAL     { rechercher(yytext,"Mot Cle","",0,1);                     yylval.str=strdup(yytext);			 return mc_logical;}
CHARACTER   { rechercher(yytext,"Mot Cle","",0,1);					   yylval.str=strdup(yytext);			 return mc_char;   }
DIMENSION   { rechercher(yytext,"Mot Cle","",0,1);					   yylval.str=strdup(yytext);			 return mc_dim;    }
PROGRAM     { rechercher(yytext,"Mot Cle","",0,1);         return mc_pgm;     }
ROUTINE     { rechercher(yytext,"Mot Cle","",0,1);         return mc_rout;    }
WRITE       { rechercher(yytext,"Mot Cle","",0,1); 		   return mc_write;   }
READ        { rechercher(yytext,"Mot Cle","",0,1);         return mc_read;    }
IF          { rechercher(yytext,"Mot Cle","",0,1); 	       return mc_if;      }
THEN        { rechercher(yytext,"Mot Cle","",0,1);         return mc_then;    }
ELSE        { rechercher(yytext,"Mot Cle","",0,1);         return mc_else;    }
ENDIF       { rechercher(yytext,"Mot Cle","",0,1);         return mc_endif;   }
DOWHILE     { rechercher(yytext,"Mot Cle","",0,1);         return mc_dowhile; }
ENDDO       { rechercher(yytext,"Mot Cle","",0,1);         return mc_enddo;   }
EQUIVALENCE { rechercher(yytext,"Mot Cle","",0,1);         return mc_eqv;     }
ENDR        { rechercher(yytext,"Mot Cle","",0,1);         return mc_endr;    }
CALL        { rechercher(yytext,"Mot Cle","",0,1);         return mc_call;    }
END         { rechercher(yytext,"Mot Cle","",0,1);         return mc_end;     }
"("         { rechercher(yytext,"(","",0,2);               return paro;       }
"="         { rechercher(yytext,"=","",0,2);               return egl;        }
")" 		{ rechercher(yytext,")","",0,2); 			   return parf;       }
"," 		{ rechercher(yytext,",","",0,2); 			   return vrg;        }
";" 		{ rechercher(yytext,";","",0,2); 			   return pvg;        }
"." 		{ rechercher(yytext,".","",0,2); 			   return point;	  }
"+" 		{ rechercher(yytext,"+","",0,2); 			   return plus;		  }
"-" 		{ rechercher(yytext,"-","",0,2); 			   return moins;	  }
"*" 		{ rechercher(yytext,"*","",0,2); 			   return mult;	 	  }
"/" 		{ rechercher(yytext,"/","",0,2); 			   return mc_div;	  }
OR 			{ rechercher(yytext,"||","",0,2); 			   yylval.str=strdup(yytext);			return or;}
AND 		{ rechercher(yytext,"&&","",0,2); 			   yylval.str=strdup(yytext);			return and;}
GT 			{ rechercher(yytext,">","",0,2); 			   yylval.str=strdup(yytext);			return gt;}
GE 			{ rechercher(yytext,">=","",0,2); 			   yylval.str=strdup(yytext);			return ge;}
EQ 			{ rechercher(yytext,"==","",0,2); 			   yylval.str=strdup(yytext);			return eq;}
NE 			{ rechercher(yytext,"!=","",0,2); 			   yylval.str=strdup(yytext);			return ne;}
LE 			{ rechercher(yytext,"<=","",0,2); 			   yylval.str=strdup(yytext);			return le;}
LT 			{ rechercher(yytext,"<","",0,2); 			   yylval.str=strdup(yytext);			return lt;}
{IDF} 		{ col = col + strlen(yytext);
   				if (yyleng > 10) printf("Warning: IDF de longueur superieure a 10 a la ligne %d a la colonne %d \n", nb_ligne, col);
   				else{
					rechercher(yytext,"IDF","",0, 0); 
					yylval.str=strdup(yytext);
        			return idf;
				}
            }
\"[^\"]*\"  { yylval.str=strdup(yytext); return mc_chaine;           }
[ \t]       { col = col + strlen(yytext); }
\n          { col = 1; nb_ligne++;        }
. {printf("file \"Test_MAMI_ANFEL_ANANE_DALIA.txt\" , ligne %d , character %d : syntax error  \n", nb_ligne, col); col = col + strlen(yytext);}
%%


