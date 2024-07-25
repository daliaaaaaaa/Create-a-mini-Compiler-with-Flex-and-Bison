flex lexical.l
bison -d syntaxique.y
gcc lex.yy.c syntaxique.tab.c -o exp -lfl -ly
exp < fichier.txt
