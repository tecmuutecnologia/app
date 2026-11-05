# Importação de animais por planilha e vagas do plano

Guia para quem desenvolve e para quem dá suporte a técnicos. Complementa o
design em `docs/superpowers/specs/2026-11-04-importacao-animais-planilha-design.md`.

## Quem vê o botão

- Só o **técnico logado**, na lista de animais de uma propriedade: ícone de
  upload (`Importar animais`) no cabeçalho.
- Na tela há dois cartões: **Baixar planilha padrão** (abre o menu de
  compartilhar do celular) e **Importar planilha** (seletor de `.xlsx`).
- A importação grava offline-first (ObjectBox com `needsSync`); o envio ao
  Firestore acontece quando houver internet.

## A planilha

Uma aba, cabeçalho na linha 1, dados da linha 2 em diante. Linhas totalmente
vazias são ignoradas. O cabeçalho é conferido coluna a coluna (sem diferenciar
maiúsculas, acentos, espaços, `-`, `.`, `_`, `*` e `(opcional)`); se não bater, nada é lido e a
tela diz, por exemplo, "A coluna D deveria ser Categoria e está Status."

| Col | Campo | Obrigatório | Valores aceitos |
|---|---|---|---|
| A | Nome | Nome **ou** Número | texto livre |
| B | Número | Nome **ou** Número | inteiro não negativo, até 9 dígitos (célula numérica ou texto só com dígitos; 0 vale) |
| C | Raça | sim | nome da raça do app, prefixo único ("Ho") ou sigla |
| D | Categoria | sim | Vacas, Novilhas, Bezerras, Bezerros, Touros, Sêmens |
| E | Data de Nascimento | não | data |
| F | Pai | não | texto (touro) |
| G | Mãe | não | texto (vaca) |
| H | Parto | não | data; **só lida para Vacas e Novilhas** |
| I | Inseminação | não | data; **só lida para Vacas e Novilhas** |
| J | Status | sim para Vacas/Novilhas | ver abaixo; **ignorada nas demais categorias** |

**Raça** (comparação sem acento/caixa/espaços/hífen/ponto): nome exato, depois sigla, depois
prefixo único. Siglas: `ho` Holandesa; `je` Jersey; `gir`/`gi` Gir; `gl`/`gh`
Girolando; `pa`/`ps` Pardo Suíço; `ne` Nelore. A sigla só vale se a raça existir
na lista do app.

**Categoria:** singular ou plural, sem acento ("Vaca", "novilha", "Semen").

**Status** (Vacas e Novilhas): Inseminada, Inseminada PP (também "InseminadaPP"),
Prenha, Seca (só Vacas), Pré Parto (também "Pre parto", "Pré-parto"), Vazia, mais
os status cadastrados no app. O status precisa ser coerente com as datas, pela
mesma regra das opções do formulário (ex.: "Vazia" com inseminação depois do
último parto é recusada).

**Datas:** célula de data do Excel, número serial, ou texto `dd/mm/aaaa`,
`dd/mm/aa` e `dd-mm-aaaa`. Data inexistente ou no futuro recusa a linha. Ano
com 2 dígitos usa como pivô o ano corrente: até ele vira 20xx, acima vira 19xx
(em 2026, "21" = 2021 e "99" = 1999).

**Touros e Sêmens** entram com "libera inseminação" ligado, como o padrão do
cadastro manual. Cada linha vira exatamente o animal que o cadastro manual
criaria (mesma função, `lib/domain/animais/regras_cadastro_animal.dart`).

## Motivos de recusa

O resultado lista "linha - identificação - motivo". Textos como o usuário vê:

| Motivo | Quando |
|---|---|
| `número inválido: <v>` | Número não é inteiro, é negativo ou tem mais de 9 dígitos |
| `raça não informada` / `raça não reconhecida: <v>` | Coluna C vazia / sem casamento único |
| `categoria não informada` / `categoria não reconhecida: <v>` | Coluna D vazia / fora da lista |
| `data inválida na coluna <X>: <v>` | Data ilegível ou inexistente (E, H, I) |
| `data no futuro na coluna <X>: <dd/mm/aaaa>` | Data depois de hoje |
| `status não reconhecido: <v>` | Status fora do vocabulário |
| `status <S> não combina com as datas de parto e inseminação` | Incoerência com as datas |
| `Nome ou brinco obrigatório.` | Linha sem nome e sem número |
| `Status é obrigatório.` | Vaca/Novilha sem status |
| `Data última inseminação vazia ou Touro inseminação não selecionado.` | Inseminada, Prenha, Inseminada PP, Pré Parto sem data de inseminação |
| `O status de "Seca" é permitido somente em vacas.` | Seca em Novilha **com** parto e inseminação depois do parto (datas coerentes); sem parto ou sem datas o motivo é `status Seca não combina com as datas de parto e inseminação` |
| `Status inválido.` | Status que a regra não conhece |
| `já cadastrado` | Já existe animal ativo na propriedade com o mesmo nome + número |
| `repetido na linha N` | Mesmo nome + número de uma linha anterior da planilha |
| `limite do plano atingido` | Válida, mas não coube nas vagas |
| `erro ao gravar` | Falha ao gravar aquela linha |

