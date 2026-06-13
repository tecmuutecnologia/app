import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/pages/produtor/initial/inicio_propriedade_produtor/inicio_propriedade_produtor_widget.dart';
import '/pages/tecnico/dashboard/dashboard_tecnico/dashboard_tecnico_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class VerificaTipoLoginPage extends StatefulWidget {
  const VerificaTipoLoginPage({super.key});

  static String routeName = 'verificaTipoLogin';
  static String routePath = '/verificaTipoLogin';

  @override
  State<VerificaTipoLoginPage> createState() => _VerificaTipoLoginPageState();
}

class _VerificaTipoLoginPageState extends State<VerificaTipoLoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final personVerify = await queryPersonRecordOnce(
        queryBuilder: (personRecord) => personRecord.where(
          'uid',
          isEqualTo: currentUserUid,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      final outUidTecnico = await queryTecnicoRecordOnce(
        queryBuilder: (tecnicoRecord) => tecnicoRecord.where(
          'uidPerson',
          isEqualTo: personVerify?.reference.id,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if (outUidTecnico?.reference != null) {
        context.goNamed(DashboardTecnicoWidget.routeName);

        return;
      } else {
        final outUidPropriedade = await queryPropriedadesRecordOnce(
          queryBuilder: (propriedadesRecord) => propriedadesRecord.where(
            'uidPersonProdutor',
            isEqualTo: personVerify?.reference,
          ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);

        context.goNamed(
          InicioPropriedadeProdutorWidget.routeName,
          queryParameters: {
            'nomePropriedade': serializeParam(
              outUidPropriedade?.displayName,
              ParamType.String,
            ),
            'uidPropriedade': serializeParam(
              outUidPropriedade?.reference,
              ParamType.DocumentReference,
            ),
            'uidTecnico': serializeParam(
              outUidPropriedade?.parentReference,
              ParamType.DocumentReference,
            ),
            'emailPropriedade': serializeParam(
              outUidPropriedade?.email,
              ParamType.String,
            ),
            'visitaPresencial': serializeParam(
              false,
              ParamType.bool,
            ),
            'diasDg': serializeParam(
              outUidPropriedade?.diasParaDg,
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
