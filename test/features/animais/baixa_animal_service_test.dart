import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/objectbox/repositories/animal_repository.dart';
import 'package:tecmuu/data/objectbox/repositories/tecnico_repository.dart';
import 'package:tecmuu/data/objectbox/repositories/venda_animal_repository.dart';
import 'package:tecmuu/features/animais/application/baixa_animal_service.dart';

// Fakes sem nenhum método: qualquer gravação estoura o teste. A guarda tem de
// barrar ANTES de tocar nos repositórios.
class _Animais extends Fake implements AnimalRepository {}

class _Vendas extends Fake implements VendaAnimalRepository {}

class _Tecnicos extends Fake implements TecnicoRepository {}

void main() {
  final service = BaixaAnimalService(
      animais: _Animais(), vendas: _Vendas(), tecnicos: _Tecnicos());

  test('vender animal já vendido lança StateError sem gravar nada', () {
    final vendido = AnimalEntity(
        grupoAnimal: 'Vacas', status: 'Descarte', tipoBaixa: 'venda');
    expect(
        () => service.vender(
            animal: vendido,
            propriedadePath: 'tecnico/t/propriedades/p',
            dtVenda: '18/11/2026',
            valor: 10),
        throwsStateError);
  });

  test('vender sêmen lança StateError sem gravar nada', () {
    expect(
        () => service.vender(
            animal: AnimalEntity(grupoAnimal: 'Sêmens'),
            propriedadePath: 'tecnico/t/propriedades/p',
            dtVenda: '18/11/2026',
            valor: 10),
        throwsStateError);
  });
}