Mensagens de arquivo (nada é gravado): "Arquivo não é uma planilha .xlsx
válida.", "A planilha não tem animais.", divergência de cabeçalho, e "Sua conta
não tem vagas para novos animais." quando o saldo é zero. Se as válidas passam do
saldo, aparece "Limite do plano": "Sua conta permite mais X animais e a planilha
tem Y válidos. Os Y-X últimos ficarão de fora." (Importar os X / Cancelar).
Reimportar a mesma planilha não duplica (recusa por `já cadastrado`).

## Como o limite é calculado

**Plano ativo:** todos os `assinatura-tecnico` do técnico (`idTecnico`) -> os
`assinatura-ativa-tecnico` que apontam para um deles (`idAssinaturaTecnico`; se
houver mais de um, vale o de `dtAssinatura` mais recente) -> `idPlano` ->
`planos-tecnicos`. Do plano saem `limiteAnimais` e `limitePropriedade`. Cada
troca de plano cria um novo `assinatura-tecnico`, por isso a busca parte de todos
eles, não do primeiro.

**Ativos:**
- Animal ocupa vaga se não foi excluído e não está descartado (touro e sêmen
  contam; só o descarte libera).
- Produtor ocupa vaga se a propriedade do técnico tem conta criada
  (`contaCriada`), inclusive na lixeira (a vaga só volta na exclusão definitiva).

**Saldo:** `restante = limite - ativos` (pode ser negativo; ninguém perde animal,
só fica impedido de cadastrar novos). Se o plano não informa limite (<= 0) ou não
pôde ser lido, mantém o limite que o técnico já tem e recalcula só o saldo.
Campos no documento do técnico: `limiteAnimaisContratado`,
`quantidadeAnimaisCadastrados`, `restanteLimiteAnimais` e os equivalentes
`...Produtores...`. Só grava o que mudou (servidor primeiro, depois ObjectBox).

**Quando o recálculo roda:** no aparelho do técnico, ao fim do download completo
e a cada pull periódico online (`VagasDoPlanoService.recalcular`, chamado por
`offline_first_sync_service.dart`).

**Quando é pulado:**
- fila de sincronização do técnico com operação pendente (débito/devolução de
  cota ainda não enviado; o recálculo grava valores absolutos e o contaria duas
  vezes);
- sincronização inicial incompleta (base local parcial contaria menos animais e
  inflaria o saldo no servidor);
- offline (só roda online);
- aparelho do produtor: o critério é não haver técnico local com `uidPerson` do
  usuário logado. Limitação conhecida: técnico com `uidPerson` gravado como id
  do person fica sem recálculo automático;
- outro recálculo em andamento, ou qualquer erro (nunca derruba o sync).

Descarte e exclusão de animal devolvem a vaga na hora (local + delta na fila).

## O que bloqueia sem vaga

Aviso "Limite de animais do plano atingido." ("Descarte animais ou troque de
plano para cadastrar novos.") e nada é salvo:
- cadastro manual de animal;
- registro de parto **com bezerro** (bloqueia antes de gravar qualquer coisa,
  inclusive a mãe);
- importação (ver acima);
- **Restaurar** um animal do Descarte (tela Secas): ele volta a ocupar vaga, então
  só restaura com vaga e debita a cota. Em lote, ou cabem todos os selecionados
  ou nenhum é restaurado ("Sua conta permite mais X animais. Selecione menos
  animais ou troque de plano.").

Aviso "Limite de produtores do plano atingido." ("Exclua uma propriedade ou
troque de plano para ativar novas contas."): **Ativar conta**. O **"+" de nova
propriedade** (lista de propriedades) também bloqueia com
`restanteLimiteProdutores <= 0` (aviso "Limite propriedades atingida."; já
existia antes desta mudança).

**Não bloqueia:** **Liberar Acesso** (o botão só aparece com conta já criada, a
propriedade já ocupa vaga) e aparelho sem o documento do técnico no ObjectBox
(produtor; offline-first vence, o saldo se corrige quando o técnico sincronizar).

## Checagem manual no console do Firebase

Se um técnico reclama de limite errado:
1. `tecnico/{id}`: veja `limiteAnimaisContratado`, `restanteLimiteAnimais`,
   `quantidadeAnimaisCadastrados` e os campos de produtores.
2. `assinatura-tecnico` com `idTecnico` = `tecnico/{id}`: anote os documentos.
3. `assinatura-ativa-tecnico` cujo `idAssinaturaTecnico` aponta para um deles; se
   houver vários, o de `dtAssinatura` mais recente.
4. Seguir `idPlano` até `planos-tecnicos` e conferir **`limiteAnimais`** e
   **`limitePropriedade`** (precisam existir e ser > 0, senão o app mantém o
   limite antigo).
5. Abrir o app do técnico online e esperar o próximo pull (ou reiniciar) para o
   recálculo corrigir o técnico.

## Atenção para o build

`share_plus` é um **plugin nativo novo**: hot reload/restart não basta, é preciso
um **rebuild completo** (Android e iOS) antes de testar "Baixar planilha padrão".
