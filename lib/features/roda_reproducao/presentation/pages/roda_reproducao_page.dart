/// Roda da Reprodução — adaptação do app da Embrapa (Balde Cheio).
///
/// Lê os animais da propriedade no banco local (funciona offline), desenha o
/// ciclo de 365 dias e lista o que fazer na semana. Os registros usam as
/// mesmas janelas das telas de cada evento; depois de cada um a roda
/// recalcula. Regras em `docs/roda-da-reproducao.md`.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/connectivity/connectivity_service.dart';
import '/core/ui/abas_pilula.dart';
import '/core/ui/app_card.dart';
import '/core/ui/cabecalho_tela.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/painel_lista.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/domain/financeiro/vendas_por_mes.dart' show parseDataBr;
import '/domain/roda_reproducao/ciclo_reproducao.dart';
import '/domain/roda_reproducao/tarefas_semana.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/features/diagnostico_gestacao/presentation/widgets/confirma_pp_widget.dart';
import '/features/diagnostico_gestacao/presentation/widgets/dg_mais_widget.dart';
import '/features/diagnostico_gestacao/presentation/widgets/dg_menos_widget.dart';
import '/features/exame_ginecologico/presentation/widgets/nova_acao_exame_ginecologico_widget.dart';
import '/features/inseminacoes/presentation/widgets/nova_inseminacao_widget.dart';
import '/features/inseminacoes/presentation/widgets/registrar_cio_widget.dart';
import '/features/prenhas/presentation/widgets/registrar_secagem_widget.dart';
import '/features/prontuario/presentation/pages/prontuario_animal_page.dart';
import '/features/secas/presentation/widgets/registrar_parto_widget.dart';
import '../../application/acoes_roda.dart';
import '../../application/animal_roda_adapter.dart';
import '../widgets/card_tarefa_roda.dart';
import '../widgets/roda_widget.dart';

