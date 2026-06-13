/// Contrato comum das entidades sincronizáveis ObjectBox <-> Firestore.
///
/// Todas as entidades de domínio já carregavam, por convenção, os mesmos campos
/// de controle de sincronização (`firestoreId`, `needsSync`, `isDeleted`,
/// `lastModified`, etc.) e os métodos `toFirestore()`/`markAsModified()`. Esta
/// interface formaliza essa convenção para que a lógica de sincronização seja
/// escrita UMA vez de forma genérica em `BaseSyncRepository<E>`, em vez de
/// duplicada por entidade.
///
/// É apenas um contrato sobre campos/métodos que JÁ existem nas entidades —
/// não adiciona estado persistido, então não impacta o modelo do ObjectBox
/// (`objectbox-model.json` / `objectbox.g.dart`).
abstract interface class SyncableEntity {
  /// ID local do ObjectBox (0 = ainda não persistido).
  int get id;
  set id(int value);

  /// ID do documento correspondente no Firestore (`null` enquanto só existe
  /// localmente, aguardando o primeiro upload).
  String? get firestoreId;
  set firestoreId(String? value);

  /// Path do documento pai no Firestore (a coleção onde o documento vive).
  String? get parentPath;

  /// Última modificação local.
  DateTime? get lastModified;
  set lastModified(DateTime? value);

  /// Última sincronização bem-sucedida com o Firestore.
  DateTime? get lastSynced;
  set lastSynced(DateTime? value);

  /// `true` quando há mudanças locais ainda não enviadas ao Firestore.
  bool get needsSync;
  set needsSync(bool value);

  /// Soft delete: `true` marca para exclusão sem remover localmente de imediato.
  bool get isDeleted;
  set isDeleted(bool value);

  /// Serializa os campos de domínio para o formato do Firestore.
  Map<String, dynamic> toFirestore();

  /// Marca a entidade como modificada localmente (liga `needsSync` e atualiza
  /// `lastModified`).
  void markAsModified();
}
