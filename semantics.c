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

void check_expression(node* expression, symbol_list* scope) {
    switch(expression->category) {
        case Identifier:
            if(search_symbol(scope, expression->info) == NULL) {
                printf("Variable %s (%d:%d) undeclared\n", expression->info, expression->info_line, expression->info_column);
                semantic_errors++;
            }
            else {
                expression->type = search_symbol(scope, expression->info)->type;
            }
            break;
        case Natural:
            expression->type = integer_type;
            break;
        case Decimal:
            expression->type = double_type;
            break;
        case Call:
            if(search_symbol(symbol_table, getChild(expression, 0)->info) == NULL || search_symbol(symbol_table, getChild(expression, 0)->info)->node->category != FuncDeclaration) {
                printf("Function %s (%d:%d) undeclared\n", getChild(expression, 0)->info, getChild(expression, 0)->info_line, getChild(expression, 0)->info_column);
                semantic_errors++;
            }
            else {
                node* arguments = getChild(expression, 1);
                node* params = getChild(search_symbol(symbol_table, getChild(expression, 0)->info)->node, 1);

                if(params != NULL && countchildren(arguments) != countchildren(params)) {
                    printf("Calling %s (%d:%d) with incorrect arguments\n", getChild(expression, 0)->info, getChild(expression, 0)->info_line, getChild(expression, 0)->info_column);
                    semantic_errors++;
                }
                else {
                    struct node_list* arg = arguments->children;
                    while((arg = arg->next) != NULL) check_expression(arg->node, scope);
                }
            }
            break;
        case If:
            check_expression(getChild(expression, 0), scope);
            check_expression(getChild(expression, 1), scope);
            check_expression(getChild(expression, 2), scope);
            break;
        case Add:
        case Sub:
        case Mul:
        case Div:
            check_expression(getChild(expression, 0), scope);
            check_expression(getChild(expression, 1), scope);
            break;
        default:
            break;
    }
}

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
    node* id = function;
    if(search_symbol(symbol_table, id->info) == NULL) insert_symbol(symbol_table, id->info, no_type, function);
    else {
        printf("Identifier %s already declared\n", id->info);
        semantic_errors++;
    }

    
    symbol_list* scope = (symbol_list*) malloc(sizeof(symbol_list));
    scope->next = NULL;
    check_parameters(getChild(function, 1), scope);
    check_expression(getChild(function, 2), scope);
    free(scope);
}

//semantic analysis begins here, with the AST root node
int check_program(node* program) {

    symbol_table = (symbol_list*) malloc(sizeof(symbol_list));
    
    symbol_table->next = NULL;

    //predeclared funcs, no children
    insert_symbol(symbol_table, "putchar", integer_type, newnode(FuncDeclaration, NULL));
    insert_symbol(symbol_table, "getchar", integer_type, newnode(FuncDeclaration, NULL));

    struct node_list* child = program->children;
    while(child != NULL) {
        check_function(child->next->node);
        child = child->next;
    }
    
    return semantic_errors;
}

//Insert a new symbol in the list, unless it is already there
symbol_list* insert_symbol(symbol_list* table, char* identifier, enum type type , node* node) {
    symbol_list *new = (symbol_list*) malloc(sizeof(struct symbol_list_));

    new->identifier = strdup(identifier);
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
    symbol_list* symbol = table->next;

    while(symbol != NULL) {
        if(strcmp(symbol->identifier, identifier) == 0) {
            return symbol;
        }

        symbol = symbol->next;
    }
    
    return NULL;
}

void show_symbol_table() {
    symbol_list* symbol;
    for(symbol = symbol_table->next; symbol != NULL; symbol = symbol->next) 
        printf("Symbol %s : %s\n", symbol->identifier, type_name(symbol->type));
}