class RodaReproducaoPage extends StatefulWidget {
  const RodaReproducaoPage({
    super.key,
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
    this.carregarAnimais,
    this.agora,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  /// Para testes: fonte dos animais (padrão: ObjectBox da propriedade).
  final List<AnimalEntity> Function()? carregarAnimais;

  /// Para testes: "hoje".
  final DateTime? agora;

  static String routeName = 'rodaReproducao';
  static String routePath = '/rodaReproducao';

  @override
  State<RodaReproducaoPage> createState() => _RodaReproducaoPageState();
}

class _RodaReproducaoPageState extends State<RodaReproducaoPage>
    with SingleTickerProviderStateMixin {
  late final TabController _abas =
      TabController(length: AbaSemana.values.length, vsync: this)
        ..addListener(() {
          if (mounted) setState(() {});
        });
  StreamSubscription<bool>? _conectividade;
  bool _online = true;

  List<AnimalEntity> _animais = [];
  int _avanco = 0;
  FaseRoda? _faixa;

  int get _diasDg => int.tryParse(widget.diasDg ?? '') ?? 30;

  DateTime get _hoje {
    final h = widget.agora ?? DateTime.now();
    return DateTime(h.year, h.month, h.day);
  }

  DateTime get _data => _hoje.add(Duration(days: _avanco));

  @override
  void initState() {
    super.initState();
    _recarregar();
    if (widget.agora == null) {
      _online = ConnectivityService.instance.isOnline;
      _conectividade = ConnectivityService.instance.onStatusChange.listen(
          (online) => mounted ? setState(() => _online = online) : null);
    }
  }

  @override
  void dispose() {
    _conectividade?.cancel();
    _abas.dispose();
    super.dispose();
  }

  void _recarregar() {
    if (widget.carregarAnimais != null) {
      _animais = widget.carregarAnimais!();
    } else if (ObjectBoxService.isInitialized) {
      _animais = AnimalRepository()
          .getAnimaisByPropriedade(widget.uidPropriedade?.path ?? '')
          .where((a) => !a.isDeleted)
          .toList();
    }
  }

  List<PosicaoRoda> _posicoes() => [
        for (final e in _animais)
          if (calcularPosicao(animalRodaDe(e), _data) case final p?) p,
      ];

  AnimalEntity? _entidade(PosicaoRoda p) {
    for (final e in _animais) {
      if ('${e.id}' == p.animal.id) return e;
    }
    return null;
  }

  // -------------------------------------------------------------------------
  // Ações
  // -------------------------------------------------------------------------

  Future<void> _abrirFolha(Widget formulario) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: formulario,
        ),
      ),
    );
    if (!mounted) return;
    setState(_recarregar);
  }

  Future<void> _agir(PosicaoRoda p, AcaoRoda acao) async {
    final e = _entidade(p);
    if (e == null) return;
    final item = animalEntityToStruct(e);
    final w = widget;
    final Widget formulario = switch (acao) {
      AcaoRoda.pp => ConfirmaPpWidget(
          uidPropriedade: w.uidPropriedade,
          nomePropriedade: w.nomePropriedade,
          uidTecnico: w.uidTecnico,
          emailPropriedade: w.emailPropriedade,
          uidAnimaisProdutores: item.uidAnimal,
          uidAnimalOffline: item.uidAnimalOffline,
          grupoPredominante: item.grupoAnimal,
          nomeAnimal: item.nomeAnimal,
          visitaPresencial: w.visitaPresencial,
          diasDg: w.diasDg,
        ),
      AcaoRoda.dgMais => DgMaisWidget(
          uidPropriedade: w.uidPropriedade,
          nomePropriedade: w.nomePropriedade,
          uidTecnico: w.uidTecnico,
          emailPropriedade: w.emailPropriedade,
          uidAnimaisProdutores: item.uidAnimal,
          uidAnimalOffline: item.uidAnimalOffline,
          grupoPredominante: item.grupoAnimal,
          nomeAnimal: item.nomeAnimal,
          visitaPresencial: w.visitaPresencial,
          diasDg: w.diasDg,
        ),
      AcaoRoda.dgMenos => DgMenosWidget(
          uidPropriedade: w.uidPropriedade,
          nomePropriedade: w.nomePropriedade,
          uidTecnico: w.uidTecnico,
          emailPropriedade: w.emailPropriedade,
          uidAnimaisProdutores: item.uidAnimal,
          uidAnimalOffline: item.uidAnimalOffline,
          grupoPredominante: item.grupoAnimal,
          nomeAnimal: item.nomeAnimal,
          visitaPresencial: w.visitaPresencial,
        ),
      AcaoRoda.fezCio => RegistrarCioWidget(
          uidPropriedade: w.uidPropriedade,
          nomePropriedade: w.nomePropriedade,
          uidTecnico: w.uidTecnico,
          emailPropriedade: w.emailPropriedade,
          uidAnimaisProdutores: item.uidAnimal,
          uidAnimalOffline: item.uidAnimalOffline,
          grupoPredominante: item.grupoAnimal,
          nomeAnimal: item.nomeAnimal,
          visitaPresencial: w.visitaPresencial,
          brincoAnimal: item.brincoAnimal.toString(),
          diasDg: w.diasDg,
        ),
      AcaoRoda.inseminar => NovaInseminacaoWidget(
          uidPropriedade: w.uidPropriedade,
          nomePropriedade: w.nomePropriedade,
          uidTecnico: w.uidTecnico,
          emailPropriedade: w.emailPropriedade,
          grupoPredominante: item.grupoAnimal,
          nomeAnimal: item.nomeAnimal,
          visitaPresencial: w.visitaPresencial,
          dtUltimaInseminacao: item.dtUltimaInseminacao,
          brincoAnimal: item.brincoAnimal.toString(),
          diasDg: w.diasDg,
          uidAnimaisProdutores: item.uidAnimal,
          uidAnimalOffline: item.uidAnimalOffline,
        ),
      AcaoRoda.secagem => RegistrarSecagemWidget(
          uidPropriedade: w.uidPropriedade,
          nomePropriedade: w.nomePropriedade,
          uidTecnico: w.uidTecnico,
          emailPropriedade: w.emailPropriedade,
          visitaPresencial: w.visitaPresencial,
          diasDg: w.diasDg,
          uidAnimaisProdutores: item.uidAnimal,
          uidAnimalOffline: item.uidAnimalOffline,
          nomeAnimal: item.nomeAnimal,
          brincoAnimal: item.brincoAnimal.toString(),
          grupoAnimal: item.grupoAnimal,
          dtSecPrevista: parseDataBr(item.dtSecPrevista) ??
              p.partoPrevistoEfetivo
                  ?.subtract(const Duration(days: kCiclo - kDiaSecar)),
        ),
      AcaoRoda.parto => RegistrarPartoWidget(
          uidPropriedade: w.uidPropriedade,
          nomePropriedade: w.nomePropriedade,
          uidTecnico: w.uidTecnico,
          emailPropriedade: w.emailPropriedade,
          visitaPresencial: w.visitaPresencial,
          diasDg: w.diasDg,
          uidAnimaisProdutores: item.uidAnimal,
          uidAnimalOffline: item.uidAnimalOffline,
          nomeVacaAtual: item.nomeAnimal,
          nomeTourtoUltimaInseminacao: item.nomeTouroUltimaInseminacao,
          brincoVacaAtual: item.brincoAnimal.toString(),
        ),
      AcaoRoda.exame => NovaAcaoExameGinecologicoWidget(
          uidPropriedade: w.uidPropriedade,
          nomePropriedade: w.nomePropriedade,
          uidTecnico: w.uidTecnico,
          emailPropriedade: w.emailPropriedade,
          visitaPresencial: w.visitaPresencial,
          diasDg: w.diasDg,
          uidAnimaisProdutores: item.uidAnimal,
          uidAnimalOffline: item.uidAnimalOffline,
          nomeAnimal: item.nomeAnimal,
          brincoAnimal: item.brincoAnimal.toString(),
          grupoAnimal: item.grupoAnimal,
        ),
    };
    await _abrirFolha(formulario);
  }

  void _abrirProntuario(PosicaoRoda p) {
    final e = _entidade(p);
    if (e == null) return;
    final item = animalEntityToStruct(e);
    context.pushNamed(
      ProntuarioAnimalPage.routeName,
      queryParameters: {
        'uidPropriedade':
            serializeParam(widget.uidPropriedade, ParamType.DocumentReference),
        'nomePropriedade':
            serializeParam(widget.nomePropriedade, ParamType.String),
        'uidTecnico':
            serializeParam(widget.uidTecnico, ParamType.DocumentReference),
        'emailPropriedade':
            serializeParam(widget.emailPropriedade, ParamType.String),
        'uidAnimaisProdutores':
            serializeParam(item.uidAnimal, ParamType.DocumentReference),
        'grupoPredominante': serializeParam(item.grupoAnimal, ParamType.String),
        'visitaPresencial':
            serializeParam(widget.visitaPresencial, ParamType.bool),
        'diasDg': serializeParam(widget.diasDg, ParamType.String),
      }.withoutNulls,
    );
  }

  Future<void> _tocarAnimal(PosicaoRoda p) async {
    final escolha = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FolhaAnimalRoda(posicao: p, diasDg: _diasDg),
    );
    if (!mounted) return;
    if (escolha is AcaoRoda) {
      await _agir(p, escolha);
    } else if (escolha == 'prontuario') {
      _abrirProntuario(p);
    }
  }

  void _tocarFaixa(FaseRoda f) =>
      setState(() => _faixa = _faixa == f ? null : f);

  // -------------------------------------------------------------------------
  // Tela
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final posicoes = _posicoes();
    final semana = agruparSemana(posicoes, diasDg: _diasDg);
    final contagem = contarPorEstado(posicoes);
    final aba = AbaSemana.values[_abas.index];
    final lista = _faixa == null ? semana[aba]! : naFaixa(posicoes, _faixa!);

    return Scaffold(
      backgroundColor: tema.primaryBackground,
      appBar: CabecalhoTela(titulo: 'Roda da Reprodução', online: _online),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _Painel(children: [
            _LinhaPropriedade(
                nome: widget.nomePropriedade ?? '', data: _data),
            RodaWidget(
              posicoes: posicoes,
              data: _data,
              avanco: _avanco,
              faixaDestacada: _faixa,
              aoTocarFaixa: _tocarFaixa,
              aoTocarAnimal: _tocarAnimal,
            ),
            _Contadores(
                contagem: contagem, ativa: _faixa, aoTocar: _tocarFaixa),
            const _Legenda(),
            _SeletorTempo(
                avanco: _avanco,
                aoMudar: (d) => setState(() => _avanco = d)),
            if (_avanco > 0) _AvisoSimulacao(data: _data),
          ]),
          const SizedBox(height: 14),
          _TituloSecao(
            titulo: _faixa == null
                ? 'Esta semana'
                : 'Faixa ${kNomeFase[_faixa]}',
            detalhe: _faixa == null
                ? 'até ${fmtData(_data.add(const Duration(days: kJanelaSemana))).substring(0, 5)}'
                : '${lista.length} ${lista.length == 1 ? 'animal' : 'animais'}',
          ),
          if (_faixa == null)
            AbasPilula(controller: _abas, abas: [
              for (final a in AbaSemana.values)
                AbaPilula(rotuloAba(a), contagem: semana[a]!.length),
            ])
          else
            _FiltroFaixa(
                faixa: _faixa!, aoLimpar: () => setState(() => _faixa = null)),
          if (posicoes.isEmpty)
            const _Vazio(
                'Nenhuma vaca com parto ou inseminação registrados nesta '
                'propriedade. Registre os eventos para ver a roda.')
          else if (lista.isEmpty)
            const _Vazio('Nenhum animal aqui nesta semana.')
          else
            for (final p in lista)
              CardTarefaRoda(
                key: ValueKey('card-${p.animal.id}'),
                posicao: p,
                aba: _faixa == null && aba != AbaSemana.atrasadas ? aba : null,
                diasDg: _diasDg,
                aoAgir: (acao) => _agir(p, acao),
                aoTocar: () => _tocarAnimal(p),
              ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Peças da tela
// ---------------------------------------------------------------------------

class _Painel extends StatelessWidget {
  const _Painel({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F101828), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
          LayoutLista.margemPainel, 10, LayoutLista.margemPainel, 12),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _LinhaPropriedade extends StatelessWidget {
  const _LinhaPropriedade({required this.nome, required this.data});
  final String nome;
  final DateTime data;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Row(children: [
      Expanded(
        child: Text(nome,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.readexPro(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: tema.primaryText)),
      ),
      Text(fmtData(data),
          style: GoogleFonts.readexPro(
              fontSize: 13, color: tema.secondaryText)),
    ]);
  }
}

class _Contadores extends StatelessWidget {
  const _Contadores(
      {required this.contagem, required this.ativa, required this.aoTocar});
  final Map<FaseRoda, int> contagem;
  final FaseRoda? ativa;
  final ValueChanged<FaseRoda> aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Row(children: [
      for (final f in FaseRoda.values) ...[
        if (f != FaseRoda.posParto) const SizedBox(width: 6),
        Expanded(
          child: InkWell(
            key: ValueKey('contador-${f.name}-${contagem[f]}'),
            onTap: () => aoTocar(f),
            borderRadius: BorderRadius.circular(LayoutLista.raio),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: ativa == f
                    ? kCoresFase[f]!.withValues(alpha: 0.14)
                    : tema.primaryBackground,
                borderRadius: BorderRadius.circular(LayoutLista.raio),
                border: Border.all(
                    color: ativa == f ? kCoresFase[f]! : Colors.transparent,
                    width: 1.5),
              ),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: kCoresFase[f], shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text('${contagem[f]}',
                      style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: tema.primaryText)),
                ]),
                Text(kNomeFase[f]!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.readexPro(
                        fontSize: 11, color: tema.secondaryText)),
              ]),
            ),
          ),
        ),
      ],
    ]);
  }
}

