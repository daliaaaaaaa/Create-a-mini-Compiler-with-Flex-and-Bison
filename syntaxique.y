%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
int nb_ligne=1, col=1;  
char sauvType[25];
int sauvConst;
char sauvFunc[25];
bool Parametre;
int sauv;//pour sauvegarder le type dans expression E

int Fin_if=0;
int deb_else=0;
int qc=0;
int Fin=0;
int Fin_Cond[20];
int i=0;
int j=0;
char y[1] ;
int condWhile=0;
char tmp [20];
char tmpOP1 [20];

char sauvOpBool[6];
bool sauvBool;
char sauvIdf[10];
int Last;
int sauvConstint;
float sauvConstreal;
int OP1int;
float OP1real;

%}

%union{
	bool LOGICAL;
	float REAL;
	int INTEGER;
	char* str;
}
%token mc_pgm mc_call mc_rout vrg plus mc_end moins mult mc_div mc_endr <str>idf mc_if mc_then mc_else mc_endif mc_dowhile mc_enddo
mc_eqv <str>mc_chaine mc_read mc_write paro <LOGICAL>mc_bl point <INTEGER>cst_int <REAL>cst_real <str>or <str>and <str>gt <str>ge <str>eq <str>ne <str>le <str>lt mc_dim pvg 
<str>mc_int <str>mc_real <str>mc_logical <str>mc_char parf egl;
%start S
%type <str> type
%left mult
%left mc_div
%%
S:LISTE_FONCTION Programme { printf("Le programme est correct syntaxiquement\n"); YYACCEPT; }
;
LISTE_FONCTION:FONCTION LISTE_FONCTION 
               |FONCTION  
;
FONCTION:ligne1 LISTE_DECLARATION LISTE_INSTRUCTION mc_endr 
;
Programme:mc_pgm NOMFUNC  LISTE_DECLARATION LISTE_INSTRUCTION mc_end 
;
ligne1:type mc_rout idf {Parametre=true;} paro liste_par parf {strcpy(sauvFunc,$3); MajCodeEntite($3,$1);Parametre=false;} 
;
NOMFUNC:idf  {strcpy(sauvFunc,$1); MajCodeEntiteP(sauvFunc);} 
;
type :mc_int {strcpy(sauvType,$1);} 
     |mc_logical {strcpy(sauvType,$1);} 
     |mc_real {strcpy(sauvType,$1);} 
     |mc_char {strcpy(sauvType,$1);} 
;
cst:cst_int
   |cst_real
;
liste_par:VALEUR vrg liste_par
         |VALEUR
;
VALEUR:idf {if(Parametre==true) MajCodeParametre($1);}
      |idf paro LISTE_MAT parf {if(Parametre==true) MajCodeParametre($1);}
;

LISTE_DECLARATION:type DECLARATION pvg LISTE_DECLARATION 
                 |type DECLARATION pvg 
