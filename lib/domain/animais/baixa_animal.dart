import '../../data/objectbox/entities/animal_entity.dart';
import '../financeiro/vendas_por_mes.dart' show parseDataBr;
import 'classificacao_animal.dart';

/// Baixa do animal: ele sai do rebanho por DESCARTE ou por VENDA.
///
/// Os dois casos gravam `status = 'Descarte'` — assim todos os filtros
/// existentes (`ehDescarte`), a conta de vagas, o painel web e as versões
/// antigas do app continuam tratando o animal como fora do rebanho. O que
/// diferencia a venda é o campo `tipoBaixa`. Descartes gravados antes desta
/// versão não têm `tipoBaixa` e contam como descarte.
const String kTipoBaixaVenda = 'venda';
const String kTipoBaixaDescarte = 'descarte';

/// Motivo gravado em `motivoDescarteAnimal` numa venda, para que telas e
/// versões antigas que exibem o motivo mostrem algo coerente.
const String kMotivoVenda = 'Venda';

/// Vendido = em baixa E com `tipoBaixa` de venda. Nunca olhar só o
/// `tipoBaixa`: uma versão antiga pode restaurar o animal (status volta a
/// 'Vazia') sem limpar o campo.
bool ehVendido(String? status, String? tipoBaixa) =>
    ehDescarte(status) && tipoBaixa == kTipoBaixaVenda;

/// Em baixa por descarte (inclui descartes antigos, sem `tipoBaixa`).
bool ehDescartadoSemVenda(String? status, String? tipoBaixa) =>
    ehDescarte(status) && tipoBaixa != kTipoBaixaVenda;

/// Sêmen nunca é vendido; animal já vendido ou excluído também não. Um
/// descartado pode ser vendido (sai dos Descartados e vai para os Vendidos).
bool podeVender({
  required String? grupo,
  required String? status,
  required String? tipoBaixa,
  required bool isDeleted,
}) =>
    !isDeleted && !ehSemens(grupo) && !ehVendido(status, tipoBaixa);

// ---------------------------------------------------------------------------
// Mapas de atualização do animal (aplicados por `AnimalRepository.update`).
// Funções puras para que as regras de venda/descarte/desfazer fiquem testáveis
// sem banco.
// ---------------------------------------------------------------------------

/// Campos de baixa. Ao desfazer, todos vão no mapa com `null` para que o
/// ObjectBox e o Firestore os APAGUEM (o update comum ignora nulos).
const List<String> kCamposBaixa = [
  'tipoBaixa',
  'statusAnterior',
  'idStatusAnteriorAnimal',
  'dtVendaAnimal',
  'valorVendaAnimal',
  'idVendaAtual',
  'motivoDescarteAnterior',
  'dtDescarteAnterior',
];

Map<String, dynamic> _limpos() => {for (final k in kCamposBaixa) k: null};

/// `true` se a venda deste animal foi feita a partir dos Descartados — então
/// desfazê-la o devolve aos Descartados, não ao rebanho.
bool vendaVeioDeDescarte(AnimalEntity a) =>
    a.motivoDescarteAnterior != null || a.dtDescarteAnterior != null;

/// Venda. Se o animal já estava descartado, guarda o descarte (motivo/data) em
/// `*DescarteAnterior` — com `''` quando o descarte antigo não tinha o dado,
/// pois é a presença desses campos que marca a origem — e mantém o
/// `statusAnterior` de antes do descarte.
Map<String, dynamic> dadosVenda({
  required AnimalEntity animal,
  required String dtVenda,
  required double valor,
  required String idVenda,
}) {
  final eraDescartado = ehDescarte(animal.status);
  return {
    ..._limpos(),
    'status': kStatusDescarte,
    'tipoBaixa': kTipoBaixaVenda,
    'motivoDescarteAnimal': kMotivoVenda,
    'dtDescarteAnimal': dtVenda,
    'dtVendaAnimal': dtVenda,
    'valorVendaAnimal': valor,
    'idVendaAtual': idVenda,
    'statusAnterior': eraDescartado ? animal.statusAnterior : animal.status,
    'idStatusAnteriorAnimal':
        eraDescartado ? animal.idStatusAnteriorAnimal : animal.idStatusAnimal,
    if (eraDescartado) ...{
      'motivoDescarteAnterior': animal.motivoDescarteAnimal ?? '',
      'dtDescarteAnterior': animal.dtDescarteAnimal ?? '',
    },
  };
}

