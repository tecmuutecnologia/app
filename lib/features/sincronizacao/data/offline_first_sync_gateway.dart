import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/core/auth/firebase_auth/auth_util.dart';
import '/core/sync/chaves_uid_person.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '../domain/decisao_pos_login.dart';
import '../domain/sync_gateway.dart';
import '../domain/sync_state.dart';

/// Implementacao real da porta: delega para o `OfflineFirstSyncService` e
/// reproduz a sequencia de pos-login que vivia no `initState` da tela de
/// sincronizacao antiga, removida nesta mudanca.
class OfflineFirstSyncGateway implements SyncGateway {
  @override
  bool get temDadosLocais =>
      ObjectBoxService.isInitialized &&
      ObjectBoxService.instance.animalBox.count() > 0;

  @override
  Stream<SyncProgress> get progressStream => OfflineFirstSyncService
          .isInitialized
      ? OfflineFirstSyncService.instance.progressStream
      // Na web o ObjectBox nao sobe e o servico nunca e inicializado; sem
      // esta guarda o getter `instance` lancaria StateError e a tela ficaria
      // presa em "Preparando seus dados".
      : const Stream<SyncProgress>.empty();

  @override
  SyncProgress? get ultimoProgresso => OfflineFirstSyncService.isInitialized
      ? OfflineFirstSyncService.instance.lastProgress
      : null;

  @override
  Future<void> baixarTudo(ResolucaoPapel resolucao) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await ObjectBoxAuthHelper.onUserLogin(
      user,
      ehProdutor: resolucao.papel == PapelResolvido.produtor,
    );
  }

  @override
  Future<ResolucaoPapel> resolverPapel(SyncPapel? papel) async {
    final person = await queryPersonRecordOnce(
      queryBuilder: (r) => r.where('uid', isEqualTo: currentUserUid),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    // Sem person nao ha o que contradizer: conta nova segue para o cadastro.
    if (person == null) {
      return const ResolucaoPapel(
        papel: PapelResolvido.cadastroTecnico,
        conflita: false,
      );
    }

    // Consultada SEMPRE, inclusive quando a tela de login declarou "tecnico".
    // Era esse pulo que mandava um produtor completar um cadastro de tecnico:
    // com `papel == tecnico` o codigo nem olhava a propriedade, nao achava
    // TecnicoRecord (porque nao havia) e concluia "tecnico sem perfil". O
    // cadastro seguinte criava um TecnicoRecord espurio na conta do produtor, e
    // dali em diante o download buscava o rebanho debaixo desse tecnico vazio.
    final propriedade = await queryPropriedadesRecordOnce(
      queryBuilder: (r) =>
          r.where('uidPersonProdutor', isEqualTo: person.reference),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    // So consultado quando nao ha propriedade: com propriedade a decisao ja
    // esta tomada, e esta e uma ida a rede no caminho critico do login.
    final tecnico = propriedade != null
        ? null
        : await queryTecnicoRecordOnce(
            queryBuilder: (r) => r.where(
              'uidPerson',
              whereIn: chavesUidPerson(
                authUid: currentUserUid,
                personDocId: person.reference.id,
              ),
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);

    final decisao = decidirPosLogin(
      papelDeclarado: papel,
      temPropriedadeDeProdutor: propriedade != null,
      temTecnico: tecnico != null,
    );

    return ResolucaoPapel(
      papel: decisao.papel,
      conflita: decisao.conflita,
      propriedade: propriedade,
    );
  }

  @override
  Future<SyncDestino> concluirLogin(ResolucaoPapel resolucao) async {
    // Migracao legado->ObjectBox: resgata (das prefs) os animais criados
    // offline pelo mecanismo antigo e limpa a chave.
    await migrarAnimaisOfflineLegadoDePrefs();

    return switch (resolucao.papel) {
      PapelResolvido.produtor =>
        DestinoInicioPropriedadeProdutor(resolucao.propriedade),
      PapelResolvido.tecnico => const DestinoDashboardTecnico(),
      PapelResolvido.cadastroTecnico => const DestinoCompletarPerfil(),
    };
  }
}
