# Importação de animais via planilha — design

Branch: `feat/importacao-animais-planilha` (a partir da `dev`).
Modelo de planilha: `documentacao/Modelo Planilha de IMPORAÇÃO DE ANIMAIS.xlsx`.

## 1. Intenção

O técnico, ao começar a atender uma fazenda, precisa passar para o app o rebanho
que está num caderno ou em outro sistema. Hoje ele cadastra animal por animal.
A importação deixa ele preencher uma planilha padrão (no computador ou no
celular) e subir o rebanho de uma vez, sem criar duplicatas se subir de novo.

Junto, o limite de animais do plano passa a valer de verdade: hoje o app só
desconta o saldo, nunca bloqueia, e nunca devolve a vaga de um animal
descartado.

### Objetivos
- Botão discreto na lista de animais da propriedade → tela "Importar animais".
- "Baixar planilha padrão": gera o `.xlsx` e abre o menu de compartilhar do
  celular (salvar em arquivos, e-mail, WhatsApp).
- "Importar planilha": escolher `.xlsx` no aparelho, validar o cabeçalho,
  importar com barra de progresso, mostrar o resultado (importados, recusados,
  linha + motivo de cada recusa).
- Reimportar a mesma planilha não duplica (nome + brinco).
- Vagas do plano: descarte e exclusão devolvem a vaga; cadastro manual,
  nascimento (registro de parto) e importação respeitam o limite.
- Limite de produtores com o mesmo tratamento (limite do plano, recálculo,
  bloqueio na ativação da conta).

### Não-objetivos
- Importar histórico de ações (inseminações anteriores, partos antigos, vacinas).
- Atualizar animais já existentes pela planilha (a linha duplicada é recusada,
  não mesclada).
- Outros formatos (CSV, `.xls` antigo, Google Sheets por link).
- Importar no aparelho do produtor (ver §7).

### Anti-objetivos (seria fracasso mesmo funcionando)
- Animal importado com dados diferentes do que o cadastro manual produziria
  para a mesma entrada (ex.: prenha sem previsão de parto).
- Remover ou esconder animais de quem já passou do limite. Quem passou só fica
  impedido de cadastrar novos.
- Duplicar animais ao reimportar.
- Travar a tela ou perder a importação no meio por falta de internet.

## 2. Quem usa e como

Técnico, na lista de animais de uma propriedade. Planilhas digitadas à mão ou
exportadas de outro sistema — portanto com variações de escrita.

## 3. A planilha

Uma aba, cabeçalho na linha 1, dados a partir da linha 2. Colunas, nesta ordem
(é a ordem do arquivo modelo):

| Col | Cabeçalho no modelo | Obrig. | Campo no app |
|---|---|---|---|
| A | Nome (opcional) | não* | `nomeAnimal` |
| B | Número* | não* | `brincoAnimal` / `brincoAnimalOrder` |
| C | Raça* | sim | `racaAnimal` |
| D | Categoria* | sim | `grupoAnimal` |
| E | Data de Nascimento(opcional) | não | `dtNascimento` |
| F | Pai (opcional) | não | `touro` ("Touro (Pai)") |
| G | Mãe (opcional) | não | `vaca` ("Vaca (Mãe)") |
| H | Parto (opcional) | não | último parto |
| I | Inseminação (opcional) | não | última inseminação |
| J | Status* | ver regras | `status` |

