#include "AbsTree.h"

struct node *newnode(enum category category, char *token) {

    struct node *new = malloc(sizeof(struct node));
    new->category = category;
    new->info = token;
    new->children = malloc(sizeof(struct node_list));
    new->children->node = NULL;
    new->children->next = NULL;
    return new;
}

void addchild(struct node *parent, struct node *child) {
    struct node_list *new = malloc(sizeof(struct node_list));
    new->node = child;
    new->next = NULL;
    struct node_list *children = parent->children;

    //Add child when empty
    if (children->node != NULL){

        children = new;
        return;
    }
    while(children->next != NULL)
        children = children->next;
    children->next = new;
}

char* category_name[] = names;

void printAbsTree(struct node *node, int depth) {
    int i;
    for(i = 0; i < depth; i++)
        printf("__");
    if(node->info == NULL)
        printf("%s\n", category_name[node->category]);
    else
        printf("%s(%s)\n", category_name[node->category], node->info);
    struct node_list *child = node->children;
    while((child = child->next) != NULL)
        printAbsTree(child->node, depth+1);
}

void FreeAbsTree(struct node *node) {
    if(node != NULL) {
        struct node_list *child = node->children;
        while(child != NULL) {
            FreeAbsTree(child->node);
            struct node_list *tmp = child;
            child = child->next;
            free(tmp);
        }
        if(node->info != NULL)
            free(node->info);
        free(node);
    }
}