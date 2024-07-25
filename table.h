#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/****************CREATION DE LA TABLE DES SYMBOLES ******************/
/***Step 1: Definition des structures de donnees ***/
typedef struct NodeF
{
    char name[20];
	char typeF[20];
	int nbDecla;
    struct NodeF* next;
} NodeF;

typedef struct ListFunc
{
    NodeF* head;
} ListFunc;

typedef struct Node1
{
    int state;
    char name[20];
    char code[20];
    char type[25];
    ListFunc func;
    float val;
    struct Node1* next;
} Node1;

typedef struct Node2
{
    int state;
    char name[20];
    char type[25];
    char code[20];
    struct Node2* next;
} Node2;

typedef struct
{
    Node1* head;
} List1;

typedef struct
{
    Node2* head;
} List2;

/*--------------------------Quadruplets---------------------------*/

typedef struct expression {
    char type[100];
    char id[100];
} expression;

typedef struct qdr {
    char oper[100];
    char op1[100];
    char op2[100];
    char res[100];
} qdr;

typedef struct QuadNode {
    int numquad;
    qdr quadruplet;
    struct QuadNode* next;
} QuadNode;

typedef struct
{
    QuadNode* head;
} Listquad;
Listquad quad;

extern int qc;
/*---------------------------------------------------------------*/


List1 tabList;
List2 tabmList, tabsList;
extern char sav[20];

/***Step 2: initialisation de l'etat des cases des tables des symbloles***/
/*0: la case est libre    1: la case est occupee*/

void initialisation()
{
    tabList.head = NULL;
    tabmList.head = NULL;
    tabsList.head = NULL;
}

void inserer(char entite[], char code[], char type[], float val, int y)
{
    switch (y)
    {
    case 0: /* insertion dans la table des IDF et CONST */
    {
        Node1* newNode = (Node1*)malloc(sizeof(Node1));
        strcpy(newNode->name, entite);
        strcpy(newNode->code, code);
        newNode->state = 1;
        newNode->next = NULL;
        newNode->val = val;
        strcpy(newNode->type, type);
		newNode->func.head=NULL;
        List1* currentList = &tabList;

        if (currentList->head == NULL)
        {
            currentList->head = newNode;
        }
        else
        {
            Node1* current = currentList->head;
            while (current->next != NULL)
            {
                current = current->next;
            }
            current->next = newNode;
        }
        break;
    }

    case 1: /* insertion dans la table des mots cles */
    {
        Node2* newNode2 = (Node2*)malloc(sizeof(Node2));
        strcpy(newNode2->name, entite);
        strcpy(newNode2->code, code);
        newNode2->state = 1;
        newNode2->next = NULL;
        strcpy(newNode2->type, type);
        List2* currentList2 = &tabmList;

        if (currentList2->head == NULL)
        {
            currentList2->head = newNode2;
        }
        else
        {
            Node2* current = currentList2->head;
            while (current->next != NULL)
            {
                current = current->next;
            }
            current->next = newNode2;
        }
        break;
    }

    case 2: /* insertion dans la table des separateurs */
    {
        Node2* newNode3 = (Node2*)malloc(sizeof(Node2));
        strcpy(newNode3->name, entite);
        strcpy(newNode3->code, code);
        newNode3->state = 1;
        newNode3->next = NULL;
        strcpy(newNode3->type, type);
        List2* currentList3 = &tabsList;

        if (currentList3->head == NULL)
        {
            currentList3->head = newNode3;
        }
        else
        {
            Node2* current = currentList3->head;
            while (current->next != NULL)
            {
                current = current->next;
            }
            current->next = newNode3;
        }
        break;
    }
    }
}


void rechercher(char entite[], char code[], char type[], float val, int y)
{
    int i;

    switch (y)
    {
    case 0: /*verifier si la case dans la tables des IDF et CONST est libre*/
    {
        Node1* current = tabList.head;
        while (current != NULL && strcmp(entite, current->name) != 0)
        {
            current = current->next;
        }

        if (current == NULL)
        {
            inserer(entite, code, type, val, 0);
        }
        break;
    }

    case 1: /*verifier si la case dans la tables des mots clés est libre*/
    {
        Node2* current = tabmList.head;
        while (current != NULL && strcmp(entite, current->name) != 0)
        {
            current = current->next;
        }

        if (current == NULL)
        {
            inserer(entite, code, type, val, 1);
        }
        break;
    }

    case 2: /*verifier si la case dans la tables des séparateurs est libre*/
    {
        Node2* current = tabsList.head;
        while (current != NULL && strcmp(entite, current->name) != 0)
        {
            current = current->next;
        }

        if (current == NULL)
        {
            inserer(entite, code, type, val, 2);
        }
        break;
    }

    }
}
char* chaineLoc(Node1* node) {
    NodeF* currentF = node->func.head;
    size_t totalLength = 1; // Initialize with 1 for the null terminator
    char* result;

    // Calculate the total length of the concatenated strings
    while (currentF != NULL) {
        totalLength += strlen(currentF->name) + strlen(currentF->typeF) + 6; // 6 accounts for spaces and parentheses
        currentF = currentF->next;
    }

    result = (char*)malloc(totalLength);
    if (result == NULL) {
        // Handle memory allocation failure
        return NULL;
    }

    strcpy(result, ""); // Initialize with an empty string

    currentF = node->func.head; // Reset to the beginning of the list

    while (currentF != NULL) {
        char tempBuffer[100]; // Adjust the size as needed
        sprintf(tempBuffer, " %s (%s)", currentF->name, currentF->typeF);
        strcat(result, tempBuffer);
        currentF = currentF->next;
    }

    return result;
}

