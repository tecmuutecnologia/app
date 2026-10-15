import 'dart:async';
import 'dart:typed_data';

import '/data/objectbox/assinaturas_locais.dart';
import '/data/objectbox/index.dart';

enum Assinante { tecnico, produtor }

/// Grava a assinatura no aparelho e no resumo da visita, sem esperar a rede.
///
/// Antes o PNG subia ao Storage e só então o resumo era gravado: o modal
/// ficava preso no upload e, offline, a assinatura se perdia. O envio agora
/// corre em segundo plano (e o sync tenta de novo se falhar).
///
/// Devolve `false` se o resumo não existe no aparelho.
Future<bool> assinarResumo({
  required String? firestoreIdResumo,
  required Uint8List png,
  required Assinante assinante,
}) async {
  if (firestoreIdResumo == null) return false;
  final repo = ResumoVisitaRepository();
  final resumo = repo.getByFirestoreId(firestoreIdResumo);
  if (resumo == null) return false;

  final referencia = await AssinaturasLocais.salvar(png);
  switch (assinante) {
    case Assinante.tecnico:
      resumo.assinaturaTecnico = referencia;
    case Assinante.produtor:
      resumo.assinaturaProdutor = referencia;
  }
  await repo.save(resumo);

  unawaited(AssinaturasLocais.enviarPendentes());
  return true;
}
