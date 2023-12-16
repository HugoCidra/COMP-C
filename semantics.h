/*
* Hugo Batista Cidra Duarte - 2020219765
* Nuno Carvalho do Nascimento - 2020219249
*/

#ifndef _SEMANTICS_H
#define _SEMANTICS_H

#include "AbsTree.h"

int check_program(struct node *program);

typedef struct symbol_list_ {
    char *identifier;
    enum type type;
    struct node *node;
    struct symbol_list_ *next;
} symbol_list;

symbol_list* insert_symbol(symbol_list* symbol_table, char* identifier, enum type type, node* node);
symbol_list* search_symbol(symbol_list* symbol_table, char* identifier);
void show_symbol_table();
int check_program(node* program);

#endif