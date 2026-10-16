import '/domain/animais/ordenacao_animal.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/domain/animais/classificacao_animal.dart';
import '/domain/animais/diagnostico_gestacao.dart';
import '/app/theme/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListaDiagnosticoGestacaoWidget extends StatefulWidget {
  const ListaDiagnosticoGestacaoWidget({
    super.key,
    required this.uidResumoVisita,
    required this.uidTecnico,
    required this.uidPropriedade,
    required this.dtVisita,
  });

  final DocumentReference uidResumoVisita;
  final DocumentReference uidTecnico;
  final DocumentReference uidPropriedade;
  final DateTime dtVisita;

  @override
  State<ListaDiagnosticoGestacaoWidget> createState() =>
      _ListaDiagnosticoGestacaoWidgetState();
}

class _ListaDiagnosticoGestacaoWidgetState
    extends State<ListaDiagnosticoGestacaoWidget> {
  /// Criado uma vez (e refeito só se a data mudar). Criar o stream dentro do
  /// `build` reabria a consulta a cada rebuild da página.
  late Stream<List<_AnimalComInseminacao>> _animais;

  @override
  void initState() {
    super.initState();
    _animais = _observarAnimais();
  }

  @override
  void didUpdateWidget(covariant ListaDiagnosticoGestacaoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dtVisita != widget.dtVisita ||
        oldWidget.uidPropriedade.path != widget.uidPropriedade.path) {
      _animais = _observarAnimais();
    }
  }

  // Função para obter o início do dia (00:00:00)
  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0);
  }

  // Função para obter o fim do dia (23:59:59)
  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Diagnósticos do dia da visita, do ObjectBox (offline-first). Antes era um
  /// stream do Firestore mais um `get()` de rede por animal, em sequência — e
  /// refeito a cada rebuild, porque o Future nascia dentro do `build`.
  Stream<List<_AnimalComInseminacao>> _observarAnimais() => AcaoRepository()
      .watchComAnimalNoPeriodo(
        _startOfDay(widget.dtVisita),
        _endOfDay(widget.dtVisita),
        tipos: tiposConsultaDiagnostico,
      )
      .map(_animaisDaPropriedade);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
      child: StreamBuilder<List<_AnimalComInseminacao>>(
        stream: _animais,
        builder: (context, animaisSnapshot) {
          if (!animaisSnapshot.hasData) {
            return SizedBox.shrink();
          }

          final todosAnimais = animaisSnapshot.data!;

          // Se não há animais da propriedade, não mostrar nada
          if (todosAnimais.isEmpty) {
            return SizedBox.shrink();
          }

          // Separar em duas listas: PP/DG+ e DG-
          final animaisPPDGMais = todosAnimais
              .where((a) => a.acao == 'PP' || a.acao == 'DG+')
              .toList();
          final animaisDGMenos =
              todosAnimais.where((a) => a.acao == 'DG-').toList();
          final animaisAbortos = todosAnimais
              .where((a) => a.acao == 'Aborto' && ehVaca(a.grupoAnimal))
              .toList();

          // Ordenar por brinco numérico e depois por nome
          animaisPPDGMais.sort(_compararAnimais);
          animaisDGMenos.sort(_compararAnimais);
          animaisAbortos.sort(_compararAnimais);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da seção
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 5.0),
                    child: Text(
                      'Diagnóstico de Gestação',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
              // Lista PP/DG+ (Prenhes)
              if (animaisPPDGMais.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 0.0),
                  child: Text(
                    'Prenhes (PP/DG+)',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF048508),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                  child: _buildAnimalListFromData(animaisPPDGMais),
                ),
              ],
              // Lista DG- (Vazias)
              if (animaisDGMenos.isNotEmpty) ...[
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 0.0),
                  child: Text(
                    'Vazias (DG-)',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: Color(0xFFEE0000),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                  child: _buildAnimalListFromData(animaisDGMenos),
                ),
              ],
              // Lista de Abortos
              if (animaisAbortos.isNotEmpty) ...[
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 0.0),
                  child: Text(
                    'Abortos',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: Color(0xFFEE0000),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                  child: _buildAnimalListFromData(animaisAbortos),
                ),
              ],
              SizedBox(height: 10.0),
            ],
          );
        },
      ),
    );
  }

  int _compararAnimais(_AnimalComInseminacao a, _AnimalComInseminacao b) =>
      compararAnimais(
        brincoA: a.brincoAnimal,
        nomeA: a.nomeAnimal,
        brincoB: b.brincoAnimal,
        nomeB: b.nomeAnimal,
      );

  Widget _buildAnimalListFromData(List<_AnimalComInseminacao> animais) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: animais.length,
      itemBuilder: (context, index) {
        final animal = animais[index];
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 4.0, 10.0, 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                child: Icon(
                  Icons.circle_sharp,
                  color: ehVaca(animal.grupoAnimal)
                      ? Color(0xFF048508)
                      : ehNovilha(animal.grupoAnimal)
                          ? Color(0xFFFF0076)
                          : FlutterFlowTheme.of(context).tertiary,
                  size: 10.0,
                ),
              ),
              Expanded(
                child: Text(
                  animal.displayName,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                child: Text(
                  animal.acao,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: animal.acao == 'DG-' || animal.acao == 'Aborto'
                            ? Color(0xFFEE0000)
                            : Color(0xFF048508),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (animal.dataExibida.isNotEmpty)
                Text(
                  animal.dataExibida,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<_AnimalComInseminacao> _animaisDaPropriedade(List<AcaoEntity> acoes) {
    final animais = AnimalRepository();
    final resultado = <_AnimalComInseminacao>[];
    final inseminacoes = AcaoRepository().datasInseminacaoPorAnimal(acoes
        .where((a) => a.acao == 'DG-')
        .map((a) => a.uidAnimalAnimaisProdutoresPath!));

    for (final acao in acoes) {
      final tipo = tipoDiagnostico(acao: acao.acao, dtDgMais: acao.dtDgMais);
      if (tipo == null) continue;
      final animalPath = acao.uidAnimalAnimaisProdutoresPath!;
      final animal = animais.getByFirestoreId(animalPath.split('/').last);
      // Só animais desta propriedade (campo uidTecnicoPropriedade).
      if (animal == null ||
          animal.uidTecnicoPropriedadePath != widget.uidPropriedade.path) {
        continue;
      }

      final nomeAnimal = animal.nomeAnimal ?? '';
      final brincoAnimal = animal.brincoAnimal;

      // Mesmo predicado da ordenacao: 0 e -1 nao sao brinco.
      final String displayName;
      if (temBrinco(brincoAnimal)) {
        displayName = nomeAnimal.isNotEmpty
            ? '$brincoAnimal - $nomeAnimal'
            : brincoAnimal.toString();
      } else {
        displayName = nomeAnimal;
      }

      resultado.add(_AnimalComInseminacao(
        nomeAnimal: nomeAnimal,
        brincoAnimal: brincoAnimal,
        grupoAnimal: animal.grupoAnimal ?? '',
        // O DG- zera dtUltimaInseminacao do animal: para as vazias, a IA
        // diagnosticada vem do histórico de ações 'Inseminada'.
        dtUltimaInseminacao: tipo == 'DG-'
            ? inseminacaoDiagnosticada(inseminacoes[animalPath] ?? const [],
                ate: acao.dataDaAcao ?? widget.dtVisita)
            : animal.dtUltimaInseminacao ?? '',
        displayName: displayName,
        acao: tipo,
      ));
    }

    return resultado;
  }
}

class _AnimalComInseminacao {
  final String nomeAnimal;
  final int? brincoAnimal;
  final String grupoAnimal;
  final String dtUltimaInseminacao;
  final String displayName;
  final String acao;

  _AnimalComInseminacao({
    required this.nomeAnimal,
    required this.brincoAnimal,
    required this.grupoAnimal,
    required this.dtUltimaInseminacao,
    required this.displayName,
    required this.acao,
  });

  String get dataExibida =>
      dtUltimaInseminacao.isEmpty ? '' : 'IA: $dtUltimaInseminacao';
}
