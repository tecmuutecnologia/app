import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';
import 'package:tecmuu/data/objectbox/entities/propriedade_entity.dart';
import 'package:tecmuu/domain/animais/classificacao_animal.dart';

/// Animal ocupa vaga do plano enquanto não foi excluído nem descartado.
/// Sêmen e touro contam: só o descarte libera a vaga.
bool animalOcupaVaga(AnimalEntity a) => !a.isDeleted && !ehDescarte(a.status);

/// Animais que ocupam vaga no técnico [tecnicoPath] (ex.: `tecnico/abc`).
int contarAnimaisAtivos(Iterable<AnimalEntity> animais,
        {required String tecnicoPath}) =>
    animais
        .where((a) => a.parentPath == tecnicoPath && animalOcupaVaga(a))
        .length;

/// Produtor ocupa vaga quando a conta foi criada. Propriedade na lixeira
/// continua contando: a conta do produtor segue existindo.
int contarProdutoresAtivos(Iterable<PropriedadeEntity> props,
        {required String tecnicoPath}) =>
    props.where((p) => p.parentPath == tecnicoPath && p.contaCriada).length;

/// Saldo de vagas de um recurso (animais ou produtores).
/// [restante] pode ser negativo: quem passou do limite só não cadastra novos.
class SaldoVagas {
  const SaldoVagas({
    required this.limite,
    required this.quantidade,
    required this.restante,
  });

  final int limite;
  final int quantidade;
  final int restante;

  @override
  bool operator ==(Object other) =>
      other is SaldoVagas &&
      other.limite == limite &&
      other.quantidade == quantidade &&
      other.restante == restante;

  @override
  int get hashCode => Object.hash(limite, quantidade, restante);

  @override
  String toString() =>
      'SaldoVagas(limite: $limite, quantidade: $quantidade, restante: $restante)';
}

/// Recalcula o saldo a partir da contagem real. Se o plano não informa limite
/// (<= 0), mantém o limite que o técnico já tinha.
SaldoVagas recalcularSaldo({
  required int limiteDoPlano,
  required int limiteAtual,
  required int ativos,
}) {
  final limite = limiteDoPlano > 0 ? limiteDoPlano : limiteAtual;
  return SaldoVagas(
      limite: limite, quantidade: ativos, restante: limite - ativos);
}

/// `null` = técnico ausente no aparelho (produtor): não bloqueia.
bool temVaga(int? restante) => restante == null || restante > 0;

/// Quantos dos [validos] cabem no saldo; `null` = sem limite conhecido.
int quantosCabem({required int? restante, required int validos}) =>
    restante == null ? validos : restante.clamp(0, validos);

/// `tecnico/abc` -> `abc`; qualquer outra forma -> `null`.
String? tecnicoIdDoPath(String? parentPath) {
  if (parentPath == null) return null;
  final partes = parentPath.split('/');
  if (partes.length != 2 || partes[0] != 'tecnico' || partes[1].isEmpty) {
    return null;
  }
  return partes[1];
}
