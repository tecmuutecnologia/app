import '../../../core/constants/grupos_racas_constantes.dart';
import '../entities/index.dart';
import '../objectbox_service.dart';

/// Leitura das TABELAS DE REFERÊNCIA (grupo, raça, status animal) direto do
/// ObjectBox — populadas no `_downloadReferenceTables` do sync. É síncrono e
/// funciona offline (sem `StreamBuilder` de rede, que fazia os dropdowns dos
/// formulários de animal piscarem/perderem o valor quando sem conexão).
///
/// Fallback para as constantes (`kGruposDescricoes`/`kRacasDescricoes`) quando a
/// box ainda está vazia (ex.: instalação nova antes do 1º sync).
class ReferenciaRepository {
  ReferenciaRepository({ObjectBoxService? objectBox})
      : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  /// Descrições dos grupos (ordenadas por `grupoId`). Fallback: constante.
  List<String> grupos() {
    final itens = _objectBox.grupoBox.getAll()
      ..sort((a, b) => a.grupoId.compareTo(b.grupoId));
    final descricoes = itens
        .map((e) => e.descricao)
        .whereType<String>()
        .where((d) => d.isNotEmpty)
        .toList();
    return descricoes.isNotEmpty ? descricoes : kGruposDescricoes.toList();
  }

  /// Descrições das raças. Fallback: constante.
  List<String> racas() {
    final descricoes = _objectBox.racaBox
        .getAll()
        .map((e) => e.descricao)
        .whereType<String>()
        .where((d) => d.isNotEmpty)
        .toList();
    return descricoes.isNotEmpty ? descricoes : kRacasDescricoes.toList();
  }

  /// Status de animal (ordenados por `statusId`). O formulário usa `.descricao`.
  List<StatusAnimalEntity> statusAnimais() {
    return _objectBox.statusAnimalBox.getAll()
      ..sort((a, b) => a.statusId.compareTo(b.statusId));
  }
}
