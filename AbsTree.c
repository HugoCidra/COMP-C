#include "AbsTree.h"

Node *add_node(char *info, int line, int column){

    Node *temp = (Node*) malloc(sizeof(Node));
    temp->info = info;
    temp->added_info = NULL;
    temp->child = NULL;
    temp->brother = NULL;   
    temp->line = line;
    temp->column = column;

    return temp;

}

void add_brother(Node* node1, Node* node2){

    Node *temp;
    temp = node1;

    while(temp->brother != NULL){
        temp = temp->brother;
    }
    temp->brother = node2;
}

void print_AbsTree(Node *node, int depth){

    char margin[depth * 2]
    for (int i = 0; i < depth; i++){

        margin[i] = ".";
    }
    margin[depth * 2] = '\0';

    
}