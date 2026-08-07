import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
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
  Stream<SyncProgress> get progressStream =>
      OfflineFirstSyncService.isInitialized
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
  Future<void> baixarTudo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await ObjectBoxAuthHelper.onUserLogin(user);
  }

  @override
  Future<SyncDestino> concluirLogin(SyncPapel? papel) async {
    // Migração legado→ObjectBox: resgata (das prefs) os animais criados
    // offline pelo mecanismo antigo e limpa a chave.
    await migrarAnimaisOfflineLegadoDePrefs();

    final person = await queryPersonRecordOnce(
      queryBuilder: (r) => r.where('uid', isEqualTo: currentUserUid),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    if (person == null) return const DestinoCompletarPerfil();

    // `papel` nulo = o app foi aberto pela rota `/` e ninguem informou quem
    // esta entrando. A propriedade ligada ao person e o unico sinal que nao
    // confunde "produtor" com "tecnico sem perfil completo": o tecnico
    // incompleto nao tem propriedade como produtor, entao segue no ramo de
    // baixo e cai no `DestinoCompletarPerfil`. Deduzir pela existencia do
    // TecnicoRecord — o que a `VerificaTipoLoginPage` fazia — mandava esse
    // tecnico para a tela do produtor.
    if (papel != SyncPapel.tecnico) {
      final propriedade = await queryPropriedadesRecordOnce(
        queryBuilder: (r) =>
            r.where('uidPersonProdutor', isEqualTo: person.reference),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if (propriedade != null) {
        return DestinoInicioPropriedadeProdutor(propriedade);
      }
      // Produtor declarado e sem propriedade: a tela do produtor ja lida com
      // o vazio, e mandar para o dashboard do tecnico seria pior.
      if (papel == SyncPapel.produtor) {
        return const DestinoInicioPropriedadeProdutor(null);
      }
    }

    final tecnico = await queryTecnicoRecordOnce(
      queryBuilder: (r) => r.where('uidPerson', isEqualTo: person.reference.id),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    if (tecnico == null) return const DestinoCompletarPerfil();

    // Sincronização em tempo real Firestore->ObjectBox: reflete mudanças
    // remotas (ex.: outro dispositivo) automaticamente. Só nativo.
    if (ObjectBoxService.isInitialized) {
      await RemoteSyncListenersService.initialize();
      RemoteSyncListenersService.instance
          .startAllListeners(tecnico.reference.path);
    }

    // Aquecimento de cache do Firestore para as telas seguintes.
    await queryPropriedadesRecordOnce(parent: tecnico.reference);
    await queryAcoesRecordOnce(parent: tecnico.reference);
    await queryResumoDaVisitaRecordOnce(
      queryBuilder: (r) => r.where('uidTecnico', isEqualTo: tecnico.reference),
    );
    await queryTipoAcoesRecordOnce();

    return const DestinoDashboardTecnico();
  }
}
