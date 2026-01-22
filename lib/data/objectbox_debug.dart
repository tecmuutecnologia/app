import 'dart:io';
import 'package:flutter/foundation.dart';

import '../objectbox.g.dart';
import 'objectbox_store.dart';
import 'local/animais_produtores_entity.dart';
import 'local/produtor_entity.dart';
import 'local/propriedades_entity.dart';
import 'local/tecnico_entity.dart';

/// Utilitários simples de debug para validar dados no ObjectBox
class ObjectBoxDebug {
  static Store get _store => ObjectBoxStore.instance.store;

  /// Loga o caminho do banco e lista os arquivos presentes
  static Future<void> logStorePathAndFiles() async {
    final path = ObjectBoxStore.instance.directoryPath;
    debugPrint('ObjectBox DB path: $path');
    try {
      final dir = Directory(path);
      if (await dir.exists()) {
        final entries = await dir
            .list(recursive: false, followLinks: false)
            .map((e) => e.path.split('/').last)
            .toList();
        debugPrint('Arquivos no diretório ObjectBox: $entries');
      } else {
        debugPrint('Diretório do ObjectBox não existe.');
      }
    } catch (e) {
      debugPrint('Erro ao listar arquivos do ObjectBox: $e');
    }
  }

  /// Conta registros básicos por entidade e loga
  static Future<void> logEntityCounts() async {
    try {
      final animaisBox = _store.box<AnimaisProdutoresEntity>();
      final produtorBox = _store.box<ProdutorEntity>();
      final propBox = _store.box<PropriedadesEntity>();
      final tecnicoBox = _store.box<TecnicoEntity>();

      debugPrint('Contagens ObjectBox:');
      debugPrint(' - AnimaisProdutores: ${animaisBox.count()}');
      debugPrint(' - Produtor: ${produtorBox.count()}');
      debugPrint(' - Propriedades: ${propBox.count()}');
      debugPrint(' - Tecnico: ${tecnicoBox.count()}');
    } catch (e) {
      debugPrint('Erro ao contar entidades: $e');
    }
  }

  /// Verifica se um animal com o brinco informado está salvo localmente
  static Future<void> verifyAnimalByBrinco(int brinco) async {
    try {
      final box = _store.box<AnimaisProdutoresEntity>();
      final query = box
          .query(AnimaisProdutoresEntity_.brincoAnimal.equals(brinco) &
              AnimaisProdutoresEntity_.isDeleted.equals(false))
          .build();
      final item = query.findFirst();
      query.close();
      if (item != null) {
        debugPrint(
            'Encontrado animal com brinco=$brinco (id local=${item.id}, firestoreId=${item.firestoreId})');
      } else {
        debugPrint('Nenhum animal encontrado com brinco=$brinco');
      }
    } catch (e) {
      debugPrint('Erro ao verificar animal por brinco: $e');
    }
  }

  /// Obtém uma fotografia dos animais não deletados (para debug pontual)
  static Future<List<AnimaisProdutoresEntity>> snapshotAnimais() async {
    final box = _store.box<AnimaisProdutoresEntity>();
    final query =
        box.query(AnimaisProdutoresEntity_.isDeleted.equals(false)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Após salvar um item, use este helper para validar rapidamente
  static Future<void> assertSaved<T>(Box<T> box, int id) async {
    final saved = box.get(id);
    if (saved == null) {
      debugPrint('Falha: item id=$id não encontrado após put()');
    } else {
      debugPrint('OK: item id=$id recuperado após put()');
    }
  }
}
