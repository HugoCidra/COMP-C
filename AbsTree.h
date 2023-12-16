/*
* Hugo Batista Cidra Duarte - 2020219765
* Nuno Carvalho do Nascimento - 2020219249
*/

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
enum type {integer_type, double_type, no_type};
#define type_name(type) (type == integer_type ? "integer" : (type == double_type ? "double" : "none"))
#define category_type(category) (category == Int ? integer_type : (category == Double ? double_type : no_type))

typedef struct node {
    enum type type;
    enum category category;
    char* info;
    int info_line, info_column;
    struct node* child;
    struct node_list* children;
} node;

struct node_list {
    struct node *node;
    struct node_list *next;
};

node* newnode(enum category category, char *token);
void addchild(struct node *parent, struct node *child);
void printAbsTree(struct node *node, int depth);
void freeAbsTree (struct node* node);
void adoptChildren(struct node* node, struct node* aux);
node* getChild(struct node *parent, int position);

#endif