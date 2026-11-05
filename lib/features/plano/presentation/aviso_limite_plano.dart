import 'package:flutter/material.dart';
import 'package:tecmuu/data/objectbox/repositories/tecnico_repository.dart';
import 'package:tecmuu/domain/plano/vagas.dart';

/// Núcleo testável: se as [quantidade] vagas não cabem todas no saldo, avisa
/// o usuário e devolve `false`. [restante] nulo (sem cota conhecida) não
/// bloqueia.
Future<bool> mostrarAvisoSeSemVaga(
  BuildContext context, {
  required int? restante,
  required String titulo,
  required String mensagem,
  int quantidade = 1,
}) async {
  if (quantosCabem(restante: restante, validos: quantidade) >= quantidade) {
    return true;
  }
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Ok'),
        ),
      ],
    ),
  );
  return false;
}

/// Id nulo ou técnico ausente (aparelho de produtor) não bloqueia.
Future<bool> garantirVagaAnimal(BuildContext context,
        {required String? tecnicoFirestoreId}) =>
    garantirVagasAnimais(context,
        tecnicoFirestoreId: tecnicoFirestoreId, quantidade: 1);

/// Como [garantirVagaAnimal], para um lote: bloqueia se não couberem todos.
Future<bool> garantirVagasAnimais(BuildContext context,
    {required String? tecnicoFirestoreId, required int quantidade}) {
  final restante = tecnicoFirestoreId == null
      ? null
      : TecnicoRepository()
          .getByFirestoreId(tecnicoFirestoreId)
          ?.restanteLimiteAnimais;
  final parcial = quantidade > 1 && restante != null && restante > 0;
  return mostrarAvisoSeSemVaga(
    context,
    restante: restante,
    quantidade: quantidade,
    titulo: 'Limite de animais do plano atingido.',
    mensagem: parcial
        ? 'Sua conta permite mais $restante ${restante == 1 ? 'animal' : 'animais'}. '
            'Selecione menos animais ou troque de plano.'
        : 'Descarte animais ou troque de plano para cadastrar novos.',
  );
}

Future<bool> garantirVagaProdutor(BuildContext context,
    {required String? tecnicoFirestoreId}) {
  final restante = tecnicoFirestoreId == null
      ? null
      : TecnicoRepository()
          .getByFirestoreId(tecnicoFirestoreId)
          ?.restanteLimiteProdutores;
  return mostrarAvisoSeSemVaga(
    context,
    restante: restante,
    titulo: 'Limite de produtores do plano atingido.',
    mensagem:
        'Exclua uma propriedade ou troque de plano para ativar novas contas.',
  );
}
