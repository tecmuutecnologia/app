import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/features/dashboard/presentation/pages/dashboard_tecnico_page.dart';
import '/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SyncTechnicianPage extends StatefulWidget {
  const SyncTechnicianPage({super.key});

  static String routeName = 'syncTechnician';
  static String routePath = '/syncTechnician';

  @override
  State<SyncTechnicianPage> createState() => _SyncTechnicianPageState();
}

class _SyncTechnicianPageState extends State<SyncTechnicianPage> {
  PersonRecord? _personverify;
  TecnicoRecord? _uidTecnico;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _personverify = await queryPersonRecordOnce(
        queryBuilder: (personRecord) => personRecord.where(
          'uid',
          isEqualTo: currentUserUid,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      // Migração legado→ObjectBox: resgata (das prefs) os animais criados
      // offline pelo mecanismo antigo e limpa a chave. Autônoma do FFAppState.
      await migrarAnimaisOfflineLegadoDePrefs();
      safeSetState(() {});
      if (_personverify != null) {
        _uidTecnico = await queryTecnicoRecordOnce(
          queryBuilder: (tecnicoRecord) => tecnicoRecord.where(
            'uidPerson',
            isEqualTo: _personverify?.reference.id,
          ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);

        // Sincronização em tempo real Firestore->ObjectBox: reflete mudanças
        // remotas (ex.: outro dispositivo) automaticamente. Conflitos resolvidos
        // por ConflictResolver (edição local pendente vence). Só nativo.
        if (ObjectBoxService.isInitialized && _uidTecnico != null) {
          await RemoteSyncListenersService.initialize();
          RemoteSyncListenersService.instance
              .startAllListeners(_uidTecnico!.reference.path);
        }

        await queryPropriedadesRecordOnce(
          parent: _uidTecnico?.reference,
        );
        await queryAcoesRecordOnce(
          parent: _uidTecnico?.reference,
        );
        await queryAcoesSanitarioRecordOnce(
          parent: _uidTecnico?.reference,
        );
        await queryResumoDaVisitaRecordOnce(
          queryBuilder: (resumoDaVisitaRecord) => resumoDaVisitaRecord.where(
            'uidTecnico',
            isEqualTo: _uidTecnico?.reference,
          ),
        );
        await queryTipoAcoesRecordOnce();

        if (!mounted) return;
        context.pushNamed(DashboardTecnicoPage.routeName);

        return;
      } else {
        if (!mounted) return;
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

        if (!mounted) return;
        context.goNamed(CompletarPerfilTecnicoPage.routeName);

        return;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
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
