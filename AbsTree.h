#ifndef AbsTree_h
#define AbsTree_h

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

enum category {Program,
               Declaration,
               FuncDeclaration,
               FuncDefinition,
               ParamList,
               FuncBody,
               ParamDeclaration,
               StatList, If, While, Return,
               Or, And, Eq, Ne, Lt, Gt, Le, Ge, Add, Sub, Mul, Div, Mod, Not, Minus, Plus, Store, Comma, Call,
               BitWiseAnd, BitWiseXor, BitWiseOr,
               Char, ChrLit, Identifier,
               Int, Short, Natural, Double, Decimal,
               Void,
               Null,
               Aux};

#define names {"Program", "Declaration", "FuncDeclaration", "FuncDefinition", "ParamList", "FuncBody", "ParamDeclaration", "StatList","If", "While", "Return", "Or", "And", "Eq", "Ne", "Lt", "Gt", "Le", "Ge", "Add", "Sub", "Mul", "Div", "Mod", "Not", "Minus", "Plus", "Store", "Comma", "Call", "BitWiseAnd", "BitWiseXor", "BitWiseOr", "Char", "ChrLit", "Identifier","Int", "Short", "Natural", "Double", "Decimal", "Void", "Null", "Aux"}

typedef struct node {

    enum category category;
    char* info;
    struct node* child;
    struct node_list* children;
} node;

struct node_list {
    struct node *node;
    struct node_list *next;
};

struct node *newnode(enum category category, char *token);
void addchild(struct node *parent, struct node *child);
void printAbsTree(struct node *node, int depth);
void freeAbsTree (struct node* node);
void adoptChildren(struct node* node, struct node* aux);

#endif