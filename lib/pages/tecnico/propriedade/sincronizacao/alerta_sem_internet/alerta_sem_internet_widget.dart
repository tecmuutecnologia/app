import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'alerta_sem_internet_model.dart';
export 'alerta_sem_internet_model.dart';

class AlertaSemInternetWidget extends StatefulWidget {
  const AlertaSemInternetWidget({super.key});

  @override
  State<AlertaSemInternetWidget> createState() =>
      _AlertaSemInternetWidgetState();
}

class _AlertaSemInternetWidgetState extends State<AlertaSemInternetWidget> {
  late AlertaSemInternetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlertaSemInternetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.8,
        height: 250.0,
        decoration: BoxDecoration(
          color: Color(0xFEFFFFFF),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: Lottie.asset(
                'assets/jsons/Animation_-_1722572191889.json',
                width: 150.0,
                height: 150.0,
                fit: BoxFit.contain,
                animate: true,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
              child: Text(
                'Você está sem internet, depois sincronize os dados.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: Color(0xFF2C2C2C),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
            FFButtonWidget(
              onPressed: () async {
                FFAppState().contador = -1;
                FFAppState().animaisProdutoresExistentes = [];
                safeSetState(() {});
                _model.outUidTecnico = await queryTecnicoRecordOnce(
                  queryBuilder: (tecnicoRecord) => tecnicoRecord.where(
                    'uidPerson',
                    isEqualTo: currentUserUid,
                  ),
                  singleRecord: true,
                ).then((s) => s.firstOrNull);
                _model.outListAnimaisTecnico =
                    await queryAnimaisProdutoresRecordOnce(
                  parent: _model.outUidTecnico?.reference,
                  queryBuilder: (animaisProdutoresRecord) =>
                      animaisProdutoresRecord
                          .orderBy('nomeAnimal')
                          .orderBy('brincoAnimalOrder'),
                );
                _model.instantTimer = InstantTimer.periodic(
                  duration: Duration(milliseconds: 500),
                  callback: (timer) async {
                    while (FFAppState().contador <=
                        _model.outListAnimaisTecnico!.length) {
                      FFAppState().contador = FFAppState().contador + 1;
                      safeSetState(() {});
                      FFAppState().addToAnimaisProdutoresExistentes(
                          AnimaisProdutoresStruct(
                        uidTecnicoPropriedade: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.uidTecnicoPropriedade,
                        nomeAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.nomeAnimal,
                        racaAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.racaAnimal,
                        pesoAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.pesoAnimal,
                        dtNascimento: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtNascimento,
                        touro: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.touro,
                        vaca: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.vaca,
                        status: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.status,
                        grupoAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.grupoAnimal,
                        dtUltimaInseminacao: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtUltimaInseminacao,
                        dtUltimoParto: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtUltimoParto,
                        liberaInseminacao: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.liberaInseminacao,
                        dtPartoPrevisto: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtPartoPrevisto,
                        dtSecPrevista: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtSecPrevista,
                        dtPrePartoPrevista: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtPrePartoPrevista,
                        dtPP: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtPP,
                        dtDgMais: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtDgMais,
                        dtDgMenos: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtDgMenos,
                        dtAborto: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtAborto,
                        dtSecagem: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtSecagem,
                        dtUltimoPP: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtUltimoPP,
                        nomeTouroUltimaInseminacao: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.nomeTouroUltimaInseminacao,
                        totalInseminacoes: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.totalInseminacoes,
                        totalPartos: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.totalPartos,
                        dtPreParto: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtPreParto,
                        motivoDescarteAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.motivoDescarteAnimal,
                        dtDescarteAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtDescarteAnimal,
                        dtUltimaAcao: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtUltimaAcao,
                        compararDtUltimaInseminacao: _model
                            .outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.compararDtUltimaInseminacao,
                        nomeBrincoConcat: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.nomeBrincoConcat,
                        idGrupoAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.idGrupoAnimal,
                        dtUltimoPartoContingencia: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtUltimoPartoContingencia,
                        idStatusAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.idStatusAnimal,
                        dtInducaoLactacao: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtInducaoLactacao,
                        dtDesmame: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.dtDesmame,
                        brincoAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.brincoAnimal,
                        brincoAnimalOrder: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.brincoAnimalOrder,
                        uidAnimal: _model.outListAnimaisTecnico
                            ?.elementAtOrNull(FFAppState().contador)
                            ?.reference,
                        itemUidIndexAtual: FFAppState().contador,
                      ));
                      safeSetState(() {});
                    }
                    _model.instantTimer?.cancel();
                    FFAppState().verificaInternet = 0;
                    safeSetState(() {});
                    Navigator.pop(context);
                  },
                  startImmediately: true,
                );

                safeSetState(() {});
              },
              text: 'OK',
              icon: Icon(
                Icons.signal_wifi_connected_no_internet_4,
                size: 15.0,
              ),
              options: FFButtonOptions(
                height: 40.0,
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                elevation: 3.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