class _Legenda extends StatelessWidget {
  const _Legenda();

  @override
  Widget build(BuildContext context) {
    final estilo = GoogleFonts.readexPro(
        fontSize: 11, color: FlutterFlowTheme.of(context).secondaryText);
    Widget bola(Color c) => Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        );
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        bola(kNovilhaCoberta),
        bola(kNovilhaPrenhe),
        Text('novilha coberta / prenhe', style: estilo),
        const SizedBox(width: 6),
        Container(
          width: 14,
          height: 14,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppTokens.negativo, shape: BoxShape.circle),
          child: const Text('!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800)),
        ),
        Text('fora da fase', style: estilo),
      ],
    );
  }
}

class _SeletorTempo extends StatelessWidget {
  const _SeletorTempo({required this.avanco, required this.aoMudar});
  final int avanco;
  final ValueChanged<int> aoMudar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Container(
      height: LayoutLista.alturaChip + 6,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: tema.primaryBackground,
        borderRadius: BorderRadius.circular(LayoutLista.raio),
      ),
      child: Row(children: [
        for (final (dias, rotulo) in const [
          (0, 'Hoje'),
          (7, '+7 dias'),
          (30, '+30 dias'),
        ])
          Expanded(
            child: GestureDetector(
              onTap: () => aoMudar(dias),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: avanco == dias
                      ? tema.secondaryBackground
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: avanco == dias
                      ? const [
                          BoxShadow(color: Color(0x14000000), blurRadius: 4)
                        ]
                      : null,
                ),
                child: Text(rotulo,
                    style: GoogleFonts.readexPro(
                        fontSize: 13,
                        fontWeight: avanco == dias
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: avanco == dias
                            ? tema.primaryText
                            : tema.secondaryText)),
              ),
            ),
          ),
      ]),
    );
  }
}

