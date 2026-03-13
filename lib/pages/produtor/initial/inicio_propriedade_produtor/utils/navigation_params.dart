import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Classe que encapsula os parâmetros de navegação comuns usados em todas
/// as rotas da propriedade do produtor.
///
/// Isso evita repetição dos mesmos parâmetros em cada navegação.
class PropriedadeNavigationParams {
  const PropriedadeNavigationParams({
    required this.uidPropriedade,
    required this.nomePropriedade,
    required this.uidTecnico,
    required this.emailPropriedade,
    required this.visitaPresencial,
    required this.diasDg,
  });

  final DocumentReference? uidPropriedade;
  final String? nomePropriedade;
  final DocumentReference? uidTecnico;
  final String? emailPropriedade;
  final bool? visitaPresencial;
  final String? diasDg;

  /// Converte os parâmetros para o formato esperado pelo GoRouter.
  Map<String, String> toQueryParameters() {
    return {
      'uidPropriedade': serializeParam(
        uidPropriedade,
        ParamType.DocumentReference,
      ),
      'nomePropriedade': serializeParam(
        nomePropriedade,
        ParamType.String,
      ),
      'uidTecnico': serializeParam(
        uidTecnico,
        ParamType.DocumentReference,
      ),
      'emailPropriedade': serializeParam(
        emailPropriedade,
        ParamType.String,
      ),
      'visitaPresencial': serializeParam(
        visitaPresencial,
        ParamType.bool,
      ),
      'diasDg': serializeParam(
        diasDg,
        ParamType.String,
      ),
    }.withoutNulls;
  }

  /// Cria uma cópia dos parâmetros com possíveis alterações.
  PropriedadeNavigationParams copyWith({
    DocumentReference? uidPropriedade,
    String? nomePropriedade,
    DocumentReference? uidTecnico,
    String? emailPropriedade,
    bool? visitaPresencial,
    String? diasDg,
  }) {
    return PropriedadeNavigationParams(
      uidPropriedade: uidPropriedade ?? this.uidPropriedade,
      nomePropriedade: nomePropriedade ?? this.nomePropriedade,
      uidTecnico: uidTecnico ?? this.uidTecnico,
      emailPropriedade: emailPropriedade ?? this.emailPropriedade,
      visitaPresencial: visitaPresencial ?? this.visitaPresencial,
      diasDg: diasDg ?? this.diasDg,
    );
  }
}