void afficher()
{
    // Affichage Table des symboles IDF
    printf("\n/***************Table des symboles IDF et Constantes *************/\n");
    printf("______________________________________________________________________________________________________________________________\n");
    printf("\t| Nom_Entite |  Code_Entite  | Type_Entite  | Val_Entite    |                      Locliser                          | \n");
    printf("______________________________________________________________________________________________________________________________\n");

    Node1* current1 = tabList.head;
    while (current1 != NULL)
    {
        printf("\t|%10s |%15s | %12s | %12f  |%56s|\n", current1->name, current1->code, current1->type, current1->val,chaineLoc(current1));
        current1 = current1->next;
    }

    // Affichage Table des symboles mots cles
    printf("\n/***************Table des symboles mots cles*************/\n");
    printf("________________________________________\n");
    printf("\t| NomEntite    |  CodeEntite    | \n");
    printf("________________________________________\n");

    Node2* current2 = tabmList.head;
    while (current2 != NULL)
    {
        printf("\t|%13s |%15s | \n", current2->name, current2->code);
        current2 = current2->next;
    }

    // Affichage Table des symboles separateurs
    printf("\n/***************Table des symboles separateurs*************/\n");
    printf("___________________________________\n");
    printf("\t| NomEntite |  CodeEntite | \n");
    printf("___________________________________\n");

    Node2* current3 = tabsList.head;
    while (current3 != NULL)
    {
        printf("\t|%10s |%12s | \n", current3->name, current3->code);
        current3 = current3->next;
    }
}
    Node1 * Recherche_position(char entite[])
    {
		Node1* current1 = tabList.head;
		while(current1!=NULL && strcmp(entite,current1->name)!=0)
		{
			current1=current1->next;
		}
		if(current1==NULL){
			return NULL;
		}
		return current1;
    }

	 void insererTYPE(char entite[], char type[])
	{
	   Node1* current1 =Recherche_position(entite);
	   if(current1!=NULL)  {
        strcpy(current1->type, type);
        }
	}
	int ajouterFonction(Node1* node,char functionName[], char type[])
	{
		if (node->func.head == NULL)
		{	//Creer nouveau noeud
			NodeF* newNodeF = (NodeF*)malloc(sizeof(NodeF));
			strcpy(newNodeF->name, functionName);
			strcpy(newNodeF->typeF, type);
			newNodeF->nbDecla=1;
			newNodeF->next = NULL;
			node->func.head = newNodeF;
			return 1;
		}
		else
		{
			// Parcourire la liste
			NodeF* currentF = node->func.head;
			while (currentF->next != NULL && strcmp(currentF->name,functionName)!=0)
			{
				currentF = currentF->next;
			}
			//cas ou c'est dans la meme fonction
			if(strcmp(currentF->name,functionName)==0){
				currentF->nbDecla++; /*incrementer nombre de declaration*/
				return currentF->nbDecla;
			}
			else {
				//Creer nouveau noeud et inserer
				NodeF* newNodeF = (NodeF*)malloc(sizeof(NodeF));
				strcpy(newNodeF->name, functionName);
				strcpy(newNodeF->typeF, type);
				newNodeF->nbDecla=1;
				newNodeF->next = NULL;
				currentF->next = newNodeF;
				return newNodeF->nbDecla;
			}
		}
	}
   
   	 int insererFonction(char entite[], char namefunc[], char type[])
	{
	   Node1* current1 =Recherche_position(entite);
	   int X=-1;
	   if(current1!=NULL)  {
			X=ajouterFonction(current1,namefunc,type);
        }
		return X;
	}
	
   	int doubleDeclaration(char entite[])
	{
		Node1* current1 = Recherche_position(entite);
		if (current1 != NULL) {
			if ((strcmp(current1->type,"") == 0) && (current1->func.head==NULL) && (strcmp(current1->code,"Nom Fonction") != 0)&& (strcmp(current1->code,"Parametre") != 0)){
				return 0;
			}
		} else return -1;
	}
    int VariableNonDeclaree(char entite[])
    {
        Node1* current1 = Recherche_position(entite);
			if ((strcmp(current1->type,"") == 0) && (current1->func.head==NULL) && (strcmp(current1->code,"Nom Fonction") != 0) && (strcmp(current1->code,"Parametre") != 0)){
				return -1;
			}
        else
			return 0;
	}
	
 void MajCodeEntiteP(char entite[] )
 {
	 Node1* current1 = Recherche_position(entite);
	if (strcmp(current1->code,"IDF") == 0 ){
		strcpy(current1->code,"NOM PROGRAMME");
	}
 }
 void MajCodeEntite(char entite[],char type[] )
 {
	 Node1* current1 = Recherche_position(entite);
	if (strcmp(current1->code,"IDF") == 0 ){
        strcpy(current1->code," NOM FONCTION");
		strcpy(current1->type,type);
	}
 }
 void MajCodeParametre(char entite[] )
 {
	 Node1* current1 = Recherche_position(entite);
	if (strcmp(current1->code,"IDF") == 0 ){
		strcpy(current1->code,"Parametre");
	}
 }
 int getCodeParametre (char entite[])
	{
		Node1* current1 = Recherche_position(entite);
		if (current1 != NULL) {
			if (strcmp(current1->code,"Parametre") == 0){
				return 0;
			}
		}
		return -1;
	}

    NodeF * Recherche_Type(Node1* node,char Fonction[])
    {
		NodeF* currentF = node->func.head;
		while(currentF!=NULL && strcmp(Fonction,currentF->name)!=0)
		{
			currentF=currentF->next;
		}
		if(currentF==NULL){
			return NULL;
		}
		return currentF;
    }

