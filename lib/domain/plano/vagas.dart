import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';
import 'package:tecmuu/domain/animais/classificacao_animal.dart';

/// Animal ocupa vaga do plano enquanto não foi excluído nem descartado.
/// Sêmen e touro contam: só o descarte libera a vaga.
bool animalOcupaVaga(AnimalEntity a) => !a.isDeleted && !ehDescarte(a.status);

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
