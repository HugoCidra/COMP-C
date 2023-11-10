#ifndef AbsTree_h
#define AbsTree_h

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct node {

    char* info
    struct node* child;
    int line;
    int col;
}Node;

Node *add_node(char *info, int line, int column);
void print_AbsTree(Node *node, int depth);
void freeAbsTree (Node* node);

#endif