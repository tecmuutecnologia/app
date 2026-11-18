import '/data/objectbox/entities/index.dart';
import '/data/objectbox/repositories/animal_repository.dart';
import '/data/objectbox/repositories/tecnico_repository.dart';
import '/data/objectbox/repositories/venda_animal_repository.dart';
import '/domain/animais/baixa_animal.dart';
import '/domain/plano/vagas.dart';

/// Baixa do animal (venda e descarte) e os "desfazer", gravando no ObjectBox
/// (offline-first; o sync propaga).
///
/// As regras ficam nas funções puras de `baixa_animal.dart`; aqui só se
/// aplica o resultado nos repositórios e se acerta a cota de vagas do plano.
/// A checagem "cabe mais um animal?" ao devolver ao rebanho
/// (`garantirVagaAnimal`) é da tela, antes de chamar o desfazer — ela precisa
/// do `BuildContext` para avisar o usuário.
class BaixaAnimalService {
  BaixaAnimalService({
    AnimalRepository? animais,
    VendaAnimalRepository? vendas,
    TecnicoRepository? tecnicos,
  })  : _animais = animais ?? AnimalRepository(),
        _vendas = vendas ?? VendaAnimalRepository(),
        _tecnicos = tecnicos ?? TecnicoRepository();

  final AnimalRepository _animais;
  final VendaAnimalRepository _vendas;
  final TecnicoRepository _tecnicos;

  /// Vende o animal: cria o registro da venda na propriedade e tira o animal
  /// do rebanho. Lança [StateError] se o animal não pode ser vendido (sêmen,
  /// já vendido, excluído) — antes de gravar qualquer coisa.
  Future<void> vender({
    required AnimalEntity animal,
    required String propriedadePath,
    required String dtVenda,
    required double valor,
  }) async {
    if (!podeVender(
        grupo: animal.grupoAnimal,
        status: animal.status,
        tipoBaixa: animal.tipoBaixa,
        isDeleted: animal.isDeleted)) {
      throw StateError('Este animal não pode ser vendido.');
    }
    // Decide antes do update: depois o status já é Descarte.
    final ocupava = animalOcupaVaga(animal);
    final tecnicoId = tecnicoIdDoPath(animal.parentPath);

    final venda = VendaAnimalEntity(
      parentPath: propriedadePath,
      uidPropriedadePath: propriedadePath,
      uidTecnicoPath: animal.parentPath,
      animalId: animal.firestoreId,
      nomeAnimal: animal.nomeAnimal,
      brincoAnimal: animal.brincoAnimal,
      grupoAnimal: animal.grupoAnimal,
      dtVenda: dtVenda,
      valorVenda: valor,
    );
    // `add` gera o id definitivo antes de gravar (preGeneratesFirestoreId),
    // então ele existe mesmo offline.
    await _vendas.add(venda);

    await _animais.update(
      animal,
      dadosVenda(
          animal: animal,
          dtVenda: dtVenda,
          valor: valor,
          idVenda: venda.firestoreId!),
    );
    if (ocupava && tecnicoId != null) _tecnicos.devolverCotaAnimais(tecnicoId);
  }

  Future<void> descartar({
    required AnimalEntity animal,
    required String dt,
    required String? motivo,
  }) async {
    final ocupava = animalOcupaVaga(animal);
    final tecnicoId = tecnicoIdDoPath(animal.parentPath);
    await _animais.update(
        animal, dadosDescarte(animal: animal, dt: dt, motivo: motivo));
    if (ocupava && tecnicoId != null) _tecnicos.devolverCotaAnimais(tecnicoId);
  }

  /// Apaga (soft delete) a venda vigente — a receita sai do Financeiro — e
  /// devolve o animal ao rebanho ou aos Descartados, conforme a origem.
  Future<void> desfazerVenda(AnimalEntity animal) async {
    if (!ehVendido(animal.status, animal.tipoBaixa)) return;
    final voltaAoRebanho = desfazerVendaMexeEmVaga(animal);
    final tecnicoId = tecnicoIdDoPath(animal.parentPath);

    final idVenda = animal.idVendaAtual;
    if (idVenda != null) {
      final venda = _vendas.getByFirestoreId(idVenda);
      if (venda != null && !venda.isDeleted) await _vendas.softDelete(venda);
    }
    await _animais.update(animal, dadosDesfazerVenda(animal));
    if (voltaAoRebanho && tecnicoId != null) {
      _tecnicos.debitarCotaAnimais(tecnicoId);
    }
  }

  /// Devolve o descartado ao rebanho, no status de antes do descarte.
  Future<void> desfazerDescarte(AnimalEntity animal) async {
    if (!ehDescartadoSemVenda(animal.status, animal.tipoBaixa)) return;
    final tecnicoId = tecnicoIdDoPath(animal.parentPath);
    await _animais.update(animal, dadosDesfazerDescarte(animal));
    if (tecnicoId != null) _tecnicos.debitarCotaAnimais(tecnicoId);
  }
}
