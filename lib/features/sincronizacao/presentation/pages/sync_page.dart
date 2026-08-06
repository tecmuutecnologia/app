import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/ui/flutter_flow_util.dart';
import '/data/schema/propriedades_record.dart';
import '/features/dashboard/presentation/pages/dashboard_tecnico_page.dart';
import '/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart';
import '/features/produtor/presentation/pages/inicio_propriedade_produtor_page.dart';
import '../../domain/sync_state.dart';
import '../controllers/sync_page_controller.dart';
import '../widgets/sync_progress_view.dart';

/// Tela de sincronizacao pos-login, para tecnico e produtor.
///
/// Substitui a antiga `SyncTechnicianPage`, que so aparecia DEPOIS que o
/// download completo ja tinha rodado dentro do botao de login.
class SyncPage extends ConsumerStatefulWidget {
  const SyncPage({super.key, required this.papel});

  final SyncPapel papel;

  static String routeName = 'sync';
  static String routePath = '/sincronizando';

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncPageControllerProvider.notifier).iniciar(widget.papel);
    });
  }

  void _navegar(SyncDestino destino) {
    switch (destino) {
      case DestinoDashboardTecnico():
        context.goNamed(DashboardTecnicoPage.routeName);
      case DestinoCompletarPerfil():
        context.goNamed(CompletarPerfilTecnicoPage.routeName);
      case DestinoInicioPropriedadeProdutor(:final propriedade):
        final p = propriedade as PropriedadesRecord?;
        context.goNamed(
          InicioPropriedadeProdutorPage.routeName,
          queryParameters: {
            'nomePropriedade':
                serializeParam(p?.displayName, ParamType.String),
            'uidPropriedade':
                serializeParam(p?.reference, ParamType.DocumentReference),
            'uidTecnico':
                serializeParam(p?.parentReference, ParamType.DocumentReference),
            'emailPropriedade': serializeParam(p?.email, ParamType.String),
            'visitaPresencial': serializeParam(false, ParamType.bool),
            'diasDg': serializeParam(p?.diasParaDg, ParamType.String),
          }.withoutNulls,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(syncPageControllerProvider);

    ref.listen(syncPageControllerProvider, (_, novo) {
      if (novo is SyncConcluido) _navegar(novo.destino);
    });

    // Sair no meio deixaria o usuario autenticado numa tela de login, com o
    // download orfao e o estado pela metade.
    return PopScope(
      canPop: estado is SyncErro,
      child: Scaffold(
        body: SyncProgressView(
          estado: estado,
          onTentarNovamente: () =>
              ref.read(syncPageControllerProvider.notifier).tentarNovamente(),
          onContinuarAssimMesmo: () => ref
              .read(syncPageControllerProvider.notifier)
              .continuarAssimMesmo(),
        ),
      ),
    );
  }
}
