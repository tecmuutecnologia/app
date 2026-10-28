/// Inseminação de um ou vários animais de uma vez (modal de inseminação).
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/schema/structs/animais_produtores_struct.dart';

/// Um animal a inseminar, com o que o modal precisa para gravar e para avisar.
class AlvoInseminacao {
  const AlvoInseminacao({
    required this.nome,
    this.referencia,
    this.uidAnimalOffline,
    this.dtUltimaInseminacao = '',
  });

  /// Título exibido ("nome - brinco", só o nome ou só o brinco).
  final String nome;

  /// Documento do animal no Firestore; nulo para animal criado offline.
  final DocumentReference? referencia;

  /// Identidade local do animal criado offline.
  final String? uidAnimalOffline;

  /// `dd/MM/yyyy` da última inseminação; vazio se nunca foi inseminado.
  final String dtUltimaInseminacao;

  factory AlvoInseminacao.doStruct(AnimaisProdutoresStruct a) {
    final temBrinco = a.brincoAnimal != -1;
    final nome = a.nomeAnimal.isNotEmpty && temBrinco
        ? '${a.nomeAnimal} - ${a.brincoAnimal}'
        : a.nomeAnimal.isNotEmpty
            ? a.nomeAnimal
            : a.brincoAnimal.toString();
    return AlvoInseminacao(
      nome: nome,
      referencia: a.uidAnimal,
      uidAnimalOffline: a.uidAnimalOffline.isEmpty ? null : a.uidAnimalOffline,
      dtUltimaInseminacao: a.dtUltimaInseminacao,
    );
  }
}

/// Os alvos que já têm inseminação DEPOIS de [dataNova] (`dd/MM/yyyy`): gravar
/// trocaria uma data mais recente por uma mais antiga, então o modal pergunta
/// antes. Mesma data não conta; quem nunca foi inseminado nunca entra.
List<AlvoInseminacao> comInseminacaoMaisRecente(
  List<AlvoInseminacao> alvos,
  String dataNova,
) {
  final nova = _data(dataNova);
  if (nova == null) return const [];
  return alvos.where((a) {
    final atual = _data(a.dtUltimaInseminacao);
    return atual != null && atual.isAfter(nova);
  }).toList();
}

/// "Darth" para um animal; "3 animais: Darth, Tetê, 21" para vários (até 5
/// nomes, depois "e mais N").
String resumoAlvos(List<AlvoInseminacao> alvos) {
  if (alvos.length == 1) return alvos.first.nome;
  const limite = 5;
  final nomes = alvos.take(limite).map((a) => a.nome).join(', ');
  final resto = alvos.length - limite;
  return '${alvos.length} animais: $nomes${resto > 0 ? ' e mais $resto' : ''}';
}

DateTime? _data(String texto) {
  final p = texto.trim().split('/');
  if (p.length != 3) return null;
  final d = int.tryParse(p[0]), m = int.tryParse(p[1]), a = int.tryParse(p[2]);
  if (d == null || m == null || a == null) return null;
  return DateTime(a, m, d);
}
