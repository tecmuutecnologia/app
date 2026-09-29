import 'package:cloud_firestore/cloud_firestore.dart';

/// Lê uma data que pode vir como `Timestamp` (documento do Firestore) ou como
/// `DateTime` (entidade do ObjectBox).
///
/// Existe porque a migração para o ObjectBox trocou o tipo por baixo de mapas
/// que antes vinham do Firestore, e os casts fixos (`as Timestamp?`) passaram a
/// estourar: foi o que derrubou a geração do receituário com
/// "type 'DateTime' is not a subtype of type 'Timestamp?' in type cast".
///
/// Tipo inesperado devolve nulo em vez de lançar: quem chama já trata data
/// ausente, e uma exceção aqui aborta a geração inteira do PDF.
DateTime? comoData(Object? valor) => switch (valor) {
      Timestamp t => t.toDate(),
      DateTime d => d,
      _ => null,
    };
