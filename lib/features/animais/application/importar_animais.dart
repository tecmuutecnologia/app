import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '/core/ui/custom_functions.dart' as functions;
import '/data/objectbox/entities/animal_entity.dart';
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
/// [lote] para a UI seguir fluida. A cota é debitada a cada lote (e no fim, o
/// resto): assim o recálculo periódico encontra o delta na fila e não
/// sobrescreve o saldo com a contagem do servidor no meio da importação.
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
  var naoDebitados = 0;
  void debitarPendentes() {
    if (naoDebitados > 0) debitar(naoDebitados);
    naoDebitados = 0;
  }

  for (var i = 0; i < cabem; i++) {
    final l = a.validas[i];
    try {
      await criar(l);
      importados++;
      naoDebitados++;
    } catch (e, st) {
      debugPrint('⚠️ importação linha ${l.numero}: $e\n$st');
      recusadas.add(Recusa(l.numero, l.identificacao, 'erro ao gravar'));
    }
    aoProgredir?.call(i + 1, cabem);
    if ((i + 1) % lote == 0) {
      debitarPendentes();
      await Future.delayed(Duration.zero);
    }
  }
  debitarPendentes();
  for (final l in a.validas.skip(cabem)) {
    recusadas.add(Recusa(l.numero, l.identificacao, 'limite do plano atingido'));
  }
  recusadas.sort((x, y) => x.linha.compareTo(y.linha));
  return ResultadoImportacao(importados: importados, recusadas: recusadas);
}

/// Duplicidade contra os animais ativos de [animais] — mesma regra de
/// `existeAnimalAtivoComNomeBrinco` (status != 'Descarte' e não excluído),
/// mas indexada num Set. Nome nulo gravado vale como '' (a planilha manda ''
/// para "sem nome").
bool Function(String nome, int brinco) jaExisteEm(
    Iterable<AnimalEntity> animais) {
  final chaves = {
    for (final a in animais)
      if (a.status != 'Descarte' && !a.isDeleted)
        '${a.nomeAnimal ?? ''}|${a.brincoAnimal}',
  };
  return (nome, brinco) => chaves.contains('$nome|$brinco');
}

/// Checagem de duplicidade contra os animais ativos da propriedade (ObjectBox),
/// lidos uma vez só: consultar o box por linha seria O(linhas × animais).
bool Function(String nome, int brinco) jaExisteNaPropriedade(
        String propriedadePath) =>
    jaExisteEm(AnimalRepository().getAnimaisByPropriedade(propriedadePath));

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
