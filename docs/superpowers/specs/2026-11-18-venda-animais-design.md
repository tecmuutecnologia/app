# Venda de animais — desenho

Data: 2026-11-18 · Branch: `feat/venda-animais`

## Intenção

Hoje o animal só sai do rebanho por descarte, e a receita de quem vende animais
não aparece em lugar nenhum. O produtor/técnico quer registrar a **venda** de um
animal (data e valor) e ver a **receita das vendas da propriedade** no Financeiro,
separada por mês, como histórico.

## Objetivos

1. Registrar a venda de um animal com **data** (padrão: hoje) e **valor** (R$),
   ambos obrigatórios.
2. Pontos de entrada da venda:
   - **Lista de animais** (`ListaAnimaisPage`): arrastar o card para o lado
     revela e **trava aberto** os botões **Vender | Descartar** (mecânica do
     WhatsApp). Tocar num botão abre o respectivo formulário; tocar fora fecha.
   - **Aba Bezerros**: além do arrasto, cada card mostra um **botão Vender fixo**.
   - **Editar animal**: botões **Vender** e **Descartar**.
3. Animal vendido sai do rebanho e vai para a aba **Descarte** (hoje dentro de
   Secas), que passa a separar **Descartados** e **Vendidos**.
4. Na aba Descarte: **Desfazer descarte**, **Desfazer venda** e **Remover
   permanentemente**.
5. **Financeiro** ganha uma segunda aba, **Vendas**: lista por mês (mais recente
   primeiro) com animal, data e valor de cada venda e o total do mês.
6. A venda **permanece no Financeiro** mesmo se o animal for removido
   permanentemente.

## Não-objetivos

- A receita das vendas **não** entra nos relatórios financeiros mensais
  existentes (faturamento, despesas, preço do litro) — eles continuam como estão.
- Sem editar uma venda já registrada: para corrigir, desfaz e vende de novo.
- Sem comprador, nota fiscal, peso, preço por kg etc.
- Sem exportar as vendas (PDF/Excel) nesta entrega.
- Painel web (tecmuu-web) fica fora.

## Anti-objetivos (falharia mesmo "funcionando")

- Animal vendido aparecendo como **ativo** em qualquer lista/contagem — inclusive
  em aparelhos com **versão antiga do app** e no painel web.
- Perder receita do histórico porque o animal foi removido.
- Venda que não funciona **offline** (o app é offline-first; tudo grava no
  ObjectBox e o sync propaga).
- Contagem de vagas do plano errada após vender/desfazer.
- **Sêmens** podendo ser vendidos.

## Restrições

- Offline-first: gravação no ObjectBox via repositórios (`BaseSyncRepository`);
  nunca escrever direto no Firestore pela tela.
- Exclusão = soft delete (`excluido`), nunca `delete()`.
- Animais vivem em `tecnico/{t}/animaisProdutores/{id}` (campo
  `uidTecnicoPropriedade` aponta a propriedade); propriedades em
  `tecnico/{t}/propriedades/{p}`.
- `firebase/` está fora de sincronia com produção: **ler as regras publicadas**
  antes de deployar e usar a conta `tecmuutecnologia@`.
- Mudança de schema ObjectBox e pacote novo exigem **build completo** (não basta
  hot reload); no emulador isso apaga o login e força ressync.
- `AnimaisProdutoresStruct` é mantido; o adapter tem teste round-trip — campos
  novos no animal precisam passar por ele.
- Padrão visual de listas: `docs/padrao-layout-listas.md` (abas pílula, painel).
- Sêmens nunca vendidos; touros podem.

## Abordagens consideradas

| | Abordagem | Trade-off |
|---|---|---|
| **A (escolhida)** | **Coleção própria `vendasAnimais`** em `tecnico/{t}/propriedades/{p}/vendasAnimais`, entidade ObjectBox nova + repositório de sync espelhando o `financeiro`. | Venda independente do animal (sobrevive à remoção, preserva histórico de revenda). Custo: regra nova no Firestore + schema novo (build completo). |
| B | Só campos no animal (data/valor); relatório lê animais, inclusive removidos. | Sem regra/entidade nova, mas a receita fica presa ao animal; vender → desfazer → vender sobrescreve histórico. Contraria o requisito 6. |
| C | Gravar a venda como documento da coleção `financeiro` com um "tipo". | Reaproveita sync/regras, mas versões antigas listariam cada venda como um relatório mensal vazio. Descartada. |

