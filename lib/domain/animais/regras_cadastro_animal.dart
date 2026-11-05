import 'package:intl/intl.dart';

import 'package:tecmuu/core/ui/custom_functions.dart' as functions;
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';

/// Campos do formulário de cadastro de animal (textos vazios = `''`, datas em
/// `dd/MM/yyyy`, como os controllers da tela).
class EntradaCadastroAnimal {
  const EntradaCadastroAnimal({
    this.nome = '',
    this.brinco = '',
    this.raca,
    this.grupo,
    this.peso = '',
    this.dtNascimento = '',
    this.touro = '',
    this.vaca = '',
    this.status,
    this.dtUltimaInseminacao = '',
    this.dtUltimoParto = '',
    this.touroInseminacao,
    this.liberaInseminacao,
    required this.hoje,
  });

  final String nome;
  final String brinco;
  final String? raca;
  final String? grupo;
  final String peso;
  final String dtNascimento;
  final String touro;
  final String vaca;
  final String? status;
  final String dtUltimaInseminacao;
  final String dtUltimoParto;
  final String? touroInseminacao;
  final bool? liberaInseminacao;
  final DateTime hoje;
}

sealed class ResultadoCadastro {
  const ResultadoCadastro();
}

/// Animal montado; quem chama preenche `uidTecnicoPropriedade` e
/// `uidAnimalOffline`.
class CadastroValido extends ResultadoCadastro {
  const CadastroValido(this.animal);
  final AnimaisProdutoresStruct animal;
}

class CadastroRecusado extends ResultadoCadastro {
  const CadastroRecusado(this.titulo, this.mensagem);
  final String titulo;
  final String mensagem;
}

const _tituloSemInseminacao =
    'Data última inseminação vazia ou Touro inseminação não selecionado.';
const _mensagemSemInseminacao = 'Preencha os campos obrigatórios.';

