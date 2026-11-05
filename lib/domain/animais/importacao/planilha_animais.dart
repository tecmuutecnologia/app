import 'package:intl/intl.dart';

import 'package:tecmuu/data/objectbox/entities/reference_entities.dart';
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';
import 'package:tecmuu/domain/animais/regras_cadastro_animal.dart';
import 'package:tecmuu/features/animais/application/status_animal_opcoes.dart';

/// Colunas A..J do modelo, na ordem.
const kCabecalhoModelo = [
  'Nome',
  'Número',
  'Raça',
  'Categoria',
  'Data de Nascimento',
  'Pai',
  'Mãe',
  'Parto',
  'Inseminação',
  'Status',
];

/// Siglas aceitas na coluna Raça; só valem se a raça alvo existir na lista.
const kSiglasRaca = {
  'ho': 'Holandesa',
  'je': 'Jersey',
  'gir': 'Gir',
  'gi': 'Gir',
  'gl': 'Girolando',
  'gh': 'Girolando',
  'pa': 'Pardo Suíço',
  'ps': 'Pardo Suíço',
  'ne': 'Nelore',
};

const _statusConhecidos = [
  'Inseminada',
  'Inseminada PP',
  'Prenha',
  'Seca',
  'Pré Parto',
  'Vazia',
];

const _acentos = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'ç': 'c', 'ñ': 'n',
};

/// Minúsculas, sem acento, sem `*`, sem `(opcional)` e sem espaços.
String normalizar(String s) {
  var t = s.toLowerCase().replaceAll('(opcional)', '').replaceAll('*', '');
  final sb = StringBuffer();
  for (final c in t.split('')) {
    sb.write(_acentos[c] ?? c);
  }
  return sb.toString().replaceAll(RegExp(r'\s+'), '');
}

String _limpaCabecalho(Object? c) {
  if (c == null) return '';
  return c
      .toString()
      .replaceAll(RegExp(r'\(opcional\)', caseSensitive: false), '')
      .replaceAll('*', '')
      .trim();
}

/// Confere A..J com o modelo; devolve a primeira divergência ou `null`.
String? erroDeCabecalho(List<Object?> linha1) {
  for (var i = 0; i < kCabecalhoModelo.length; i++) {
    final cel = i < linha1.length ? linha1[i] : null;
    final texto = cel == null ? '' : cel.toString();
    if (normalizar(texto) != normalizar(kCabecalhoModelo[i])) {
      final letra = String.fromCharCode(65 + i);
      final achado = _limpaCabecalho(cel);
      return 'A coluna $letra deveria ser ${kCabecalhoModelo[i]} e está '
          '${achado.isEmpty ? 'vazia' : achado}.';
    }
  }
  return null;
}

DateTime _dataValida(int a, int m, int d) {
  final dt = DateTime(a, m, d);
  if (dt.year != a || dt.month != m || dt.day != d) {
    throw const FormatException('data inexistente');
  }
  return dt;
}

/// Converte a célula em `dd/MM/yyyy`; `null` se vazia; `FormatException` se
/// inválida.
String? lerData(Object? celula) {
  if (celula == null) return null;
  DateTime dt;
  if (celula is DateTime) {
    dt = DateTime(celula.year, celula.month, celula.day);
  } else if (celula is num) {
    // Serial do Excel (base 1899-12-30); UTC evita deslize por horário de verão.
    final u = DateTime.utc(1899, 12, 30).add(Duration(days: celula.floor()));
    dt = DateTime(u.year, u.month, u.day);
  } else {
    final t = celula.toString().trim();
    if (t.isEmpty) return null;
    RegExpMatch? m;
    if ((m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})(?:[T ].*)?$').firstMatch(t)) !=
        null) {
      dt = _dataValida(
          int.parse(m!.group(1)!), int.parse(m.group(2)!), int.parse(m.group(3)!));
    } else if ((m = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4}|\d{2})$')
            .firstMatch(t)) !=
        null) {
      var ano = int.parse(m!.group(3)!);
      if (m.group(3)!.length == 2) ano += 2000;
      dt = _dataValida(ano, int.parse(m.group(2)!), int.parse(m.group(1)!));
    } else {
      throw FormatException('data inválida: $t');
    }
  }
  return DateFormat('dd/MM/yyyy').format(dt);
}

class LinhaPlanilha {
  const LinhaPlanilha({
    required this.numero,
    required this.identificacao,
    this.entrada,
    this.animal,
    this.motivo,
  });

  /// Linha no Excel (2 em diante).
  final int numero;
  final String identificacao;
  final EntradaCadastroAnimal? entrada;

  /// Animal montado pela regra de cadastro; `null` quando recusada.
  final AnimaisProdutoresStruct? animal;
  final String? motivo;

  bool get valida => motivo == null;
}

Object? _cel(List<Object?> l, int i) => i < l.length ? l[i] : null;

String _texto(Object? c) => c == null ? '' : c.toString().trim();

DateTime _parse(String ddMMyyyy) => DateFormat('dd/MM/yyyy').parseStrict(ddMMyyyy);

String? _resolveRaca(String v, List<String> racas) {
  final n = normalizar(v);
  for (final r in racas) {
    if (normalizar(r) == n) return r;
  }
  final sigla = kSiglasRaca[n];
  if (sigla != null) {
    for (final r in racas) {
      if (normalizar(r) == normalizar(sigla)) return r;
    }
  }
  final prefixo = racas.where((r) => normalizar(r).startsWith(n)).toList();
  return prefixo.length == 1 ? prefixo.first : null;
}

