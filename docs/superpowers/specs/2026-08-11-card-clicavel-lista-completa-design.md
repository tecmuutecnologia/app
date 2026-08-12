# Card clicável na lista completa

Data: 2026-08-11

## Problema

Na tela **Lista completa**, chegar ao prontuário de um animal exige acertar um chip
pequeno dentro do card — um ícone com o texto "Prontuário", montado por
`_chipProntuario` (`listacompleta_page.dart:342`) e envolvido por um `InkWell` lá
no fundo da árvore do cartão (linhas 557 e 835).

Na tela de **inseminações** o mesmo destino é alcançado tocando em **qualquer
ponto do card**: o item inteiro é um `InkWell` que chama
`context.pushNamed(ProntuarioAnimalPage.routeName, ...)`.

A navegação, portanto, já existe nas duas telas e leva ao mesmo lugar, com os
mesmos oito parâmetros. O que diverge é o tamanho do alvo de toque. Quem usa a
lista completa depois de usar as inseminações toca no card, nada acontece, e
conclui que a tela não abre detalhes.

## Decisão

Ampliar o alvo de toque da lista completa para o card inteiro, igualando o
comportamento das inseminações.

Não é navegação nova: é a mesma chamada, promovida a um alvo maior.

### O chip permanece

O chip fica onde está, com o `onTap` dele intacto.

Ele passa a ser redundante em função, mas continua sendo a **única pista visual**
de que existe detalhe para ver. Removê-lo deixaria a descoberta dependente de o
usuário tentar tocar no card sem nenhum indício — as inseminações também têm
affordance visual no card, então mantê-lo é o que de fato iguala as duas telas.

### Vale para os dois cards

`_buildAnimalCard` e `_buildAnimalCardFiltrado` (o card que aparece quando há texto
na busca) recebem o mesmo tratamento. Os dois já exibem o chip hoje; tratá-los
diferente faria o comportamento mudar no meio da digitação da busca.

## Implementação

### Onde

Ambos os builders têm a mesma forma:

```dart
Widget _buildAnimalCard(BuildContext context, AnimaisProdutoresStruct item, int index) {
  return Visibility(
    visible: ...,
    child: _front1(context, item, index),
  );
}
```

O `InkWell` envolve o `_frontN(...)`, dentro do `Visibility`. Assim o card oculto
não vira alvo de toque.

### Extração de `_abrirProntuario`

O bloco de `queryParameters` tem oito parâmetros serializados (`uidPropriedade`,
`nomePropriedade`, `uidTecnico`, `emailPropriedade`, `uidAnimaisProdutores`,
`grupoPredominante`, `visitaPresencial`, `diasDg`) e hoje está **duplicado** nos
dois cards.

Copiá-lo para os dois `InkWell` novos criaria quatro cópias do mesmo bloco. A
navegação vai para um método `_abrirProntuario(item)`, e as quatro chamadas
passam a apontar para ele — de duas cópias para uma.

Isso é melhoria de código já tocado pela mudança, não refatoração oportunista: sem
ela, a mudança **piora** a duplicação existente.

### Convivência com os botões do card

O card da lista completa monta muitos botões condicionais (DG+, DG−, Inseminar,
PP, Secagem, Aborto, Descarte, entre outros), bem mais que o das inseminações.

Não há conflito: no Flutter, os filhos interativos (`FFButtonWidget`,
`GestureDetector`) vencem o teste de acerto antes do `InkWell` pai. Os botões
continuam com o comportamento atual e o card captura apenas o toque que não caiu
em nenhum deles.

O efeito colateral aceito é que um toque que **erre** um botão agora navega em vez
de não fazer nada. É o mesmo comportamento que a tela de inseminações já tem.

## Testes

Não há teste automatizado nesta mudança, e a razão é deliberada.

Não existe lógica nova: é fiação de UI. A navegação depende de `GoRouter` e de
`DocumentReference`, que exigem Firebase inicializado — um teste de widget aqui
verificaria o andaime montado para o próprio teste, não o comportamento do app.

Contrasta com `podeRegistrarDgMais`, extraído no ciclo anterior: ali havia uma
regra de domínio escondida dentro de um `onPressed`, que ganhou nome e quatro
testes.

A verificação desta mudança é visual, no dispositivo:

1. Tocar em qualquer área livre do card abre o prontuário do animal correto.
2. Tocar em DG+, Inseminar e nos demais botões continua abrindo o modal
   correspondente, sem navegar.
3. O mesmo vale com texto na busca, no card filtrado.
4. O chip "Prontuário" continua funcionando.

## Fora de escopo

- Alterar a aparência do card ou a posição do chip.
- Unificar `_front1`/`_front2`, que divergem além do alvo de toque.
- Levar o padrão às demais telas-lista (secas, prenhas, exame ginecológico), que
  têm cards próprios e devem ser avaliadas uma a uma.
