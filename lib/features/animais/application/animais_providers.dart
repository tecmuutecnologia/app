import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../backend/objectbox/entities/index.dart';
import '../../../core/di/providers.dart';

/// Lista reativa de animais de uma propriedade, lida do ObjectBox via
/// `AnimalRepository` (offline-first), filtrando soft-deletes.
///
/// `family` pelo path do documento da propriedade (parentPath). A UI observa
/// este provider em vez de ler `FFAppState`/Firestore direto — qualquer escrita
/// local no repositório reflete automaticamente (ObjectBox `watch`).
final animaisByPropriedadeProvider =
    StreamProvider.family<List<AnimalEntity>, String>((ref, propriedadePath) {
  final repo = ref.watch(animalRepositoryProvider);
  return repo
      .watchAnimaisByPropriedade(propriedadePath)
      .map((animais) => animais.where((a) => !a.isDeleted).toList());
});