String? _resolveGrupo(String v, List<String> grupos) {
  final n = normalizar(v);
  for (final g in grupos) {
    final ng = normalizar(g);
    if (ng == n || ng == '${n}s') return g;
  }
  return null;
}

String? _resolveStatus(String v, List<StatusAnimalEntity> status) {
  final n = normalizar(v);
  for (final s in _statusConhecidos) {
    if (normalizar(s) == n) return s;
  }
  for (final s in status) {
    final d = s.descricao;
    if (d != null && normalizar(d) == n) return d;
  }
  return null;
}

/// Valida cada linha (menos a 1, cabeçalho) e monta o animal pela mesma regra
/// do cadastro manual. Linhas totalmente vazias são ignoradas.
List<LinhaPlanilha> lerLinhas(
  List<List<Object?>> linhas, {
  required List<String> racas,
  required List<String> grupos,
  required List<StatusAnimalEntity> status,
  required DateTime hoje,
}) {
  final saida = <LinhaPlanilha>[];
  final hojeDia = DateTime(hoje.year, hoje.month, hoje.day);

  for (var i = 1; i < linhas.length; i++) {
    final l = linhas[i];
    if (List.generate(10, (c) => _texto(_cel(l, c))).every((t) => t.isEmpty)) {
      continue;
    }
    final numero = i + 1;
    final nome = _texto(_cel(l, 0));
    final brincoCru = _cel(l, 1);

    String ident(String brinco) {
      if (nome != '' && brinco != '' && brinco != '-1') return '$nome - $brinco';
      return nome != '' ? nome : brinco;
    }

    LinhaPlanilha recusa(String brinco, String motivo) =>
        LinhaPlanilha(numero: numero, identificacao: ident(brinco), motivo: motivo);

    // Número
    var brinco = '';
    if (brincoCru is num) {
      if (brincoCru == brincoCru.truncate()) {
        brinco = brincoCru.truncate().toString();
      } else {
        saida.add(recusa(_texto(brincoCru), 'número inválido: $brincoCru'));
        continue;
      }
    } else {
      final t = _texto(brincoCru);
      if (t.isNotEmpty && !RegExp(r'^\d+$').hasMatch(t)) {
        saida.add(recusa(t, 'número inválido: $t'));
        continue;
      }
      brinco = t;
    }

    // Raça
    final racaCrua = _texto(_cel(l, 2));
    if (racaCrua.isEmpty) {
      saida.add(recusa(brinco, 'raça não informada'));
      continue;
    }
    final raca = _resolveRaca(racaCrua, racas);
    if (raca == null) {
      saida.add(recusa(brinco, 'raça não reconhecida: $racaCrua'));
      continue;
    }

    // Categoria
    final grupoCru = _texto(_cel(l, 3));
    if (grupoCru.isEmpty) {
      saida.add(recusa(brinco, 'categoria não informada'));
      continue;
    }
    final grupo = _resolveGrupo(grupoCru, grupos);
    if (grupo == null) {
      saida.add(recusa(brinco, 'categoria não reconhecida: $grupoCru'));
      continue;
    }
    final ehVacaOuNovilha = grupo == 'Vacas' || grupo == 'Novilhas';
    final ng = normalizar(grupo);

    // Datas
    String? lerCol(int idx, String letra) {
      final cel = _cel(l, idx);
      String? d;
      try {
        d = lerData(cel);
      } on FormatException {
        throw FormatException('data inválida na coluna $letra: ${_texto(cel)}');
      }
      if (d != null && _parse(d).isAfter(hojeDia)) {
        throw FormatException('data no futuro na coluna $letra: $d');
      }
      return d;
    }

    String? nasc, parto, insem;
    try {
      nasc = lerCol(4, 'E');
      if (ehVacaOuNovilha) {
        parto = lerCol(7, 'H');
        insem = lerCol(8, 'I');
      }
    } on FormatException catch (e) {
      saida.add(recusa(brinco, e.message));
      continue;
    }

    // Status (só Vacas/Novilhas)
    String? statusFinal;
    if (ehVacaOuNovilha) {
      final cru = _texto(_cel(l, 9));
      if (cru.isNotEmpty) {
        statusFinal = _resolveStatus(cru, status);
        if (statusFinal == null) {
          saida.add(recusa(brinco, 'status não reconhecido: $cru'));
          continue;
        }
        final opcoes = opcoesStatusAnimal(
          statusDisponiveis: status,
          ultimoParto: parto == null ? null : _parse(parto),
          ultimaInseminacao: insem == null ? null : _parse(insem),
          grupo: grupo,
        );
        if (!opcoes.contains(statusFinal)) {
          saida.add(recusa(brinco,
              'status $statusFinal não combina com as datas de parto e inseminação'));
          continue;
        }
      }
    }

    final entrada = EntradaCadastroAnimal(
      nome: nome,
      brinco: brinco,
      raca: raca,
      grupo: grupo,
      dtNascimento: nasc ?? '',
      touro: _texto(_cel(l, 5)),
      vaca: _texto(_cel(l, 6)),
      status: statusFinal,
      dtUltimoParto: parto ?? '',
      dtUltimaInseminacao: insem ?? '',
      liberaInseminacao: (ng == 'touros' || ng == 'semens') ? true : null,
      hoje: hoje,
    );
    final r = montarAnimal(entrada);
    saida.add(switch (r) {
      CadastroValido(:final animal) => LinhaPlanilha(
          numero: numero,
          identificacao: animal.nomeBrincoConcat,
          entrada: entrada,
          animal: animal),
      CadastroRecusado(:final titulo) =>
        LinhaPlanilha(numero: numero, identificacao: ident(brinco), entrada: entrada, motivo: titulo),
    });
  }
  return saida;
}
