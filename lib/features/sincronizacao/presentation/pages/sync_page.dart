import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/app/router/destino_inicial.dart';
import '/app/router/nav.dart';
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
  const SyncPage({super.key, this.papel});

  /// Nulo quando a rota nao informa (abertura do app pela `/`): ai o gateway
  /// descobre de quem e a sessao.
  final SyncPapel? papel;

  static String routeName = 'sync';
  static String routePath = '/sincronizando';

  /// Unica forma de abrir a tela. Usa `go` (substitui a pilha), nunca `push`.
  ///
  /// Empilhar deixa a rota `/` embaixo, e o `pageBuilder` de TODA rota da
  /// pilha e reexecutado a cada rebuild do roteador. Era assim que a
  /// sincronizacao "piscava" e o usuario caia no dashboard com o download pela
  /// metade: ja autenticado, a pagina da `/` se materializava por baixo desta
  /// tela e navegava sozinha. Aquela pagina nao existe mais, mas a pilha
  /// pos-login continua tendo de ser so esta tela — voltar ao login depois de
  /// autenticar nao e um estado valido.
  static void abrir(BuildContext context, {required SyncPapel papel}) {
    context.goNamed(
      routeName,
      queryParameters: {
        'papel': papel == SyncPapel.produtor ? 'produtor' : 'tecnico',
      },
    );
  }

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage> {
  @override
  void initState() {
    super.initState();

    // Mata qualquer redirecionamento pendente antes de comecar.
    //
    // O router escuta o `AppStateNotifier` (`refreshListenable`) e reavalia as
    // rotas a cada evento de autenticacao. Se sobrar um `_redirectLocation` de
    // antes do login, o `redirect` global de `nav.dart` dispara assim que o
    // Firebase propaga o usuario e TROCA esta tela pelo destino guardado —
    // a sincronizacao continuava rodando em background, sem tela, e o usuario
    // caia no app achando que tinha terminado.
    AppStateNotifier.instance.clearRedirectLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncPageControllerProvider.notifier).iniciar(widget.papel);
    });
  }

  void _navegar(SyncDestino destino) {
    final localizacao = _localizacaoDe(destino);
    // Este e o destino que a rota `/` usa na proxima abertura do app, no lugar
    // das duas consultas ao Firestore que a `VerificaTipoLoginPage` fazia. So
    // aqui o app sabe, com dado do servidor, quem e o usuario.
    unawaited(DestinoInicial.guardar(localizacao));
    context.go(localizacao);
  }

  String _localizacaoDe(SyncDestino destino) {
    final router = GoRouter.of(context);
    switch (destino) {
      case DestinoDashboardTecnico():
        return router.namedLocation(DashboardTecnicoPage.routeName);
      case DestinoCompletarPerfil():
        return router.namedLocation(CompletarPerfilTecnicoPage.routeName);
      case DestinoInicioPropriedadeProdutor(:final propriedade):
        final p = propriedade as PropriedadesRecord?;
        return router.namedLocation(
          InicioPropriedadeProdutorPage.routeName,
          queryParameters: {
            'nomePropriedade': serializeParam(p?.displayName, ParamType.String),
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

    // Sair no meio deixaria o usuario autenticado numa tela de login, com o
    // download orfao e o estado pela metade. Concluido tambem nao pode sair
    // pelo botao voltar: a saida e o "Continuar".
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
          // Unica saida da tela: navegar so quando o usuario decide.
          onContinuar: () {
            final atual = ref.read(syncPageControllerProvider);
            if (atual is SyncConcluido) _navegar(atual.destino);
          },
        ),
      ),
    );
  }
}
