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
import 'verifica_tipo_login_model.dart';
export 'verifica_tipo_login_model.dart';

class VerificaTipoLoginWidget extends StatefulWidget {
  const VerificaTipoLoginWidget({super.key});

  static String routeName = 'verificaTipoLogin';
  static String routePath = '/verificaTipoLogin';

  @override
  State<VerificaTipoLoginWidget> createState() =>
      _VerificaTipoLoginWidgetState();
}

class _VerificaTipoLoginWidgetState extends State<VerificaTipoLoginWidget> {
  late VerificaTipoLoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerificaTipoLoginModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.personVerify = await queryPersonRecordOnce(
        queryBuilder: (personRecord) => personRecord.where(
          'uid',
          isEqualTo: currentUserUid,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      _model.outUidTecnico = await queryTecnicoRecordOnce(
        queryBuilder: (tecnicoRecord) => tecnicoRecord.where(
          'uidPerson',
          isEqualTo: _model.personVerify?.reference.id,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if (_model.outUidTecnico?.reference != null) {
        context.goNamed(DashboardTecnicoWidget.routeName);

        return;
      } else {
        _model.outUidPropriedade = await queryPropriedadesRecordOnce(
          queryBuilder: (propriedadesRecord) => propriedadesRecord.where(
            'uidPersonProdutor',
            isEqualTo: _model.personVerify?.reference,
          ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);

        context.goNamed(
          InicioPropriedadeProdutorWidget.routeName,
          queryParameters: {
            'nomePropriedade': serializeParam(
              _model.outUidPropriedade?.displayName,
              ParamType.String,
            ),
            'uidPropriedade': serializeParam(
              _model.outUidPropriedade?.reference,
              ParamType.DocumentReference,
            ),
            'uidTecnico': serializeParam(
              _model.outUidPropriedade?.parentReference,
              ParamType.DocumentReference,
            ),
            'emailPropriedade': serializeParam(
              _model.outUidPropriedade?.email,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              false,
              ParamType.bool,
            ),
            'diasDg': serializeParam(
              _model.outUidPropriedade?.diasParaDg,
              ParamType.String,
            ),
          }.withoutNulls,
        );

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
