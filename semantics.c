/*
* Hugo Batista Cidra Duarte - 2020219765
* Nuno Carvalho do Nascimento - 2020219249
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "AbsTree.h"
#include "semantics.h"

int semantic_errors = 0;

symbol_list* symbol_table;

void check_parameters(node* parameters, symbol_list* scope) {
    struct node_list* param = parameters->children;
    while((param = param->next) != NULL) {
        node* id = getChild(param->node, 1);
        enum type type = category_type(getChild(param->node, 0)->category);

        if(search_symbol(symbol_table, id->info) == NULL) {
            insert_symbol(symbol_table, id->info, type, param->node);
            insert_symbol(scope, id->info, type, param->node);
        }
        else {
            printf("Identifier %s (%d:%d) already declared\n", id->info, id->info_line, id->info_column);
            semantic_errors++;
        }
    }
}

void check_function(node *function) {
    node* id = getChild(function, 0);
    if(search_symbol(symbol_table, id->info) == NULL) insert_symbol(symbol_table, id->info, no_type, function);
    else {
        printf("Identifier %s already declared\n", id->info);
        semantic_errors++;
    }

    symbol_list* scope = (symbol_list*) malloc(sizeof(symbol_list));
    scope->next = NULL;
    check_parameters(getChild(function, 1), scope);
}

//semantic analysis begins here, with the AST root node
int check_program(node* program) {
    symbol_table = (symbol_list*) malloc(sizeof(symbol_list));
    symbol_table->next = NULL;
    struct node_list* child = program->children;
    while((child = child->next) != NULL) check_function(child->node);
    return semantic_errors;
}

//Insert a new symbol in the list, unless it is already there
symbol_list* insert_symbol(symbol_list* table, char* identifier, enum type type , node* node) {
    symbol_list *new = (symbol_list*) malloc(sizeof(symbol_list));

    new->identifier = identifier;
    new->type = type;
    new->node = node;
    new->next = NULL;

    symbol_list *symbol = table;
    while(symbol != NULL) {
        if(symbol->next == NULL) {
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
symbol_list* search_symbol(symbol_list* table, char* identifier) {
    symbol_list* symbol;
    for(symbol = table->next; symbol != NULL; symbol = symbol->next)
        if(strcmp(symbol->identifier, identifier) == 0) return symbol;
    return NULL;
}

void show_symbol_table() {
    symbol_list* symbol;
    for(symbol = symbol_table->next; symbol != NULL; symbol = symbol->next) 
        printf("Symbol %s : %s\n", symbol->identifier, type_name(symbol->type));
}