/// Descarte, guardando o status de antes para o "desfazer".
Map<String, dynamic> dadosDescarte({
  required AnimalEntity animal,
  required String dt,
  required String? motivo,
}) =>
    {
      ..._limpos(),
      'status': kStatusDescarte,
      'tipoBaixa': kTipoBaixaDescarte,
      'dtDescarteAnimal': dt,
      'motivoDescarteAnimal': motivo,
      'statusAnterior': animal.status,
      'idStatusAnteriorAnimal': animal.idStatusAnimal,
    };

/// Desfaz a venda: volta aos Descartados (se veio de lá) ou ao status anterior.
Map<String, dynamic> dadosDesfazerVenda(AnimalEntity animal) {
  if (vendaVeioDeDescarte(animal)) {
    return {
      ..._limpos(),
      'status': kStatusDescarte,
      'tipoBaixa': kTipoBaixaDescarte,
      'motivoDescarteAnimal': animal.motivoDescarteAnterior,
      'dtDescarteAnimal': animal.dtDescarteAnterior,
      'statusAnterior': animal.statusAnterior,
      'idStatusAnteriorAnimal': animal.idStatusAnteriorAnimal,
    };
  }
  return _voltaAoRebanho(animal);
}

/// Desfaz o descarte. Descartes antigos, sem status anterior, voltam como
/// 'Vazia' (comportamento de sempre do "Restaurar").
Map<String, dynamic> dadosDesfazerDescarte(AnimalEntity animal) =>
    _voltaAoRebanho(animal);

Map<String, dynamic> _voltaAoRebanho(AnimalEntity animal) => {
      ..._limpos(),
      'status': animal.statusAnterior ?? 'Vazia',
      'idStatusAnimal': animal.idStatusAnteriorAnimal ?? 2,
    };

/// Desfazer a venda devolve o animal ao rebanho (volta a ocupar vaga), a não
/// ser que ela tenha vindo dos Descartados.
bool desfazerVendaMexeEmVaga(AnimalEntity a) => !vendaVeioDeDescarte(a);

// ---------------------------------------------------------------------------
// Formulário de venda
// ---------------------------------------------------------------------------

/// Valor digitado em reais. Aceita o padrão brasileiro ('1.234,56',
/// 'R$ 10,00', '1500', '1.500') e também o ponto como decimal quando ele é o
/// único separador e vem seguido de 1 ou 2 dígitos ('1500.50', '10.5') — é o
/// que o teclado numérico em inglês oferece; ler esse ponto como milhar
/// multiplicaria o valor por 100. `null` se vazio, malformado ('1.2.3') ou
/// não positivo.
double? parseValorReais(String texto) {
  final t = texto.replaceAll('R\$', '').replaceAll(' ', '').trim();
  String? numero;
  if (RegExp(r'^\d+\.\d{1,2}$').hasMatch(t)) {
    numero = t; // ponto decimal
  } else if (RegExp(r'^\d+(,\d{1,2})?$').hasMatch(t) ||
      RegExp(r'^\d{1,3}(\.\d{3})+(,\d{1,2})?$').hasMatch(t)) {
    numero = t.replaceAll('.', '').replaceAll(',', '.');
  }
  final v = numero == null ? null : double.tryParse(numero);
  if (v == null || v <= 0 || v.isInfinite) return null;
  return v;
}

/// Mensagem de erro da data da venda, ou `null` se válida.
String? validarDataVenda(String texto, {required DateTime hoje}) {
  final data = parseDataBr(texto);
  if (data == null) return 'Informe uma data válida';
  if (data.isAfter(DateTime(hoje.year, hoje.month, hoje.day))) {
    return 'A data da venda não pode ser no futuro';
  }
  return null;
}
