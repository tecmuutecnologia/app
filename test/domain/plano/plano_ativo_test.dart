import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/plano/plano_ativo.dart';

void main() {
  const a1 = AssinaturaResumo(
      path: 'assinatura-tecnico/a1', planoPath: 'planos-tecnicos/start');
  const a2 = AssinaturaResumo(
      path: 'assinatura-tecnico/a2', planoPath: 'planos-tecnicos/pro');

  test('acha o plano pela ativa que aponta para a assinatura mais nova', () {
    final ativas = [
      AtivaResumo(
          assinaturaPath: 'assinatura-tecnico/a2',
          dtAssinatura: DateTime(2026, 5))
    ];
    expect(planoAtivoPath(assinaturas: [a1, a2], ativas: ativas),
        'planos-tecnicos/pro');
  });
  test('duas ativas: vence a de dtAssinatura mais recente', () {
    final ativas = [
      AtivaResumo(
          assinaturaPath: 'assinatura-tecnico/a2',
          dtAssinatura: DateTime(2026, 5)),
      AtivaResumo(
          assinaturaPath: 'assinatura-tecnico/a1',
          dtAssinatura: DateTime(2026, 1)),
    ];
    expect(planoAtivoPath(assinaturas: [a1, a2], ativas: ativas),
        'planos-tecnicos/pro');
    expect(
        planoAtivoPath(assinaturas: [a1, a2], ativas: ativas.reversed.toList()),
        'planos-tecnicos/pro');
  });
  test('ativa apontando para assinatura de outro técnico ou nenhuma → null',
      () {
    expect(planoAtivoPath(assinaturas: const [], ativas: const []), isNull);
    expect(
        planoAtivoPath(assinaturas: [
          a1
        ], ativas: [
          const AtivaResumo(assinaturaPath: 'assinatura-tecnico/zz')
        ]),
        isNull);
  });
}
