/// Assinatura do técnico e o plano para o qual ela aponta.
class AssinaturaResumo {
  const AssinaturaResumo({required this.path, this.planoPath});

  final String path;
  final String? planoPath;
}

/// Registro de "assinatura ativa" que aponta para uma assinatura.
class AtivaResumo {
  const AtivaResumo({this.assinaturaPath, this.dtAssinatura});

  final String? assinaturaPath;
  final DateTime? dtAssinatura;
}

/// Plano vigente: entre as ativas que apontam para uma assinatura do técnico,
/// vale a de [AtivaResumo.dtAssinatura] mais recente (data nula perde).
/// Nada casou -> `null`.
String? planoAtivoPath({
  required List<AssinaturaResumo> assinaturas,
  required List<AtivaResumo> ativas,
}) {
  final porPath = {for (final a in assinaturas) a.path: a};
  AtivaResumo? melhor;
  for (final ativa in ativas) {
    if (!porPath.containsKey(ativa.assinaturaPath)) continue;
    final atual = melhor;
    if (atual == null) {
      melhor = ativa;
      continue;
    }
    final d = ativa.dtAssinatura;
    final dAtual = atual.dtAssinatura;
    if (d != null && (dAtual == null || d.isAfter(dAtual))) melhor = ativa;
  }
  if (melhor == null) return null;
  return porPath[melhor.assinaturaPath]?.planoPath;
}