\* Nome **ou** Número obrigatório (mesma regra do cadastro manual: "Preencha ao
menos um dos campos"). O cabeçalho do modelo marca "Número*", mas o app aceita
animal só com nome; a importação segue o app.

**Validação do cabeçalho:** compara as 10 células da linha 1 com o modelo,
ignorando maiúsculas, acentos, espaços e o asterisco/"(opcional)". Se não bater,
a importação nem começa e a tela diz qual coluna está fora de ordem ou faltando
(ex.: "A coluna D deveria ser Categoria e está Status").

**Datas:** aceitar célula de data do Excel e texto `dd/mm/aaaa` (também
`dd/mm/aa` e `dd-mm-aaaa`). O pacote `excel` 2.1.0 do app entrega a célula de
data do modelo como texto ISO (`2021-11-20T00:00:00.000`); número serial
também é aceito, para planilhas salvas por outros programas. Data inválida ou no
futuro (nascimento, parto, inseminação) recusa a linha.

**Número/brinco:** inteiro. Célula numérica ou texto só com dígitos. Outro
conteúdo recusa a linha.

**Vocabulário tolerante** (decisão aprovada pelo usuário): a planilha é feita à
mão, então valores são normalizados antes de validar — sem acento, sem caixa,
sem espaços extras, singular/plural:
- Categoria: "Vaca"→"Vacas", "Novilha"→"Novilhas", "Bezerra"→"Bezerras",
  "Bezerro"→"Bezerros", "Touro"→"Touros", "Sêmen/Semen"→"Sêmens".
- Status: "InseminadaPP"/"Inseminada pp"→"Inseminada PP", "Pre parto"/
  "Pré-parto"→"Pré Parto", demais pelos valores do app (Vazia, Inseminada,
  Prenha, Seca, …).
- Raça: casa com a lista de raças do app (`ReferenciaRepository().racas()`) por
  nome normalizado, por prefixo único (ex.: "Ho"→"Holandesa" se só uma raça
  começar com "ho") e por siglas conhecidas a definir na implementação a partir
  da lista real. Sem casamento único → linha recusada com "raça não reconhecida:
  <valor>".

O conjunto exato de status válidos por categoria e as datas exigidas por status
são os do cadastro manual (`cadastrar_novo_animal_page.dart`), não uma lista
nova.

## 4. Regras de criação

Cada linha válida vira exatamente o animal que o cadastro manual criaria com os
mesmos valores: mesmos campos derivados (`dtPartoPrevisto`, `dtSecPrevista`,
`dtPrePartoPrevista`, `dtDgMais`, `idStatusAnimal`, `brincoAnimal` = -1 e
`brincoAnimalOrder` = 999999 quando sem número, …) e as mesmas exigências por status (ex.: Inseminada,
Prenha, Inseminada PP e Pré Parto exigem data de inseminação; Seca só para
Vacas). Hoje essa regra vive inline numa cadeia de `if`s da página de cadastro;
ela deve ser extraída para uma função pura de domínio usada pelas duas entradas
(cadastro e importação), com testes. A mensagem de erro de cada exigência vira o
"motivo" da recusa na importação.

Criação via `criarAnimalOffline` (offline-first: grava no ObjectBox com
`needsSync`; o sync sobe quando houver internet) e débito do saldo como hoje.

**Duplicidade:** recusa a linha se já existe animal ativo na propriedade com o
mesmo par nome + brinco (`existeAnimalAtivoComNomeBrinco`, a regra do cadastro
manual), ou se uma linha anterior da mesma planilha tem o mesmo par. Motivo:
"já cadastrado" / "repetido na linha N".

## 5. Fluxo da tela

1. Botão discreto na lista de animais (ícone de upload no cabeçalho/menu, não um
   botão grande) → tela "Importar animais" (padrão `CabecalhoTela`).
2. Duas ações: **Baixar planilha padrão** e **Importar planilha**, com uma linha
   de instrução cada.
3. Baixar: o arquivo é o modelo (asset do app, cópia de
   `documentacao/Modelo…xlsx` com a linha de exemplo) → menu de compartilhar.
4. Importar: seletor de arquivo filtrado em `.xlsx` → lê → valida cabeçalho →
   **pré-análise** de todas as linhas (sem gravar): válidas, recusadas.
5. Se as válidas passam das vagas restantes do plano: aviso antes de gravar —
   "Sua conta permite mais X animais e a planilha tem Y válidos. Os Y−X últimos
   ficarão de fora." Opções: Importar os X / Cancelar. Com zero vagas: só
   informa, não importa.
6. Gravação com barra de progresso (n de total), sem travar a UI.
7. Resultado: importados, não importados, e lista "linha — identificação —
   motivo". Opção de voltar para a lista de animais.

Planilha vazia (só cabeçalho), arquivo que não é xlsx ou corrompido: mensagem
clara, nada gravado.

## 6. Vagas do plano

Campos no documento do técnico: `limiteAnimaisContratado`,
`restanteLimiteAnimais` (saldo), `quantidadeAnimaisCadastrados`.

**Correção (vem primeiro, pode ir sozinha para a `dev`):**
- Descarte devolve a vaga: `restanteLimiteAnimais +1`,
  `quantidadeAnimaisCadastrados −1`, offline-first (local na hora + delta na
  fila, como `debitarCotaAnimais`). O descarte hoje é irreversível no app.
- Exclusão de animal (`AnimalRepository.delete`) devolve a vaga, se o animal não
  estava descartado (não devolver duas vezes).
- Não remover nem esconder nenhum animal de quem já passou do limite.

**Limite vem do plano ativo (achado em 2026-11-04):** nada no app nem nas
functions publicadas (só `addFcmToken`, `initStripePayment`,
`initStripeTestPayment`, `onUserDeleted`, `sendPushNotificationsTrigger`)
atualiza `limiteAnimaisContratado` quando o técnico troca de plano; a tela de
planos grava só `assinatura-tecnico`/`assinatura-ativa-tecnico`. O campo fica
com os 50 gravados em `completar_perfil_tecnico_page.dart`. O plano já tem
`planos-tecnicos.limiteAnimais`, que ninguém lê.
- Fonte do limite: a cadeia `assinatura-tecnico (idTecnico)` →
  `assinatura-ativa-tecnico (idAssinaturaTecnico)` → `idPlano` →
  `planos-tecnicos.limiteAnimais`.
- A tela de planos, ao contratar (pago ou Start), grava o novo
  `limiteAnimaisContratado` no técnico.

**Recálculo na sincronização (decisão do usuário):** no aparelho do técnico,
ao fim da sincronização (download completo e pull periódico, online), o app
lê o limite do plano ativo e recalcula
`restanteLimiteAnimais = limite − animais ativos` e
`quantidadeAnimaisCadastrados = animais ativos`, onde ativo = não excluído e
não descartado, em todas as propriedades do técnico. Só grava se mudou.
Corrige o erro histórico (descartes antigos nunca devolveram a vaga). Saldo
pode ficar negativo; nenhum animal é removido. Se o plano não puder ser lido
(offline, cadeia incompleta, plano sem `limiteAnimais`), mantém o limite que o
técnico já tem e recalcula só o saldo.
O recálculo grava valores absolutos e por isso só roda quando a fila não tem
incrementos pendentes do técnico (débitos/devoluções de cota): senão um
débito ainda na fila seria descontado duas vezes.

**Limite de produtores (incluído a pedido do usuário em 2026-11-04):** mesmo
tratamento. Fonte: `planos-tecnicos.limitePropriedade` do plano ativo →
`limiteProdutoresContratado`. Recálculo: `restanteLimiteProdutores = limite −
produtores ativos` e `quantidadeProdutoresCadastrados = produtores ativos`, onde
produtor ativo = propriedade do técnico com conta ativada (`contaCriada`),
inclusive as que estão na lixeira (a vaga só volta na exclusão definitiva, como
já faz `devolverVagaProdutor`). Bloqueio: o botão "+" de nova propriedade já
bloqueia sem saldo; passa a bloquear também "Ativar conta" e "Liberar acesso",
que são os pontos que consomem a vaga.

**Cadeia do plano ativo, como está gravada:** cada troca de plano cria um novo
`assinatura-tecnico` e repõe `assinatura-ativa-tecnico.idAssinaturaTecnico`
para ele. Por isso o plano ativo é achado assim: todos os `assinatura-tecnico`
do técnico → o `assinatura-ativa-tecnico` que aponta para um deles (se houver
mais de um, o de `dtAssinatura` mais recente) → `idPlano`. A tela de planos
hoje procura a ativa a partir do PRIMEIRO `assinatura-tecnico` que a consulta
devolve, o que falha a partir da segunda troca (`!` em nulo); a tela passa a
usar a mesma resolução.

**Bloqueio:** sem vaga (saldo ≤ 0), o app não cria animal novo:
- cadastro manual: aviso "Limite de animais do plano atingido" e não salva;
- registro de parto: o parto também é bloqueado (decisão do usuário), com o
  mesmo aviso, antes de gravar qualquer coisa;
- importação: §5 passo 5.

O saldo lido é o do técnico dono da propriedade no ObjectBox.

Decisões do construtor (não discutidas com o usuário, revisar):
- Sêmen continua contando no limite, como hoje (o cadastro já debita sêmen).
- Aparelho sem o documento do técnico no ObjectBox (produtor) não bloqueia:
  offline-first vence; o saldo é corrigido quando o técnico sincronizar.
- Status só é exigido onde o cadastro manual exige (Vacas e Novilhas); para
  as demais categorias a coluna J pode ficar vazia.
- O cadastro manual exige data de nascimento; a planilha não (o modelo marca
  "(opcional)"). A importação segue o modelo.
- Na planilha, o status precisa ser coerente com as datas, pela mesma regra
  que monta as opções do formulário (`opcoesStatusAnimal`): ex. "Vazia" com
  inseminação depois do último parto é recusada.
- Hoje "Inseminada" com parto e sem data de inseminação não salva e não avisa
  nada; a regra extraída devolve a mesma mensagem dos outros status
  ("Data última inseminação vazia…").

## 7. Restrições

- pt-BR em toda a UI.
- Não mudar caminhos do Firestore. Animais continuam em
  `tecnico/{id}/animaisProdutores` com `uidTecnicoPropriedade`.
- Nunca usar `doc.delete()` em coleção sincronizada (exclusão é a marca
  `excluido`, ver `lib/core/sync/exclusao_remota.dart`).
- Pacotes já presentes: `excel` (leitura/escrita), `file_picker` (seletor),
  `path_provider`. Compartilhar exige `share_plus` (dependência nova).
- Importação só no aparelho do técnico (o produtor não vê o botão).
- Plataformas: Android e iOS.

## 8. Deixado para quem constrói
- Onde exatamente fica o botão discreto e o visual da tela, seguindo
  `docs/padrao-layout-listas.md`.
- Tamanho do lote de gravação e como a barra é atualizada.
- Mapa de siglas de raça, a partir da lista real de raças.
