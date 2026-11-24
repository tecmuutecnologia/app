import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/result/result.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/objectbox/repositories/animal_repository.dart';
import 'package:tecmuu/data/objectbox/repositories/tecnico_repository.dart';
import 'package:tecmuu/data/objectbox/repositories/venda_animal_repository.dart';
import 'package:tecmuu/features/animais/application/baixa_animal_service.dart';

/// Banco de animais falso: devolve a versão ATUAL (a do ObjectBox) e registra
/// os updates. Sem `atual`, qualquer gravação estoura (Fake).
class _Animais extends Fake implements AnimalRepository {
  _Animais([this.atual]);
  final AnimalEntity? atual;
  final updates = <Map<String, dynamic>>[];

  @override
  AnimalEntity? getByFirestoreId(String firestoreId) => atual;

  @override
  Future<Result<AnimalEntity>> update(
      AnimalEntity entity, Map<String, dynamic> data) async {
    updates.add(data);
    aplicarDadosNoAnimal(entity, data);
    return Success(entity);
  }
}

class _Vendas extends Fake implements VendaAnimalRepository {
  final excluidas = <VendaAnimalEntity>[];

  @override
  VendaAnimalEntity? getByFirestoreId(String firestoreId) => null;

  @override
  Future<Result<void>> softDelete(VendaAnimalEntity entity) async {
    excluidas.add(entity);
    return const Success(null);
  }
}

class _Tecnicos extends Fake implements TecnicoRepository {
  @override
  void devolverCotaAnimais(String tecnicoFirestoreId, {int quantidade = 1}) {}
  @override
  void debitarCotaAnimais(String tecnicoFirestoreId, {int quantidade = 1}) {}
}

const _prop = 'tecnico/t/propriedades/p';

void main() {
  test('vender animal já vendido lança StateError sem gravar nada', () {
    final service = BaixaAnimalService(
        animais: _Animais(), vendas: _Vendas(), tecnicos: _Tecnicos());
    final vendido = AnimalEntity(
        grupoAnimal: 'Vacas', status: 'Descarte', tipoBaixa: 'venda');
    expect(
        () => service.vender(
            animal: vendido,
            propriedadePath: _prop,
            dtVenda: '18/11/2026',
            valor: 10),
        throwsStateError);
  });

  test('vender sêmen lança StateError sem gravar nada', () {
    final service = BaixaAnimalService(
        animais: _Animais(), vendas: _Vendas(), tecnicos: _Tecnicos());
    expect(
        () => service.vender(
            animal: AnimalEntity(grupoAnimal: 'Sêmens'),
            propriedadePath: _prop,
            dtVenda: '18/11/2026',
            valor: 10),
        throwsStateError);
  });

  test('vender confere a versão ATUAL do banco, não a cópia da tela', () {
    // A tela abriu com o animal ativo; enquanto isso outro aparelho o vendeu.
    final copiaDaTela = AnimalEntity(
        firestoreId: 'a1', grupoAnimal: 'Vacas', status: 'Vazia');
    final noBanco = AnimalEntity(
        firestoreId: 'a1',
        grupoAnimal: 'Vacas',
        status: 'Descarte',
        tipoBaixa: 'venda');
    final service = BaixaAnimalService(
        animais: _Animais(noBanco), vendas: _Vendas(), tecnicos: _Tecnicos());
    expect(
        () => service.vender(
            animal: copiaDaTela,
            propriedadePath: _prop,
            dtVenda: '18/11/2026',
            valor: 10),
        throwsStateError);
  });

  test('descartar animal que já está em baixa não grava nada', () async {
    final noBanco = AnimalEntity(
        firestoreId: 'a1',
        grupoAnimal: 'Vacas',
        status: 'Descarte',
        tipoBaixa: 'venda',
        idVendaAtual: 'v1');
    final animais = _Animais(noBanco);
    final service = BaixaAnimalService(
        animais: animais, vendas: _Vendas(), tecnicos: _Tecnicos());

    final gravou = await service.descartar(
        animal: AnimalEntity(firestoreId: 'a1', status: 'Vazia'),
        dt: '18/11/2026',
        motivo: 'Idade');

    expect(gravou, isFalse);
    expect(animais.updates, isEmpty);
    expect(noBanco.idVendaAtual, 'v1');
  });

  test('desfazer venda que não está no aparelho exclui a venda no servidor',
      () async {
    // Vendido em OUTRO aparelho: o animal chegou pela escuta, a venda não.
    final noBanco = AnimalEntity(
        firestoreId: 'a1',
        parentPath: 'tecnico/t',
        uidTecnicoPropriedadePath: _prop,
        grupoAnimal: 'Vacas',
        status: 'Descarte',
        tipoBaixa: 'venda',
        statusAnterior: 'Vazia',
        idStatusAnteriorAnimal: 2,
        idVendaAtual: 'v1');
    final vendas = _Vendas();
    final service = BaixaAnimalService(
        animais: _Animais(noBanco), vendas: vendas, tecnicos: _Tecnicos());

    await service.desfazerVenda(noBanco);

    expect(vendas.excluidas, hasLength(1));
    expect(vendas.excluidas.single.firestoreId, 'v1');
    expect(vendas.excluidas.single.parentPath, _prop);
    expect(noBanco.status, 'Vazia');
  });
}