class _AvisoSimulacao extends StatelessWidget {
  const _AvisoSimulacao({required this.data});
  final DateTime data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppTokens.brandTint,
        borderRadius: BorderRadius.circular(LayoutLista.raio),
      ),
      child: Text(
        'Simulação: onde cada animal estará em ${fmtData(data)} se nada for '
        'registrado até lá.',
        style: GoogleFonts.readexPro(
            fontSize: 12.5,
            color: AppTokens.brand,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  const _TituloSecao({required this.titulo, required this.detalhe});
  final String titulo;
  final String detalhe;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(titulo,
                style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: tema.primaryText)),
          ),
          Text(detalhe,
              style: GoogleFonts.readexPro(
                  fontSize: 12, color: tema.secondaryText)),
        ],
      ),
    );
  }
}

class _FiltroFaixa extends StatelessWidget {
  const _FiltroFaixa({required this.faixa, required this.aoLimpar});
  final FaseRoda faixa;
  final VoidCallback aoLimpar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
        decoration: BoxDecoration(
          color: tema.secondaryBackground,
          borderRadius: BorderRadius.circular(LayoutLista.raio),
          border: Border(
              left: BorderSide(color: kCoresFase[faixa]!, width: 4)),
        ),
        child: Row(children: [
          Expanded(
            child: Text(
              'Animais posicionados nesta faixa; fora da fase primeiro.',
              style: GoogleFonts.readexPro(
                  fontSize: 12, color: tema.secondaryText),
            ),
          ),
          TextButton(onPressed: aoLimpar, child: const Text('Limpar')),
        ]),
      ),
    );
  }
}

class _Vazio extends StatelessWidget {
  const _Vazio(this.texto);
  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: tema.secondaryBackground,
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Text(texto,
          textAlign: TextAlign.center,
          style:
              GoogleFonts.readexPro(fontSize: 13, color: tema.secondaryText)),
    );
  }
}
