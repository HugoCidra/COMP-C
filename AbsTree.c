#include "AbsTree.h"

Node *add_node(char *info, int line, int column){

    Node *temp = (Node*) malloc(sizeof(Node));
    temp->info = info;
    temp->column = column;
    temp->line = line;
    temp->child = NULL;

    return temp;

}

void print_AbsTree(Node *node, int depth){

    char margin[depth * 2]
    for (int i = 0; i < depth; i++){

        margin[i] = ".";
    }
    margin[depth * 2] = '\0';
    
    printf("%s%s\n",dots, node->info);

    if (node->child)
        print_AbsTree(node->child, depth+1);

    free(node);
    
}

void freeAbsTree (Node* node){

    if (node->child)
        freeAbsTree(node->child);

    free (Node);
}