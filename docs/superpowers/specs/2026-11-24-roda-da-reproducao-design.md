# Roda da Reprodução — desenho

Branch: `feat/roda-da-produtividade` · 24/11/2026

## Por quê

Adaptar ao app a "Roda da Reprodução" da Embrapa (programa Balde Cheio; manual
em https://www.youtube.com/watch?v=KGZwovot5cc). O produtor e o técnico querem
duas coisas numa tela só:

1. **bater o olho e saber o que fazer na semana** (parir, secar, DG, cio,
   avaliação pós-parto, atrasadas);
2. **ter uma visão panorâmica do rebanho** num retrato único do ciclo.

As listas atuais (inseminações, DG, prenhas, secas, exame) já resolvem cada
evento isolado; a roda junta tudo e mostra **quem está fora da fase**.

## Metas, não-metas, anti-metas

- **Metas:** tela de leitura em cima dos dados que o app já tem (ObjectBox,
  funciona offline); atalhos para as janelas de registro que já existem;
  mesma tela para produtor e técnico.
- **Não-metas (v1):** imprimir/compartilhar a imagem da roda; importar arquivo
  da Embrapa; busca por número; configurar os dias das faixas; versão web.
- **Anti-metas:** criar um cadastro paralelo de eventos (tudo é registrado
  pelas janelas existentes); dados fictícios na tela real; gravar qualquer
  coisa ao "avançar o tempo".

## Abordagens consideradas

| Abordagem | Troca | Escolha |
|---|---|---|
| **CustomPainter próprio + regras em Dart puro** (evolução do spike) | controle total do desenho, sem dependência nova, regra testável | ✅ escolhida |
| Biblioteca de gráfico radial (fl_chart/syncfusion) | menos código de desenho, mas não faz bolinhas empilhadas nem faixas com marcas; dependência nova | ✗ |
| WebView com o HTML da maquete | reaproveita a maquete, mas foge do padrão do app, sem offline confiável e sem integrar com as janelas | ✗ |

## Decisões do usuário

- Aborto: mantém a posição pelo último parto; indução de lactação: a data
  da indução vale como parto (aprovado em 24/11).
- **Paleta Embrapa** (fiel ao original): pós-parto vermelho `#E5482F`,
  cobertura amarelo `#F2C230` (número escuro), prenhe azul `#2F7FD8`, seca
  verde `#7AA64A`; novilhas rosa — coberta `#F6B3C6` (número escuro), prenhe
  `#E4589A`. Faixas sólidas com marcas a cada 7 dias. Cabeçalho segue o
  degradê padrão do app (`CabecalhoTela`).
- Tela para **produtores e técnicos**.
- Lógica do vídeo/prints da Embrapa (abaixo).

## Regras do ciclo (365 dias, "HOJE · PARTO" fixo embaixo, sentido horário)

| Dias | Faixa | Marcas |
|---|---|---|
| 0–83 | Pós-parto | 30, 45, 60 |
| 83–143 | Cobertura | 83 "Cobrir", 104 "Cio 21d", 123 "DG 40d" |
| 143–305 | Prenhe | — |
| 305–365 | Seca | 305 "Secar", 335 "30" |

**Posição (dia do ciclo) na data D:**
- coberta (Inseminada, Inseminada PP, Prenha, Seca, Pré Parto):
  `365 − (partoPrevisto − D)`, usando `dtPartoPrevisto` ou, se faltar,
  `IA + 280` (`somarDataParto`, mesma conta do app). **Gestação = 280 dias
  do app, não os 282 da Embrapa**: assim a vaca chega em "HOJE · PARTO" no
  dia do parto previsto que o app já mostra, e a secagem prevista do app
  (IA + 220) cai exatamente na marca "Secar" (305). A IA fica no dia 85,
  2 dias depois da marca "Cobrir" (83) — irrelevante na leitura;
- vazia com `dtUltimoParto`: `D − parto`. DG−, "Fez cio" e **aborto** não
  mudam a âncora: a vaca segue posicionada pelo último parto (regra da
  Embrapa; a abortada aparece em Atrasadas, que é o que se quer);
- vaca em **indução de lactação** (`dtInducaoLactacao` mais recente que
  `dtUltimoParto`): a data da indução vale como parto (decisão do usuário);
- não entra na roda: novilha vazia, bezerra, recria, descarte/vendida,
  animal sem nenhuma data. Vazia com > 365 dias pós-parto sai da roda e é
  contada como "**+N fora do ciclo**" no centro (e entra em Atrasadas).
- Datas são `String` na entidade: usar o mesmo parser das telas de Secas/Prenhas;
  a data-sentinela 31/12/2050 conta como "sem data".

**Cor da bolinha = estado real** (status); **faixa = onde deveria estar**.
Bolinhas da mesma data empilham para dentro no raio; se não houver espaço,
deslizam alguns dias para o lado (sem sobrepor).

**Alerta ("fora da fase")** — anel escuro + selo "!" vermelho:
- vazia com > 83 dias pós-parto (sem cobertura);
- inseminada com > 60 dias da IA sem DG (DG+ anterior à IA atual não conta);
- prenhe com > 312 dias (secagem atrasada) — **só vacas**; novilha não seca;
- prenhe/seca/pré-parto com parto atrasado > 3 dias;
- fora do ciclo (> 365).

## Tela

```
CabecalhoTela "Roda da Reprodução"
─ Painel branco ──────────────────────
  propriedade · data
  RODA (pinça p/ zoom; toque na faixa filtra; toque na bolinha abre a vaca)
  contadores por faixa [11 Pós-parto][21 Cobertura][13 Prenhe][10 Seca]
  [Hoje][+7 dias][+30 dias]   (≠ hoje → aviso "Simulação: se nada for registrado")
─ "Esta semana" ──────────────────────
  AbasPilula c/ contador: Parir · Secar · Diagnóstico · Cio 21d · Pós-parto 30d · Atrasadas
  cards CartaoLista/ConteudoCardAnimal + botões das janelas existentes
```

**Abas (janela = próximos 7 dias a partir da data exibida):**
- Parir: coberta com parto previsto ≤ 7 dias, ou atrasado → *Registrar parto*.
- Secar: **vaca** prenhe (não seca) no dia ≥ 298 → *Registrar secagem*
  (novilhas ficam fora, como em Prenhas/Secas: `ehVacaPrenha`).
- Diagnóstico: inseminada sem DG com dias pós-IA ≥ `diasDg` da propriedade
  (o mesmo critério da tela de DG, `vencidosParaDg`, que inclui novilhas) →
  os mesmos botões e o mesmo fluxo da tela de DG (PP → DG+ → DG−;
  `podeRegistrarDgMais`).
- Cio 21d: inseminada com 18–24 dias pós-IA → *Fez cio*.
- Pós-parto 30d: vazia com 28–45 dias pós-parto → *Exame ginecológico*.
- Atrasadas: todos os alertas → ação conforme o caso.

**Contadores por faixa contam pelo estado (cor)**, igual à legenda: "13
Prenhe" = 13 animais azuis, onde quer que estejam. Toque na faixa troca a
lista por **todos os animais posicionados naquela faixa** (independente da
aba; alertas primeiro), com o chip "Faixa Cobertura · Limpar", **sem rolar a
tela para longe da roda**. Toque na bolinha abre folha inferior: datas
(último parto, dias pós-parto, última IA, parto previsto), aviso de fase,
ações e *Prontuário*. Após registrar um evento, a roda recalcula na hora.

Seguir `docs/padrao-layout-listas.md` (cores de ação, ordem de botões,
`SeloStatus`, etc.).

**Brinco na bolinha:** até 4 dígitos inteiro; 5+ dígitos mostra os 4 últimos
(o número completo aparece na folha). Sem brinco: inicial do nome.

## Onde entra

- Produtor: card "Roda da Reprodução" em `PropriedadeMenuGrid`.
- Técnico: card no menu da propriedade (`inicio_propriedade_page.dart`).
- O spike (`roda_reproducao_spike_page.dart` + card "Roda (maquete)") é
  removido; o desenho e a geometria podem ser aproveitados.

## Estrutura (chamada do construtor)

- `lib/domain/roda_reproducao/`: regras puras (dia do ciclo, faixa, alerta,
  tarefas da semana), sem Flutter, **com testes unitários** em
  `test/domain/roda_reproducao/` cobrindo cada regra acima (inclusive
  novilha, DG antigo, fora do ciclo, +7/+30).
- `lib/features/roda_reproducao/presentation/`: página, pintor da roda,
  folha da vaca.

## Deixado ao construtor

Organização interna dos widgets, ícone do card no menu, animação de
transição ao avançar a data, nomes de classes.

## Calls feitas por mim (Claude) — conferir

- Título da tela "Roda da Reprodução" (nome da Embrapa); a branch mantém
  "roda-da-produtividade".
- Aba Diagnóstico usa o `diasDg` da propriedade; a marca "DG 40d" da roda
  fica fixa como no original.
- Regra do brinco de 5+ dígitos (4 últimos).
- Imprimir/compartilhar fica para a v2.
- Gestação de 280 dias (app) em vez de 282 (Embrapa).
- Contadores pelo estado; toque na faixa lista a faixa inteira.
- Novilhas fora de "Secar" e de "secagem atrasada"; novilha em Pré Parto =
  rosa de prenhe.
