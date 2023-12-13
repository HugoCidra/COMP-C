#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "AbsTree.h"
#include "semantics.h"

int semantic_errors = 0;

struct symbol_list* symbol_table;

void check_function(struct node *function) {
    struct node* id = getChild(function, 0);
    if(search_symbol(symbol_table, id->info) == NULL) insert_symbol(symbol_table, id->info, no_type, function);
    else {
        printf("Identifier %s already declared\n", id->info);
        semantic_errors++;
    }
}

//semantic analysis begins here, with the AST root node
int check_program(struct node* program) {
    symbol_table = (struct symbol_list*) malloc(sizeof(struct symbol_list));
    symbol_table->next = NULL;
    struct node_list* child =   program->children;
    while((child = child->next) != NULL) check_function(child->node);
    return semantic_errors;
}

//Insert a new symbol in the list, unless it is already there
struct symbol_list* insert_symbol(struct symbol_list* table, char* identifier, enum type type , struct node* node) {
    struct symbol_list *new = (struct symbol_list*) malloc(sizeof(struct symbol_list));

    new->identifier = identifier;
    new->type = type;
    new->node = node;
    new->next = NULL;

    struct symbol_list *symbol = table;
    while(symbol != NULL) {
        if(symbol->next = NULL) {
            symbol->next = new;
            break;
        }
        else if(!strcmp(symbol->next->identifier, identifier)) {
            free(new);
            return NULL;
        }
        symbol = symbol->next;
    }

    return new;
}

//look up a symbol by its identifier
struct symbol_list* search_symbol(struct symbol_list* table, char* identifier) {
    struct symbol_list* symbol;
    for(symbol = table->next; symbol != NULL; symbol = symbol->next)
        if(strcmp(symbol->identifier, identifier) == 0) return symbol;
    return NULL;
}

void show_symbol_table() {
    struct symbol_list* symbol;
    for(symbol = symbol_table->next; symbol != NULL; symbol = symbol->next) 
        printf("Symbol %s : %s\n", symbol->identifier);
}