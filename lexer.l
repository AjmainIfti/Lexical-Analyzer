%{
#include <stdio.h>
#include <string.h>

FILE *out;
int line = 1;
int paren_depth = 0;

void updateLine(const char *text) {
    for (int i = 0; text[i]; i++)
        if (text[i] == '\n') line++;
}

void print_library(const char *text) {
    char fname[256];
    int i = 0, j = 0;

    while (text[i] && text[i] != '<' && text[i] != '"') i++;
    i++;

    while (text[i] && text[i] != '>' && text[i] != '"') {
        fname[j++] = text[i++];
    }
    fname[j] = '\0';

    fprintf(out, "Library File: %s (line %d)\n", fname, line);
}
%}

%option noyywrap
%s PARAMS

DIGIT      [0-9]
LETTER     [a-zA-Z_]
ID         {LETTER}({LETTER}|{DIGIT})*
INT        (0[xX][0-9a-fA-F]+)|({DIGIT}+)
FLOAT      ({DIGIT}*\.{DIGIT}+([eE][-+]?{DIGIT}+)?)|({DIGIT}+[eE][-+]?{DIGIT}+)
CHAR       \'([^\\\n]|(\\.))\'
STRING     \"([^\\\n]|(\\.))*\"
COMMENT1   \/\/.*
COMMENT2   \/\*([^*]|\*+[^*/])*\*+\/

%%

<PARAMS>"(" {
    paren_depth++;
    fprintf(out, "Symbol: ( (line %d)\n", line);
}

<PARAMS>")" {
    paren_depth--;
    fprintf(out, "Symbol: ) (line %d)\n", line);
    if (paren_depth == 0) BEGIN(INITIAL);
}

<PARAMS>{ID}     { fprintf(out, "Parameter: %s (line %d)\n", yytext, line); }
<PARAMS>{FLOAT}  { fprintf(out, "Parameter: %s (line %d)\n", yytext, line); }
<PARAMS>{INT}    { fprintf(out, "Parameter: %s (line %d)\n", yytext, line); }
<PARAMS>{CHAR}   { fprintf(out, "Parameter: %s (line %d)\n", yytext, line); }
<PARAMS>{STRING} { fprintf(out, "Parameter: %s (line %d)\n", yytext, line); }
<PARAMS>[ \t]+   { }
<PARAMS>\n       { line++; }
<PARAMS>","      { fprintf(out, "Symbol: , (line %d)\n", line); }
<PARAMS>.        { fprintf(out, "Symbol: %s (line %d)\n", yytext, line); }

\n                 { line++; }
[ \t\r]+           { }

\#include[ \t]*[<"]([^>"]+)[>"] { print_library(yytext); }

{COMMENT1} { fprintf(out, "Comment: %s (line %d)\n", yytext, line); }
{COMMENT2} { fprintf(out, "Comment: %s (line %d)\n", yytext, line); updateLine(yytext); }

(vector|map|pair|stack|queue|list)[ \t]*"<"(int|float|double|char|string|long|short|unsigned)([ \t]*","[ \t]*(int|float|double|char|string|long|short|unsigned))?[ \t]*">" {
    fprintf(out, "STL: %s (line %d)\n", yytext, line);
}

(if|else|switch|for|while|do|return)[ \t]*/"(" {
    fprintf(out, "Keyword: %s (line %d)\n", yytext, line);
}

(int|float|double|char|void|if|else|switch|case|for|while|do|break|continue|return|class|struct|public|private|protected|static|const|using|namespace|vector|map|stack|queue|list|pair) {
    fprintf(out, "Keyword: %s (line %d)\n", yytext, line);
}

{ID}/"(" {
    fprintf(out, "Function: %s (line %d)\n", yytext, line);
    paren_depth = 0;
    BEGIN(PARAMS);
}

"::"                           { fprintf(out, "Symbol: %s (line %d)\n", yytext, line); }
("<<"|">>")                    { fprintf(out, "Stream Operator: %s (line %d)\n", yytext, line); }
("=="|"!="|"<="|">="|"<"|">")  { fprintf(out, "Relational Operator: %s (line %d)\n", yytext, line); }
("+="|"-="|"*="|"/="|"%="|"=") { fprintf(out, "Assignment Operator: %s (line %d)\n", yytext, line); }
("++"|"--"|"+"|"-"|"*"|"/"|"%") { fprintf(out, "Arithmetic Operator: %s (line %d)\n", yytext, line); }
("&&"|"||"|"!")                 { fprintf(out, "Logical Operator: %s (line %d)\n", yytext, line); }

("("|")"|"{"|"}"|"["|"]"|";"|","|"."|":") { fprintf(out, "Symbol: %s (line %d)\n", yytext, line); }

{FLOAT}  { fprintf(out, "Number: %s (line %d)\n", yytext, line); }
{INT}    { fprintf(out, "Number: %s (line %d)\n", yytext, line); }
{CHAR}   { fprintf(out, "Character: %s (line %d)\n", yytext, line); }
{STRING} { fprintf(out, "String: %s (line %d)\n", yytext, line); }

{ID} { fprintf(out, "Identifier: %s (line %d)\n", yytext, line); }

. { fprintf(out, "ERROR: invalid token '%s' (line %d)\n", yytext, line); }

%%

int main() {
    FILE *in = fopen("input.txt", "r");
    out = fopen("output.txt", "w");

    if (!in || !out) {
        printf("File error\n");
        return 1;
    }

    yyin = in;
    yylex();

    fclose(in);
    fclose(out);
    return 0;
}