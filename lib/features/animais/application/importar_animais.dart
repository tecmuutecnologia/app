import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/ui/custom_functions.dart' as functions;
import '/data/objectbox/repositories/index.dart';
import '/domain/animais/importacao/planilha_animais.dart';
import '/domain/plano/vagas.dart';
import 'animal_struct_adapter.dart';

/// Linha da planilha que não vai ser importada, com o motivo para o relatório.
class Recusa {
  const Recusa(this.linha, this.identificacao, this.motivo);
  final int linha;
  final String identificacao;
  final String motivo;
}

class AnaliseImportacao {
  const AnaliseImportacao({required this.validas, required this.recusadas});
  final List<LinhaPlanilha> validas;
  final List<Recusa> recusadas;
}

class ResultadoImportacao {
  const ResultadoImportacao({required this.importados, required this.recusadas});
  final int importados;
  final List<Recusa> recusadas;
}

/// Separa as linhas importáveis das recusadas (leitura, já cadastrado e
/// repetido na própria planilha). `recusadas` sai ordenada por linha.
AnaliseImportacao analisarImportacao(
  List<LinhaPlanilha> linhas, {
  required bool Function(String nome, int brinco) jaExiste,
}) {
  final validas = <LinhaPlanilha>[];
  final recusadas = <Recusa>[];
  final vistos = <String, int>{}; // "nome|brinco" -> linha da 1ª ocorrência
  for (final l in linhas) {
    if (!l.valida || l.animal == null) {
      recusadas.add(Recusa(l.numero, l.identificacao, l.motivo ?? 'inválida'));
      continue;
    }
    final nome = l.animal!.nomeAnimal;
    final brinco = l.animal!.brincoAnimal;
    if (jaExiste(nome, brinco)) {
      recusadas.add(Recusa(l.numero, l.identificacao, 'já cadastrado'));
      continue;
    }
    final chave = '$nome|$brinco';
    final anterior = vistos[chave];
    if (anterior != null) {
      recusadas
          .add(Recusa(l.numero, l.identificacao, 'repetido na linha $anterior'));
      continue;
    }
    vistos[chave] = l.numero;
    validas.add(l);
  }
  recusadas.sort((a, b) => a.linha.compareTo(b.linha));
  return AnaliseImportacao(validas: validas, recusadas: recusadas);
}

/// Grava até [restante] linhas (todas se `null`), cedendo ao event loop a cada
/// [lote] para a UI seguir fluida, e debita a cota uma única vez no fim.
Future<ResultadoImportacao> gravarImportacao(
  AnaliseImportacao a, {
  required int? restante,
  required Future<void> Function(LinhaPlanilha) criar,
  required void Function(int quantidade) debitar,
  void Function(int feitos, int total)? aoProgredir,
  int lote = 20,
}) async {
  final cabem = quantosCabem(restante: restante, validos: a.validas.length);
  final recusadas = [...a.recusadas];
  var importados = 0;
  for (var i = 0; i < cabem; i++) {
    final l = a.validas[i];
    try {
      await criar(l);
      importados++;
    } catch (_) {
      recusadas.add(Recusa(l.numero, l.identificacao, 'erro ao gravar'));
    }
    aoProgredir?.call(i + 1, cabem);
    if ((i + 1) % lote == 0) await Future.delayed(Duration.zero);
  }
  for (final l in a.validas.skip(cabem)) {
    recusadas.add(Recusa(l.numero, l.identificacao, 'limite do plano atingido'));
  }
  if (importados > 0) debitar(importados);
  recusadas.sort((x, y) => x.linha.compareTo(y.linha));
  return ResultadoImportacao(importados: importados, recusadas: recusadas);
}

/// Checagem de duplicidade contra os animais ativos da propriedade (ObjectBox).
bool Function(String nome, int brinco) jaExisteNaPropriedade(
    String propriedadePath) {
  final repo = AnimalRepository();
  return (nome, brinco) => repo.existeAnimalAtivoComNomeBrinco(
        propriedadePath: propriedadePath,
        nome: nome,
        brinco: brinco,
      );
}

/// Ligação real: grava offline-first via [criarAnimalOffline] e debita a cota.
Future<ResultadoImportacao> importarAnimais(
  AnaliseImportacao a, {
  required DocumentReference uidPropriedade,
  required String tecnicoFirestoreId,
  required int? restante,
  void Function(int feitos, int total)? aoProgredir,
}) {
  return gravarImportacao(
    a,
    restante: restante,
    aoProgredir: aoProgredir,
    criar: (l) async {
      final animal = l.animal!
        ..uidTecnicoPropriedade = uidPropriedade
        ..uidAnimalOffline = functions.criarUidRandom();
      await criarAnimalOffline(animal);
    },
    debitar: (n) => TecnicoRepository()
        .debitarCotaAnimais(tecnicoFirestoreId, quantidade: n),
  );
}