Marcação do animal vendido — escolhido: **manter `status = 'Descarte'`** e
acrescentar `tipoBaixa = 'venda'`. Alternativa rejeitada: status novo
`Vendido`, que faria versões antigas e todos os filtros `ehDescarte` tratarem o
animal vendido como ativo.

Arrasto — escolhido: pacote **`flutter_slidable`**. Alternativa rejeitada:
implementação manual (mais código, mesmo resultado).

## Desenho

### Dados

**Animal** (`AnimalEntity` + struct/adapter + payload Firestore) — campos novos:
- `tipoBaixa` (`String?`): `'descarte'` | `'venda'`. Ausente em descartes
  antigos ⇒ tratado como descarte.
- `statusAnterior` (`String?`) e `idStatusAnteriorAnimal` (`int?`): status do
  animal antes da baixa, para o desfazer.
- `dtVendaAnimal` (`String?`, mesmo formato de `dtDescarteAnimal`) e
  `valorVendaAnimal` (`double?`): cópia para exibir no card da aba Vendidos.
- `idVendaAtual` (`String?`): firestoreId da venda vigente, para o desfazer
  localizar o registro.

Venda = `status: 'Descarte'`, `tipoBaixa: 'venda'`,
`dtDescarteAnimal` = data da venda, `motivoDescarteAnimal: 'Venda'` (assim
telas/versões antigas que mostram o motivo exibem algo coerente), mais os campos
acima.

**Venda** (`VendaAnimalEntity`, coleção `vendasAnimais` sob a propriedade):
- `firestoreId`, `parentPath` (= path da propriedade), campos de sync padrão
  (`isDeleted`/`excluido`, carimbos) iguais aos do `FinanceiroEntity`.
- `animalId` (firestoreId do animal), `nomeAnimal`, `brincoAnimal`,
  `grupoAnimal` — **cópia** no momento da venda, para o relatório não depender
  do animal existir.
- `dtVenda` (data; guardar de forma ordenável — o builder escolhe entre
  `DateTime`/timestamp e string, mantendo coerência com o resto do app),
  `valorVenda` (`double`, reais).
- `uidTecnicoPath`, `uidPropriedadePath` como no financeiro.

### Operações (num serviço de aplicação, ex. `features/animais/application/baixa_animal.dart`)

- **Vender(animal, data, valor)**: cria `VendaAnimal`; atualiza o animal
  (status Descarte, tipoBaixa venda, statusAnterior, dt/valor, idVendaAtual);
  devolve a vaga se o animal ocupava (mesma regra do descarte atual:
  `animalOcupaVaga` antes do update + `devolverCotaAnimais`). Bloqueado para
  sêmens e para animal já **vendido**.
- **Vender um descartado** (decisão do usuário): permitido direto da aba
  Descarte, sem passar pelo rebanho e **sem mexer em vagas** (já não ocupava).
  Grava `statusAnterior = 'Descarte'` (e `tipoBaixaAnterior = 'descarte'`, com o
  motivo/data do descarte preservados em campos `motivoDescarteAnterior` /
  `dtDescarteAnterior`), de modo que **desfazer essa venda devolve o animal aos
  Descartados**, não ao rebanho, e sem tocar em vagas.
- **Descartar**: comportamento atual + grava `tipoBaixa: 'descarte'` e
  `statusAnterior`. O formulário de descarte existente (`DescarteAnimalWidget`)
  passa a chamar este serviço.
- **Desfazer venda**: soft delete da `VendaAnimal` vigente; animal volta para
  `statusAnterior`/`idStatusAnteriorAnimal` (ou `'Vazia'`/2 se ausente) e limpa
  os campos de baixa; ocupa vaga de novo com `garantirVagaAnimal` antes (como o
  Restaurar atual).
- **Desfazer descarte**: igual ao Restaurar atual, mas volta ao
  `statusAnterior` quando existir (descartes antigos continuam voltando como
  Vazia).
- **Remover permanentemente**: soft delete do animal (atual). **Não** mexe na
  venda.

### Telas

