# COMP Projeto (C)
# Meta 1
- `uccompiler.l`: ficheiro lex com as regras da meta 1 todas (algumas coisas tem de ser removidas porque sao de metas posteriores; maior parte do `main` nao precisa de existir; outras coisas como `return` statements tambem nao sao necessarios ainda, fazem parte da meta 2; entre outras coisas)
- usar o script.sh para compilar tudo
- para zippar e enviar, usar o script com a linha `zip` descomentada; nesta meta apenas é necessario `zip -r uccompiler.zip uccompiler.l`, o resto é adicionado à medida que se avança nas metas
---
# Meta 2
- `uccompiler.y`: ficheiro yacc com as regras da meta 2 todas (supostamente funciona tudo bem)
- Ambos os ficheiros `AbsTree` sao criados nesta meta, e as funcoes sao usadas no ficheiro `yacc`
- no `script` descomentar linha do `yacc` e do `cc` para compilaçao (deixar a do `lex` como esta, que ele tambem precisa de ser compilado)
- adicionar pelo menos `uccompiler.y AbsTree.c AbsTree.h` à linha de `zip`
- algumas funcoes a voltar a colocar no `main` do lexer
---
# Meta 3
A partir daqui ja nao esta nada a 100% xd
- `semantics.c` e `semantics.h`: ficheiros para esta meta
- adicionar os ficheiros a `cc` (`semantics.c`) e a `zip` (`semantics.c semantics.h`)
- algumas funcoes a voltar a colocar no `main` do lexer

# Meta 4
Nunca vi ninguem a chegar aqui, so idk lmao