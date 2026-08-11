import '../../../data/objectbox/entities/reference_entities.dart';

/// Opções do dropdown "Status" no cadastro de vaca/novilha, derivadas das duas
/// datas reprodutivas do formulário.
///
/// A regra é a de sempre: quem pariu depois da última inseminação está vazia;
/// quem foi inseminada depois do último parto pode estar em qualquer estágio da
/// gestação. O que muda é que agora isso é uma função pura, tipada e testável.
///
/// Ela nasceu de um bug: a lógica vivia numa closure dentro do `build` que
/// recebia a lista de status como `dynamic`. O `dynamic` apagava o tipo
/// (`.map((e) => e.descricao)` devolvia `List<dynamic>`, e o dropdown exige
/// `List<String>`), então preencher "último parto" numa vaca sem inseminação
/// quebrava o build a cada frame e a tela ficava cinza. As datas também eram
/// comparadas com `!`, estourando null check quando só uma estava preenchida.
List<String> opcoesStatusAnimal({
  required List<StatusAnimalEntity> statusDisponiveis,
  DateTime? ultimoParto,
  DateTime? ultimaInseminacao,
  String? grupo,
}) {
  const cobertos = [
    'Inseminada',
    'Inseminada PP',
    'Prenha',
    'Seca',
    'Pré Parto',
  ];

  if (ultimoParto != null && ultimaInseminacao != null) {
    return ultimaInseminacao.isAfter(ultimoParto)
        ? _filtra(statusDisponiveis, cobertos)
        : _filtra(statusDisponiveis, const ['Vazia']);
  }

  if (ultimaInseminacao != null) {
    // Sem parto registrado: novilha nunca esteve lactante, então não seca.
    final permitidos = grupo == 'Novilhas'
        ? cobertos.where((e) => e != 'Seca').toList()
        : cobertos;
    return _filtra(statusDisponiveis, permitidos);
  }

  // Só o parto, ou nenhuma data: vazia.
  return _filtra(statusDisponiveis, const ['Vazia']);
}

/// Status que os seletores de data pré-selecionam depois de uma escolha.
///
/// É a mesma regra de [opcoesStatusAnimal], reduzida a um valor: só está
/// coberta quem tem inseminação registrada depois do último parto. Vive aqui
/// junto das opções de propósito — quando as duas regras moravam separadas, os
/// seletores conseguiam pré-selecionar um status que não estava entre as
/// opções, e o campo aparecia vazio no formulário.
String statusSugerido({DateTime? ultimoParto, DateTime? ultimaInseminacao}) {
  if (ultimaInseminacao == null) return 'Vazia';
  if (ultimoParto == null) return 'Inseminada';
  return ultimaInseminacao.isAfter(ultimoParto) ? 'Inseminada' : 'Vazia';
}

/// Mantém a ordem e a grafia da tabela de referência, que é o que o resto do
/// app grava e lê.
///
/// O fallback existe porque a referência vem de download: numa instalação nova
/// offline ela pode estar vazia, e um dropdown sem nenhuma opção — com um valor
/// selecionado que não existe — é outra tela quebrada.
List<String> _filtra(
  List<StatusAnimalEntity> statusDisponiveis,
  List<String> permitidos,
) {
  final daReferencia = statusDisponiveis
      .map((e) => e.descricao)
      .whereType<String>()
      .where(permitidos.contains)
      .toList();

  return daReferencia.isEmpty ? List<String>.from(permitidos) : daReferencia;
}
