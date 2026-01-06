import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'lista_diagnostico_gestacao_model.dart';
export 'lista_diagnostico_gestacao_model.dart';

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
  late ListaDiagnosticoGestacaoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaDiagnosticoGestacaoModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // Função para formatar a data da visita para comparação
  String _formatDateForComparison(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Função para obter o início do dia (00:00:00)
  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0);
  }

  // Função para obter o fim do dia (23:59:59)
  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    // Formatar a data da visita para comparação (igual ao campo dataVisita nas ações)
    final dtVisitaFormatada = _formatDateForComparison(widget.dtVisita);

    // Obter início e fim do dia da visita para filtrar por dataDaAcao
    final dtInicioDia = _startOfDay(widget.dtVisita);
    final dtFimDia = _endOfDay(widget.dtVisita);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
      child: StreamBuilder<List<AcoesRecord>>(
        stream: queryAcoesRecord(
          parent: widget.uidTecnico,
          queryBuilder: (acoesRecord) => acoesRecord
              .where('dataDaAcao', isGreaterThanOrEqualTo: dtInicioDia)
              .where('dataDaAcao', isLessThanOrEqualTo: dtFimDia),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
            );
          }

          List<AcoesRecord> acoesRecordList = snapshot.data!;

          // Filtrar apenas PP, DG+ e DG- que possuem animais vinculados
          final acoesFiltradas = acoesRecordList
              .where((acao) =>
                  (acao.acao == 'PP' ||
                      acao.acao == 'DG+' ||
                      acao.acao == 'DG-') &&
                  acao.uidAnimalAnimaisProdutores != null)
              .toList();

          if (acoesFiltradas.isEmpty) {
            return SizedBox.shrink();
          }

          // Usar FutureBuilder para carregar todos os animais e filtrar por propriedade
          return FutureBuilder<List<_AnimalComInseminacao>>(
            future: _carregarAnimaisComInseminacao(acoesFiltradas),
            builder: (context, animaisSnapshot) {
              if (!animaisSnapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFF75E38),
                      ),
                    ),
                  ),
                );
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

              // Ordenar por brinco numérico e depois por nome
              animaisPPDGMais.sort(_compararAnimais);
              animaisDGMenos.sort(_compararAnimais);

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
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 10.0, 15.0, 5.0),
                        child: Text(
                          'Diagnóstico de Gestação',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 0.0),
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
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
                              color: Color(0xFFFF0076),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                      child: _buildAnimalListFromData(animaisDGMenos),
                    ),
                  ],
                  SizedBox(height: 10.0),
                ],
              );
            },
          );
        },
      ),
    );
  }

  int _compararAnimais(_AnimalComInseminacao a, _AnimalComInseminacao b) {
    // Primeiro tenta ordenar por brinco
    if (a.brincoAnimal != null &&
        a.brincoAnimal != -1 &&
        a.brincoAnimal != 0 &&
        b.brincoAnimal != null &&
        b.brincoAnimal != -1 &&
        b.brincoAnimal != 0) {
      return a.brincoAnimal!.compareTo(b.brincoAnimal!);
    }
    // Se apenas um tem brinco, ele vem primeiro
    if (a.brincoAnimal != null && a.brincoAnimal != -1 && a.brincoAnimal != 0)
      return -1;
    if (b.brincoAnimal != null && b.brincoAnimal != -1 && b.brincoAnimal != 0)
      return 1;
    // Se nenhum tem brinco, ordena por nome
    return a.nomeAnimal.toLowerCase().compareTo(b.nomeAnimal.toLowerCase());
  }

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
                  color: animal.grupoAnimal == 'Vacas'
                      ? Color(0xFF048508)
                      : animal.grupoAnimal == 'Novilhas'
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
                        color: animal.acao == 'DG-'
                            ? Color(0xFFFF0076)
                            : Color(0xFF048508),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (animal.dtUltimaInseminacao.isNotEmpty)
                Text(
                  'IA: ${animal.dtUltimaInseminacao}',
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

  Future<List<_AnimalComInseminacao>> _carregarAnimaisComInseminacao(
      List<AcoesRecord> acoes) async {
    final List<_AnimalComInseminacao> resultado = [];

    for (final acao in acoes) {
      if (acao.uidAnimalAnimaisProdutores != null) {
        try {
          final animalSnapshot = await acao.uidAnimalAnimaisProdutores!.get();
          if (animalSnapshot.exists) {
            final animalData = animalSnapshot.data() as Map<String, dynamic>?;
            if (animalData != null) {
              // Verificar se o animal pertence à propriedade atual
              // O campo no AnimaisProdutores é 'uidTecnicoPropriedade'
              final uidTecnicoPropriedade =
                  animalData['uidTecnicoPropriedade'] as DocumentReference?;
              if (uidTecnicoPropriedade == null ||
                  uidTecnicoPropriedade.path != widget.uidPropriedade.path) {
                // Animal não pertence a esta propriedade, pular
                continue;
              }

              final nomeAnimal = animalData['nomeAnimal'] as String? ?? '';
              final brincoAnimal = animalData['brincoAnimal'] as int?;
              final grupoAnimal = animalData['grupoAnimal'] as String? ?? '';

              // Usar a data de última inseminação do próprio animal
              final dtUltimaInseminacaoAnimal =
                  animalData['dtUltimaInseminacao'] as String? ?? '';

              String displayName;
              if (nomeAnimal.isNotEmpty &&
                  brincoAnimal != null &&
                  brincoAnimal != -1 &&
                  brincoAnimal != 0) {
                displayName = '$brincoAnimal - $nomeAnimal';
              } else if (brincoAnimal != null &&
                  brincoAnimal != -1 &&
                  brincoAnimal != 0) {
                displayName = brincoAnimal.toString();
              } else {
                displayName = nomeAnimal;
              }

              resultado.add(_AnimalComInseminacao(
                nomeAnimal: nomeAnimal,
                brincoAnimal: brincoAnimal,
                grupoAnimal: grupoAnimal,
                dtUltimaInseminacao: dtUltimaInseminacaoAnimal,
                displayName: displayName,
                acao: acao.acao,
              ));
            }
          }
        } catch (e) {
          print('Erro ao carregar animal: $e');
        }
      }
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
}