;
DECLARATION:idf mc_dim paro LISTE_MAT parf vrg DECLARATION {
														    if(doubleDeclaration($1)==0)
																insererTYPE($1,sauvType);
															if(insererFonction($1,sauvFunc,sauvType)>1){
																printf("Erreur Semantique: Double Declaration de la variable %s, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
															}else if(getCodeParametre($1)==0){
																	printf("Erreur Semantique: Double Declaration de la variable %s Qui est un Parametre de la fonction, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
																		
																	}
															}
		   |idf vrg DECLARATION {
									if(doubleDeclaration($1)==0)
										insererTYPE($1,sauvType);
									if(insererFonction($1,sauvFunc,sauvType)>1){
										printf("Erreur Semantique: Double Declaration de la variable %s, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
									}else if(getCodeParametre($1)==0){
											printf("Erreur Semantique: Double Declaration de la variable %s Qui est un Parametre de la fonction, dans la ligne %d colonne %d\n",$1,nb_ligne,col);	
											}
									}
		   |idf mult cst vrg DECLARATION {
											if(doubleDeclaration($1)==0)
												insererTYPE($1,sauvType);
											if(insererFonction($1,sauvFunc,sauvType)>1){
												printf("Erreur Semantique: Double Declaration de la variable %s, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
											}else if(getCodeParametre($1)==0){
													printf("Erreur Semantique: Double Declaration de la variable %s Qui est un Parametre de la fonction, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
														
													}
											}
		   |idf mc_dim paro LISTE_MAT parf {
											if(doubleDeclaration($1)==0)
												insererTYPE($1,sauvType);
											if(insererFonction($1,sauvFunc,sauvType)>1){
												printf("Erreur Semantique: Double Declaration de la variable %s, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
											}else if(getCodeParametre($1)==0){
													printf("Erreur Semantique: Double Declaration de la variable %s Qui est un Parametre de la fonction, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
														
													}
											}
		   |idf {
					if(doubleDeclaration($1)==0)
						insererTYPE($1,sauvType);
					if(insererFonction($1,sauvFunc,sauvType)>1){
						printf("Erreur Semantique: Double Declaration de la variable %s, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
					}else if(getCodeParametre($1)==0){
								printf("Erreur Semantique: Double Declaration de la variable %s Qui est un Parametre de la fonction, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
									
								}
					}
		   |idf mult cst {
							if(doubleDeclaration($1)==0)
								insererTYPE($1,sauvType,sauvType);
							if(insererFonction($1,sauvFunc)>1){
								printf("Erreur Semantique: Double Declaration de la variable %s, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
							}else if(getCodeParametre($1)==0){
								printf("Erreur Semantique: Double Declaration de la variable %s Qui est un Parametre de la fonction, dans la ligne %d colonne %d\n",$1,nb_ligne,col);
									
								}
							}
;
LISTE_MAT:LISTE_MAT:cst_int vrg cst_int {if($1<0 || $3<0) {printf("Erreur Semantique: Indice de la Matrice inferieur a 0 , a la ligne %d colonne %d\n",nb_ligne,col);}}
         |cst_int {if($1<0) {printf("Erreur Semantique: Indice du Tableau inferieur a 0, a la ligne %d colonne %d\n",nb_ligne,col);}}
;

LISTE_INSTRUCTION:INSTRUCTION LISTE_INSTRUCTION
                 |INSTRUCTION
;
INSTRUCTION:AFFECTATION pvg
           |ENTRER pvg
           |SORTIE pvg
           |CONDITION
           |BOUCLE pvg
           |EQUIVALENCE pvg
;
AFFECTATION:idf egl E { if (VariableNonDeclaree($1)==-1){
                             printf("Erreur semantique: Variable %s Non Declaree a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
                          } else{
                            if(sauv!=getType($1,sauvFunc)) {
                             printf("Erreur semantique: incompatibilite de type la ligne %d et a la colonne %d\n",nb_ligne,col);
                            }
                            else {
                              quadr("=",$1,"vide","RES");
                            }
                          }
                        
                      }
;
E: E  {if(Last==1){ OP1int=sauvConstint; sprintf(tmpOP1,"%d",sauvConstint);}
		else if(Last==2){ OP1real=sauvConstreal; sprintf(tmpOP1,"%d",sauvConstreal);}
			else if(Last==4) strcpy(tmpOP1,sauvIdf); 
		}
	plus T {if(Last==1) {sprintf(tmp,"%d",sauvConstint); quadr("+",tmpOP1,tmp,"RES");}
				else if(Last==2) {sprintf(tmp,"%f",tmp,sauvConstreal);quadr("+",tmpOP1,tmp,"RES");}
					else if(Last==4) quadr("+",tmpOP1,sauvIdf,"RES"); 
                }
  |E  {if(Last==1){ OP1int=sauvConstint; sprintf(tmpOP1,"%d",sauvConstint);}
		else if(Last==2){ OP1real=sauvConstreal; sprintf(tmpOP1,"%d",sauvConstreal);}
			else if(Last==4) strcpy(tmpOP1,sauvIdf); 
		}
	moins T {if(Last==1) {sprintf(tmp,"%d",sauvConstint); quadr("-",tmpOP1,tmp,"RES");}
				else if(Last==2) {sprintf(tmp,"%f",tmp,sauvConstreal);quadr("-",tmpOP1,tmp,"RES");}
					else if(Last==4) quadr("-",tmpOP1,sauvIdf,"RES"); 
                }
  |T
  ;
T: F 
  | T  {if(Last==1){ OP1int=sauvConstint; sprintf(tmpOP1,"%d",sauvConstint);}
		else if(Last==2){ OP1real=sauvConstreal; sprintf(tmpOP1,"%d",sauvConstreal);}
			else if(Last==4) strcpy(tmpOP1,sauvIdf); 
		}
	mult F  {if(Last==1) {sprintf(tmp,"%d",sauvConstint); quadr("*",tmpOP1,tmp,"RES");}
				else if(Last==2) {sprintf(tmp,"%f",tmp,sauvConstreal);quadr("*",tmpOP1,tmp,"RES");}
					else if(Last==4) quadr("*",tmpOP1,sauvIdf,"RES"); 
                }
			
  | T {if(Last==1){ OP1int=sauvConstint; sprintf(tmpOP1,"%d",sauvConstint);}
		else if(Last==2){ OP1real=sauvConstreal; sprintf(tmpOP1,"%d",sauvConstreal);}
			else if(Last==4) strcpy(tmpOP1,sauvIdf); 
		}
	mc_div F {if (sauvConst==0) {
                 printf("Erreur semantique: Division par zero a la ligne %d et a la colonne %d\n",nb_ligne,col);
                          }
                else {
					if(Last==1) {sprintf(tmp,"%d",sauvConstint); quadr("/",tmpOP1,tmp,"RES");}
					else if(Last==2) {sprintf(tmp,"%f",tmp,sauvConstreal);quadr("/",tmpOP1,tmp,"RES");}
							else if(Last==4) quadr("/",tmpOP1,sauvIdf,"RES"); 
                }
               }
;
F: cst_int  {	sauvConst=$1;
				sauvConstint=$1;
				sauv=1;
				Last=1;
            } 
  |cst_real {	sauvConst=$1;
				sauvConstreal=$1;
				sauv=2;
				Last=2;
            } 
  |idf { if (VariableNonDeclaree($1)==-1){
                             printf("Erreur semantique: Variable %s Non Declaree a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
            } else{
              sauv=getType($1,sauvFunc);
              Last=4;
			        strcpy(sauvIdf,$1);
            }
        }
  |paro E parf 
  |idf paro LISTE_MAT parf { if (VariableNonDeclaree($1)==-1){
                             printf("Erreur semantique: Variable %s Non Declaree a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
                              } else{
                                sauv=getType($1,sauvFunc);
                                Last=4;
			                          strcpy(sauvIdf,$1);
                              }
                              
                           }
  |mc_call idf paro liste_par parf { if (VariableNonDeclaree($2)==-1){
                                      printf("Erreur semantique: Variable %s Non Declaree a la ligne %d et a la colonne %d\n",$2,nb_ligne,col);
                                      } else {
                                        sauv=getType($2,sauvFunc);
                                      }
                                   }
  |mc_chaine {sauv=4;}
  |mc_bl {sauv=3; if($1=1){sauvConstint=1; } if($1=0){sauvConstint=0; } Last=3;
  }
;
ENTRER:mc_read paro idf parf { if (VariableNonDeclaree($3)==-1){
                               printf("Erreur semantique: Variable %s Non Declaree a la ligne %d et a la colonne %d\n",$3,nb_ligne,col);
                                } 
                             }
;
SORTIE:mc_write paro mc_chaine suite
;
suite:vrg idf vrg mc_chaine parf { if (VariableNonDeclaree($2)==-1){
                                     printf("Erreur semantique: Variable %s Non Declaree a la ligne %d et a la colonne %d\n",$2,nb_ligne,col);
                                   } 
                                 }
     |parf
;

CONDITION:B mc_else LISTE_INSTRUCTION mc_endif{sprintf(tmp,"%d",qc);
                                               ajour_quad(Fin_if,1,tmp);
                                              }
          |B mc_endif
;
B: A mc_then LISTE_INSTRUCTION {  Fin_if=qc;//Fin_if==1
                                  quadr("BR","","vide", "vide");
                                  sprintf(tmp,"%d",qc);
                                  ajour_quad(deb_else,1,tmp);
                                }
;
A:mc_if paro LISTE_COND parf {deb_else=qc;//deb_else==0
                              quadr("BZ","","temp_cond", "vide");
                              }
;

LISTE_COND: Z point E parf {sprintf(tmp,"%d",qc);
										         i=0;
										         for(i=0;i<j;i++){
											      ajour_quad(Fin_Cond[i],1,qc);
										        }
									          }
          | X point LISTE_COND parf  {sprintf(tmp,"%d",qc);
										                    i=0;
										                    for(i=0;i<j;i++){
											                  ajour_quad(Fin_Cond[i],1,qc);
										                  }
									                    }
;
Z:  paro E point OPP { 
						 if(strcmp(sauvOpBool,"LT")==0){
								quadr("BL","","vide","vide");
							}
              if(strcmp(sauvOpBool,"LE")==0){
								quadr("BLE","","vide","vide");
				      }
              if(strcmp(sauvOpBool,"GT")==0){
								quadr("BG","","vide","vide");
              }
              if(strcmp(sauvOpBool,"GE")==0){
								quadr("BGE","","vide","vide");
              }
              if(strcmp(sauvOpBool,"EQ")==0){
								quadr("==","","vide","vide");
              }   
              if(strcmp(sauvOpBool,"NE")==0){
								quadr("!=","","vide","vide");
              }  
              if(strcmp(sauvOpBool,"AND")==0){
								quadr("AND","","vide","vide");
                if(sauvBool=0) {
                  Fin_Cond[i]=qc;
                  i++;
                  j++;
                  quadr("BR","","vide","vide");
                }
              }  
              if(strcmp(sauvOpBool,"OR")==0){
								quadr("OR","","vide","vide");
                if(sauvBool=1) {
                  Fin_Cond[i]=qc;
                  i++;
                  j++;
                  quadr("BR","","vide","vide");
                }
              }
}
;
X:paro LISTE_COND point OPP 
;
OPP:gt {strcpy(sauvOpBool,$1);}
   |ge {strcpy(sauvOpBool,$1);}
   |eq {strcpy(sauvOpBool,$1);}
   |ne {strcpy(sauvOpBool,$1);}
   |le {strcpy(sauvOpBool,$1);}
   |lt {strcpy(sauvOpBool,$1);}
   |and {strcpy(sauvOpBool,$1);}
   |or {strcpy(sauvOpBool,$1);}
;
BOUCLE:C LISTE_INSTRUCTION mc_enddo { sprintf(tmp,"%d",condWhile);
                                      quadr("BR",tmp,"vide", "vide");
                                      sprintf(tmp,"%d",qc);
                                      ajour_quad(Fin,1,tmp);
                                    }
;

C: mc_dowhile LISTE_COND {condWhile=qc;
                          Fin=qc;
                          quadr("BZ","","temp_cond", "vide");
                         }
;

EQUIVALENCE:mc_eqv paro liste_par parf vrg paro liste_par parf
;
%%
main() {
  initialisation();
  yyparse();
  afficher();
  afficher_qdr(); 
}

yywrap() {}
yyerror (char*msg)
{
   printf("Erreur syntaxique a la ligne %d et a la colonne %d\n", nb_ligne, col);
}
