#!/bin/sh
rm -f uccompiler lex.yy.c y.tab.c y.tab.h
# yacc -d -v -t -g --report=all uccompiler.y
lex uccompiler.l
# cc -o uccompiler lex.yy.c y.tab.c AbsTree.c semantics.c -Wall -Wno-unused-function -g
# zip -r uccompiler.zip uccompiler.l uccompiler.y AbsTree.c AbsTree.h semantics.c semantics.h

#chmod +x build.sh
# after chmod once only use ./build.sh
#./build.sh