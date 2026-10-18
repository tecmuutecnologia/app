# Padrão de layout — telas com lista

Referência: tela **Animais em secagem** (`lib/features/secas/presentation/pages/secas_page.dart`).
Toda tela que mostra uma lista de itens (animais, visitas, receituários…) segue este mapa.

## Mapa

```
┌──────────────────────────────────────────┐
│  CABEÇALHO degradê, reto, 64pt           │
├──────────────────────────────────────────┤ ← PainelLista: branco, RETO (raio 0),
│ 10│ [🔍 Pesquisar…       ] [⇅ Ação ] │10   │   sombra AppTokens.softShadow
│   │  busca 44pt, raio 10   botão 44pt │     │
│   │  (linhas extras opcionais, 8pt)   │     │
│   │ [Aba 1  92][Aba 2  0][Aba 3 …→        │ ← AbasPilula: 36pt, raio 10, rola
├──────────────────────────────────────────┤
│ fundo cinza (primaryBackground)          │
│ 12┌──────────────────────────────┐12     │ ← cards brancos (AppCard/sombra)
│   │ avatar  Nome/brinco          │       │
│   │ [faixa de DATAS/infos]       │       │ ← informações primeiro
│   │ [Ação] [Ação] [Ação]         │       │ ← botões por último
│   └──────────────────────────────┘       │
└──────────────────────────────────────────┘
```

## Regras

| Elemento | Regra |
|---|---|
| Cabeçalho | `CabecalhoTela(titulo:, online: _respostaNet ?? true)` (`lib/core/ui/cabecalho_tela.dart`): degradê laranja→rosa, reto, 64pt; `aoVoltar` só quando o voltar faz algo além de `safePop` (ex.: sair do modo de seleção nas Secas) |
| Fundo da tela | `Scaffold.backgroundColor = primaryBackground` (cinza claro) — é o contraste que destaca painel e cards brancos |
| Painel | `PainelLista` (`lib/core/ui/painel_lista.dart`): branco, sem arredondamento, com sombra suave; contém busca, linhas extras e abas |
| Margem do painel | `LayoutLista.margemPainel` = 10 |
| Busca | `CampoBuscaLista`: 44pt, raio 10, **dica** (não rótulo flutuante), ícone sem caixa de 48pt |
| Botão ao lado da busca | mesma altura da busca: `BotaoOrdenacao(alturaMinima: LayoutLista.alturaControle)` |
| Linhas extras (ex.: chips de ordem) | em `PainelLista.linhas`, chips de 36pt (`LayoutLista.alturaChip`) |
| Ordenação | **sempre** os chips `SeletorOrdemAnimais` (Nome A-Z / Brinco, tocar no ativo inverte) numa linha do painel, iguais aos da lista de animais — não o botão "Menor/Maior". Telas com `AnimaisProdutoresStruct` ordenam com `ordenarStructs` (`features/animais/application/ordenacao_animais.dart`) |
| Abas | `AbasPilula` (`lib/core/ui/abas_pilula.dart`) no lugar do `FlutterFlowButtonTabBar`: 36pt, raio 10, ativa roxa (`AppTokens.secondary`) com brilho, inativas cinza; **contador** por aba quando a contagem é barata; rola sozinha até a aba ativa |
| Lista | começa 8pt abaixo do painel; cards com margem lateral 12 |
| Card | topo: avatar + título; depois a faixa de **informações/datas**; **botões por último**, dividindo a largura em partes iguais |
| Raios | controles do painel 10; cards seguem `AppTokens.radius` (16) |
| Componentes do card | `lib/core/ui/card_animal_lista.dart`: `CartaoLista` (moldura + toque), `ConteudoCardAnimal` (avatar, título, `selo`, `info`, `acoes`), `InfoAnimal`, `FaixaInfoAnimal`, `LinhaAcoes`, `SeloStatus`, `opcoesBotaoCard`, `tituloNomeBrinco` |
| Ordem das ações | fluxo positivo primeiro, ação **negativa/destrutiva por último, na ponta direita** (DG-, Aborto) — longe do botão mais usado |
| Cores das ações | negativo = vermelho (`error`/`AppTokens.negativo`); confirmação positiva = verde `AppTokens.positivo`; PP = verde-azulado `0xFF0F9488`; secagem = verde `AppTokens.positivo` (azul foi testado e destoou da paleta); ações de registro (Fez Cio, Secagem, Ação do exame) = verde `AppTokens.positivo`; laranja `AppTokens.brand` só onde já é a ação característica da tela (ex.: Inseminar, Pré-parto). **Evitar roxo em botões de ação** |
| Subtítulo | `ConteudoCardAnimal(subtitulo: item.status)` quando a tela mistura status (lista completa, recria) |
| Status do animal | `SeloStatus` ao lado do título (ex.: "Inseminada"), não texto solto colorido |
| Painel sem abas | `PainelLista` sem `abas` (ex.: inseminações) — o painel fica FIXO e só a lista rola |

## Checklist ao migrar uma tela

1. Trocar o `appBar` por `CabecalhoTela` e o fundo do `Scaffold` para `primaryBackground`.
2. Substituir busca + `FlutterFlowButtonTabBar` por `PainelLista(busca: CampoBuscaLista(...), acaoBusca: ..., linhas: [...], abas: AbasPilula(...))`.
3. Tirar paddings próprios da busca/abas (o painel já aplica as margens).
4. Contadores nas abas usando o MESMO filtro da lista (com a busca aplicada), senão o número diverge do que aparece.
5. Montar o card com `CartaoLista` + `ConteudoCardAnimal` (informações acima, botões abaixo); dado ausente aparece como '—'.
6. Remover imports/campos que ficarem órfãos (`flutter_flow_button_tabbar.dart`, validators de busca).
7. Validar no simulador com o usuário antes de passar para a próxima tela.

## Telas

| Tela | Status |
|---|---|
| Animais em secagem (secas) | ✅ referência |
| Animais (lista_animais) | ✅ |
| Inseminações (lista_inseminacoes) | ✅ |
| Diagnóstico de gestação | ✅ |
| Prenhas | ✅ |
| Exame ginecológico | ✅ |
| Recria | ✅ |
| Lista completa | 🔄 aplicado, aguardando validação |
| Calendário sanitário (seleção de animal) | ⏳ |
| Demais telas com lista | ⏳ levantar ao entrar em cada uma |

## Armadilha conhecida

Não usar `AnimatedContainer` com `alignment` para elementos que mudam de "altura livre" para altura fixa: no hot reload a animação tenta interpolar restrições infinitas e dispara assert em `BoxConstraints.lerp`. Por isso o contador da aba é um `Container` simples.