int getType(char entite[], char Fonction[]) {
    Node1* current1 = Recherche_position(entite);

    if (current1 == NULL) {
        return -1;
    }

    if (strcmp(current1->code, "IDF") == 0) {
		NodeF* currentF = Recherche_Type(current1, Fonction);

        if (currentF == NULL) {
            return -1;
        }
		
        if (strcmp(currentF->typeF, "INTEGER") == 0)   return 1;
        if (strcmp(currentF->typeF, "REAL") == 0)      return 2;
        if (strcmp(currentF->typeF, "LOGICAL") == 0)   return 3;
        if (strcmp(currentF->typeF, "CHARACTER") == 0) return 4;

    } else {

		if (strcmp(current1->type, "INTEGER") == 0)   return 1;
        if (strcmp(current1->type, "REAL") == 0)      return 2;
        if (strcmp(current1->type, "LOGICAL") == 0)   return 3;
        if (strcmp(current1->type, "CHARACTER") == 0) return 4;
    }

    return -1;
}



/*--------------------------Quadruplets---------------------------*/

void quadr(char opr[], char op1[], char op2[], char res[]) {
    QuadNode* newNode = (QuadNode*)malloc(sizeof(QuadNode));
    if (newNode == NULL) {
        // Gérer l'échec d'allocation mémoire
        exit(EXIT_FAILURE);
    }
    newNode->numquad=qc;
    strcpy(newNode->quadruplet.oper, opr);
    strcpy(newNode->quadruplet.op1, op1);
    strcpy(newNode->quadruplet.op2, op2);
    strcpy(newNode->quadruplet.res, res);
    newNode->next = NULL;

    if (quad.head == NULL) {
    quad.head=newNode;
    } else {
        QuadNode* current = quad.head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = newNode;
    }

    qc++;
}

void ajour_quad(int num_quad, int colon_quad, char val[]) {
    QuadNode* current = quad.head;

    while (current != NULL && current->numquad < num_quad) {
        current = current->next;
    }

    if (current != NULL) {
        if (colon_quad == 0)
            strcpy(current->quadruplet.oper, val);
        else if (colon_quad == 1)
            strcpy(current->quadruplet.op1, val);
        else if (colon_quad == 2)
            strcpy(current->quadruplet.op2, val);
        else if (colon_quad == 3)
            strcpy(current->quadruplet.res, val);
    }
}

void afficher_qdr() {
    printf("\n\n*********************Les Quadruplets***********************\n");

    QuadNode* current =quad.head;

    while (current != NULL) {
        printf("\n %d - ( %s  ,  %s  ,  %s  ,  %s )", current->numquad, current->quadruplet.oper, current->quadruplet.op1,
               current->quadruplet.op2, current->quadruplet.res);
        printf("\n--------------------------------------------------------\n");

        current = current->next;
    }
}



