/// Interface base para repositórios com padrão local-first
///
/// Todos os repositórios devem implementar este contrato:
/// 1. Primeiro buscar/salvar localmente (ObjectBox)
/// 2. Sincronizar com Firestore em background
abstract class BaseRepository<T, E> {
  /// Busca um item por ID local
  Future<T?> getById(int localId);

  /// Busca um item por ID do Firestore
  Future<T?> getByFirestoreId(String firestoreId);

  /// Busca todos os itens (não deletados)
  Future<List<T>> getAll();

  /// Salva ou atualiza um item localmente
  /// Marca automaticamente para sincronização
  Future<int> save(T item);

  /// Salva múltiplos itens localmente
  Future<List<int>> saveAll(List<T> items);

  /// Deleta um item (soft delete)
  /// Marca para sincronizar deleção com Firestore
  Future<void> delete(int localId);

  /// Sincroniza alterações pendentes com Firestore
  Future<void> syncWithFirestore();

  /// Busca dados atualizados do Firestore
  Future<void> fetchFromFirestore();
}
