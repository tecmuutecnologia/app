import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/objectbox/offline_first_sync_service.dart';
import 'sync_state.dart';

/// Porta estreita entre a tela de sincronizacao e a infraestrutura.
///
/// Existe para o controller ser testavel: o projeto nao usa mockito, e nem
/// ObjectBox nem Firestore podem ser inicializados em teste. O fake do teste
/// implementa estes cinco membros e nada mais.
abstract class SyncGateway {
  /// Se ja ha animais no cache local. Decide se ficar offline e fatal ou nao.
  bool get temDadosLocais;

  Stream<SyncProgress> get progressStream;

  /// Ultimo progresso emitido, para a tela nao renderizar vazia se montar
  /// depois do primeiro lote.
  SyncProgress? get ultimoProgresso;

  /// Download completo (ou sincronizacao de pendencias, se ja houver dados).
  /// Lanca `SyncOfflineException` ou `SyncFalhaException`.
  Future<void> baixarTudo();

  /// Busca person/tecnico, liga os listeners remotos, aquece caches e resolve
  /// para onde navegar. `papel` nulo = descobrir de quem e a sessao.
  Future<SyncDestino> concluirLogin(SyncPapel? papel);
}

/// Sobrescrito no `main`/`app` com a implementacao real e, no teste, com um fake.
final syncGatewayProvider = Provider<SyncGateway>(
  (ref) => throw UnimplementedError('syncGatewayProvider precisa de override'),
);