- **Lista de animais**: trocar o `Dismissible` de `AnimalGroupListView` por
  `Slidable` com duas ações (Vender, Descartar). Vender some na aba Sêmens (lá
  fica só Descartar). Mantém a regra atual de só liberar com
  `permiteDescarte` e não oferecer para animal já em baixa.
- **Bezerros**: botão Vender visível no card (sem arrastar), além do arrasto.
- **Modal Vender**: bottom sheet no mesmo estilo do descarte; campo data
  (pré-preenchido com hoje, seletor de data) e valor (máscara R$), ambos
  obrigatórios; Salvar valida e confirma.
- **Editar animal**: botões Vender e Descartar (Vender oculto para sêmens;
  ambos ocultos se o animal já estiver em baixa). Após a ação, sai da tela de
  edição.
- **Aba Descarte (Secas)**: filtro interno **Descartados | Vendidos**. Card de
  vendido mostra data e valor; ações Desfazer venda / Remover. Card de
  descartado: Restaurar (renomear para "Desfazer descarte") / **Vender** /
  Remover.
- **Lote na aba Descarte** (decisão do builder): a seleção vale **só para o
  filtro aberto** — trocar de filtro limpa a seleção. Em Descartados o lote é
  "Desfazer descarte" + "Remover" (como hoje); em Vendidos é "Desfazer venda" +
  "Remover", com confirmação que diz explicitamente que a receita sai do
  Financeiro. Nunca um lote misto.
- **Filtros**: vendido = `status == 'Descarte' && tipoBaixa == 'venda'`;
  descartado = `status == 'Descarte' && tipoBaixa != 'venda'`. Nunca filtrar só
  por `tipoBaixa`.
- **Financeiro**: `RelatorioFinanceiroPage` ganha abas pílula **Relatórios |
  Vendas**. Vendas: agrupado por mês (ex. "Novembro 2026 — R$ 12.400,00"), cada
  linha com nome/brinco, data e valor; estado vazio quando não houver vendas. O
  botão "novo relatório" do rodapé só na aba Relatórios.

### Sync e regras

- `VendaAnimal` segue o financeiro em todos os pontos: download inicial por
  propriedade, push de modificados, escuta/pull delta entre aparelhos e
  progresso de sincronização.
- Regra Firestore nova para `tecnico/{t}/propriedades/{p}/vendasAnimais/{doc}`
  (e `{path=**}/vendasAnimais` se o padrão do financeiro usar), copiando as
  permissões do `financeiro` **das regras publicadas**. Deploy só com
  autorização do usuário.
- **Ordem de publicação** (decisão do builder): a regra vai para produção
  **antes** de qualquer versão do app com a venda. Sem chave de recurso. O plano
  inclui verificar que a fila de pendências **não descarta** uma operação
  negada por permissão (continua pendente e tenta de novo).

### Versões antigas restaurando um vendido (decisão do builder)

Uma versão antiga só tem "Restaurar" e grava `status: 'Vazia'`, deixando
`tipoBaixa`/`idVendaAtual` no documento e a venda ativa. O app novo **não apaga
a venda sozinho** (apagar receita em silêncio é pior que mantê-la): como os
filtros exigem `status == 'Descarte'`, o animal aparece normalmente como ativo;
os campos de baixa remanescentes são ignorados e limpos na próxima baixa/edição
desse animal pelo app novo. A venda continua no Financeiro até alguém desfazê-la
— limitação aceita enquanto houver versões antigas em uso.

## Decisões do usuário

- Venda fica no Financeiro mesmo removendo o animal → coleção própria (A).
- Bezerros: botão Vender fixo no card, além do arrasto.
- Vendas não entram nos relatórios mensais; aba separada.
- Desfazer volta ao status anterior.
- Animal descartado pode ser vendido direto; desfazer essa venda o devolve aos
  Descartados.
- `tipoBaixa` em vez de status novo; `flutter_slidable` para o arrasto.

## Deixado para o builder

- Nome exato de arquivos/classes, formato de armazenamento da data da venda.
- Visual do card vendido e do resumo mensal, seguindo `padrao-layout-listas`.
- Testes: unitários do serviço de baixa (vender/desfazer/vaga/sêmen) e do
  agrupamento por mês; round-trip do adapter com os campos novos.
