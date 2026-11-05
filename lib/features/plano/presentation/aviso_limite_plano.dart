import 'package:flutter/material.dart';
import 'package:tecmuu/data/objectbox/repositories/tecnico_repository.dart';
import 'package:tecmuu/domain/plano/vagas.dart';

/// Núcleo testável: sem vaga, avisa o usuário e devolve `false`.
/// [restante] nulo (sem cota conhecida) não bloqueia.
Future<bool> mostrarAvisoSeSemVaga(
  BuildContext context, {
  required int? restante,
  required String titulo,
  required String mensagem,
}) async {
  if (temVaga(restante)) return true;
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
    {required String? tecnicoFirestoreId}) {
  final restante = tecnicoFirestoreId == null
      ? null
      : TecnicoRepository()
          .getByFirestoreId(tecnicoFirestoreId)
          ?.restanteLimiteAnimais;
  return mostrarAvisoSeSemVaga(
    context,
    restante: restante,
    titulo: 'Limite de animais do plano atingido.',
    mensagem: 'Descarte animais ou troque de plano para cadastrar novos.',
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