/// Regra de cadastro manual extraída de `_cadastrarAnimal`
/// (cadastrar_novo_animal_page.dart), sem mudar nenhum valor gravado.
ResultadoCadastro montarAnimal(EntradaCadastroAnimal e) {
  if (e.nome == '' && e.brinco == '') {
    return const CadastroRecusado(
        'Nome ou brinco obrigatório.', 'Preencha ao menos um dos campos.');
  }

  final hoje = DateFormat('dd/MM/yyyy').format(e.hoje);
  final inseminacao = e.dtUltimaInseminacao;
  final parto = e.dtUltimoParto;

  String nomeBrincoConcat() {
    if (e.nome != '' && e.brinco != '' && e.brinco != '-1') {
      return '${e.nome} - ${e.brinco}';
    } else if (e.nome != '') {
      return e.nome;
    } else {
      return e.brinco;
    }
  }

  // Campos comuns a todos os ramos (a Sêmen não grava `vaca`, ver abaixo).
  AnimaisProdutoresStruct base({
    String? vaca,
    String? status,
    String? dtUltimaInseminacao,
    String? dtUltimoParto,
    String? nomeTouroUltimaInseminacao,
    String? dtPartoPrevisto,
    String? dtSecPrevista,
    String? dtPrePartoPrevista,
    int? totalInseminacoes,
    int? totalPartos,
    String? dtPP,
    String? dtUltimoPP,
    String? dtDgMais,
    DateTime? compararDtUltimaInseminacao,
    int? idStatusAnimal,
    String? dtUltimoPartoContingencia,
    bool? liberaInseminacao,
  }) {
    return AnimaisProdutoresStruct(
      nomeAnimal: e.nome,
      racaAnimal: e.raca,
      pesoAnimal: e.peso,
      dtNascimento: e.dtNascimento,
      touro: e.touro,
      vaca: vaca,
      grupoAnimal: e.grupo,
      brincoAnimalOrder: e.brinco != '' ? int.tryParse(e.brinco) : 999999,
      brincoAnimal: e.brinco != '' ? int.tryParse(e.brinco) : -1,
      nomeBrincoConcat: nomeBrincoConcat(),
      status: status,
      dtUltimaInseminacao: dtUltimaInseminacao,
      dtUltimoParto: dtUltimoParto,
      nomeTouroUltimaInseminacao: nomeTouroUltimaInseminacao,
      dtPartoPrevisto: dtPartoPrevisto,
      dtSecPrevista: dtSecPrevista,
      dtPrePartoPrevista: dtPrePartoPrevista,
      totalInseminacoes: totalInseminacoes,
      totalPartos: totalPartos,
      dtPP: dtPP,
      dtUltimoPP: dtUltimoPP,
      dtDgMais: dtDgMais,
      compararDtUltimaInseminacao: compararDtUltimaInseminacao,
      idStatusAnimal: idStatusAnimal,
      dtUltimoPartoContingencia: dtUltimoPartoContingencia,
      liberaInseminacao: liberaInseminacao,
    );
  }

  // Previsões a partir da data da última inseminação.
  String prevParto() => functions.somarDataParto(inseminacao);
  String prevSec() => functions.somarDataSecagem(inseminacao);
  String prevPre() => functions.somarDataPreParto(inseminacao);
  DateTime comparar() => functions.converterDataUltimaInseminacao(inseminacao);

  final grupo = e.grupo;
  if (grupo == 'Vacas' || grupo == 'Novilhas') {
    final status = e.status;
    if (status == null || status == '') {
      return const CadastroRecusado(
          'Status é obrigatório.', 'Selecione ao menos um status.');
    }

    switch (status) {
      case 'Inseminada':
        if (inseminacao == '') {
          // Antes a tela saía calada; agora explica (decisão do spec).
          return const CadastroRecusado(
              _tituloSemInseminacao, _mensagemSemInseminacao);
        }
        if (parto == '') {
          return CadastroValido(base(
            vaca: e.vaca,
            status: status,
            dtUltimaInseminacao: inseminacao,
            nomeTouroUltimaInseminacao: e.touroInseminacao,
            dtPartoPrevisto: prevParto(),
            dtSecPrevista: prevSec(),
            dtPrePartoPrevista: prevPre(),
            totalInseminacoes: 1,
            compararDtUltimaInseminacao: comparar(),
            idStatusAnimal: 3,
          ));
        }
        return CadastroValido(base(
          vaca: e.vaca,
          status: status,
          dtUltimaInseminacao: inseminacao,
          dtUltimoParto: parto,
          nomeTouroUltimaInseminacao: e.touroInseminacao,
          dtPartoPrevisto: prevParto(),
          dtSecPrevista: prevSec(),
          dtPrePartoPrevista: prevPre(),
          totalInseminacoes: 1,
          totalPartos: 1,
          compararDtUltimaInseminacao: comparar(),
          idStatusAnimal: 3,
          dtUltimoPartoContingencia: parto,
        ));

      case 'Seca':
        if (grupo != 'Vacas') {
          return const CadastroRecusado(
              'O status de "Seca" é permitido somente em vacas.',
              'Atualize o status.');
        }
        // Seca não grava totalInseminacoes (igual à tela).
        return CadastroValido(base(
          vaca: e.vaca,
          status: status,
          dtUltimaInseminacao: inseminacao,
          dtPartoPrevisto: prevParto(),
          dtSecPrevista: prevSec(),
          dtPrePartoPrevista: prevPre(),
          nomeTouroUltimaInseminacao: e.touroInseminacao,
          compararDtUltimaInseminacao: comparar(),
          idStatusAnimal: 4,
        ));

      case 'Vazia':
        return CadastroValido(base(
          vaca: e.vaca,
          dtUltimoParto: parto,
          status: status,
          totalPartos: parto != '' ? 1 : 0,
          idStatusAnimal: 2,
          dtUltimoPartoContingencia: parto,
        ));

      case 'Prenha':
      case 'Inseminada PP':
      case 'Pré Parto':
        if (inseminacao == '') {
          return const CadastroRecusado(
              _tituloSemInseminacao, _mensagemSemInseminacao);
        }
        final ehPrenha = status == 'Prenha';
        final id = ehPrenha ? 6 : (status == 'Inseminada PP' ? 1 : 5);
        return CadastroValido(base(
          vaca: e.vaca,
          status: status,
          dtUltimaInseminacao: inseminacao,
          nomeTouroUltimaInseminacao: e.touroInseminacao,
          dtPartoPrevisto: prevParto(),
          dtSecPrevista: prevSec(),
          dtPrePartoPrevista: prevPre(),
          totalInseminacoes: 1,
          dtDgMais: ehPrenha ? hoje : null,
          dtPP: ehPrenha ? null : hoje,
          dtUltimoPP: ehPrenha ? null : hoje,
          dtUltimoParto: parto,
          compararDtUltimaInseminacao: comparar(),
          idStatusAnimal: id,
          dtUltimoPartoContingencia: parto,
        ));

      default:
        // A tela saía calada com status desconhecido; aqui vira recusa
        // (necessária para a planilha).
        return const CadastroRecusado(
            'Status inválido.', 'Selecione um status válido.');
    }
  }

  if (grupo == 'Touros') {
    return CadastroValido(
        base(vaca: e.vaca, liberaInseminacao: e.liberaInseminacao));
  }
  if (grupo == 'Sêmens') {
    // Sêmen não grava `vaca` (igual à tela).
    return CadastroValido(base(liberaInseminacao: e.liberaInseminacao));
  }
  return CadastroValido(base(vaca: e.vaca));
}
