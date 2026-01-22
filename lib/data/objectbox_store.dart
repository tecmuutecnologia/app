import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../objectbox.g.dart'; // Gerado pelo build_runner na raiz de lib/

/// Singleton para gerenciar o ObjectBox Store
class ObjectBoxStore {
  static ObjectBoxStore? _instance;
  late final Store _store;
  late final String _directoryPath;

  ObjectBoxStore._internal(this._store, this._directoryPath);

  /// Obtém a instância singleton do ObjectBox Store
  static ObjectBoxStore get instance {
    if (_instance == null) {
      throw StateError(
        'ObjectBoxStore não foi inicializado. Chame ObjectBoxStore.init() primeiro.',
      );
    }
    return _instance!;
  }

  /// Inicializa o ObjectBox Store
  /// Deve ser chamado no main() antes de runApp()
  static Future<ObjectBoxStore> init() async {
    if (_instance != null) {
      return _instance!;
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    final objectBoxPath = p.join(appDocDir.path, 'objectbox');

    // Cria o diretório se não existir
    final dir = Directory(objectBoxPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final store = await openStore(directory: objectBoxPath);
    _instance = ObjectBoxStore._internal(store, objectBoxPath);

    return _instance!;
  }

  /// Obtém o Store do ObjectBox
  Store get store => _store;

  /// Caminho do diretório onde o banco do ObjectBox está salvo
  String get directoryPath => _directoryPath;

  /// Fecha o Store (útil para testes)
  void close() {
    _store.close();
    _instance = null;
  }

  /// Limpa todos os dados (útil para testes/debug)
  Future<void> clearAllData() async {
    // Implementar quando tivermos as entidades
  }
}
