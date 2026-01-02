import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'sync_technician_model.dart';
export 'sync_technician_model.dart';

class SyncTechnicianWidget extends StatefulWidget {
  const SyncTechnicianWidget({super.key});

  static String routeName = 'syncTechnician';
  static String routePath = '/syncTechnician';

  @override
  State<SyncTechnicianWidget> createState() => _SyncTechnicianWidgetState();
}

class _SyncTechnicianWidgetState extends State<SyncTechnicianWidget> {
  late SyncTechnicianModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SyncTechnicianModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.personverify = await queryPersonRecordOnce(
        queryBuilder: (personRecord) => personRecord.where(
          'uid',
          isEqualTo: currentUserUid,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      FFAppState().animaisProdutoresOffline = [];
      FFAppState().animaisProdutoresExistentes = [];
      FFAppState().animaisProdutoresEditados = [];
      FFAppState().animaisApagadosExistentesOffline = [];
      FFAppState().acoesExistentes = [];
      FFAppState().acoesOffline = [];
      FFAppState().acoesSanitarioExistentes = [];
      FFAppState().acoesSanitarioOffline = [];
      safeSetState(() {});
      if (_model.personverify != null) {
        _model.uidTecnico = await queryTecnicoRecordOnce(
          queryBuilder: (tecnicoRecord) => tecnicoRecord.where(
            'uidPerson',
            isEqualTo: _model.personverify?.reference.id,
          ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);
        await queryPropriedadesRecordOnce(
          parent: _model.uidTecnico?.reference,
        );
        await queryAcoesRecordOnce(
          parent: _model.uidTecnico?.reference,
        );
        await queryAcoesSanitarioRecordOnce(
          parent: _model.uidTecnico?.reference,
        );
        await queryResumoDaVisitaRecordOnce(
          queryBuilder: (resumoDaVisitaRecord) => resumoDaVisitaRecord.where(
            'uidTecnico',
            isEqualTo: _model.uidTecnico?.reference,
          ),
        );
        await queryTipoAcoesRecordOnce();

        context.pushNamed(DashboardTecnicoWidget.routeName);

        return;
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Complete seu perfil!'),
              content: Text('Para continuar deve completar seu perfil.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );

        context.goNamed(CompletarPerfilTecnicoWidget.routeName);

        return;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: 100.0,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(0.87, -1.0),
                      end: AlignmentDirectional(-0.87, 1.0),
                    ),
                  ),
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Lottie.asset(
                                  'assets/jsons/animation_lmv2wwnc.json',
                                  width: 190.0,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.4,
                                  fit: BoxFit.none,
                                  animate: true,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Sincronizando, aguarde...',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 25.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
