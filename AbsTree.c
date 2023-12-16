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
    if(node == NULL) return ;
    
    int i;
    for(i = 0; i < depth; i++)
        printf("..");
    
    if(node->info == NULL)
        printf("%s\n", category_name[node->category]);
    else
        printf("%s(%s)\n", category_name[node->category], node->info);
    
    struct node_list *child = node->children;
    while((child = child->next) != NULL)
        printAbsTree(child->node, depth+1);
}

void freeAbsTree(struct node *node) {
    if(node == NULL) return;
    if(node != NULL) {
        struct node_list *child = node->children;
        
        while(child != NULL) {
            freeAbsTree(child->node);
            struct node_list *tmp = child;
            child = child->next;
            free(tmp);
        }
        
        if(node->info != NULL)
            free(node->info);
        
        free(node);
    }
}

void adoptChildren(struct node* node, struct node* aux) {
    struct node_list* child = aux->children;
    struct node_list* next;
    
    while(child != NULL) {
        next = child->next;
        addchild(node, child->node);
        free(child);
        child = next;
    }

    free(aux);
}

struct node *getChild(struct node *parent, int position) {
    struct node_list *children = parent->children;
    while((children = children->next) != NULL)
        if(position-- == 0)
            return children->node;
    return NULL;
}