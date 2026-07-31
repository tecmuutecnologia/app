import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Codec do payload da fila de operações pendentes (offline).
///
/// O `toFirestore()` das entidades produz mapas que podem conter `DateTime`
/// (entidades antigas) ou `Timestamp` (entidades novas) — nenhum deles é
/// JSON-serializável. Tentar `jsonEncode` direto lança
/// `JsonUnsupportedObjectError`, quebrando o salvamento OFFLINE (online não
/// passa pela fila, por isso só falhava sem internet).
///
/// Este codec serializa datas como um marcador ISO-8601 (`{'__dt__': ...}`) e
/// as reconstrói como `DateTime` na leitura. O Firestore converte `DateTime`
/// em `Timestamp` ao gravar, então o tipo final no banco fica consistente.
/// Incremento atômico a ser aplicado num campo numérico quando a operação sair
/// da fila. Existe porque `FieldValue.increment` é opaco — não dá para lê-lo de
/// volta para serializar. Este tipo carrega o delta pela fila e vira um
/// `FieldValue.increment` só na hora de gravar.
///
/// Guardar o DELTA, e não o valor final, é o que mantém a contagem correta
/// quando várias operações se acumulam offline ou quando outro dispositivo
/// mexeu no mesmo contador nesse meio-tempo.
class QueueIncrement {
  const QueueIncrement(this.by);

  final int by;

  @override
  bool operator ==(Object other) => other is QueueIncrement && other.by == by;

  @override
  int get hashCode => by.hashCode;
}

class QueuePayloadCodec {
  const QueuePayloadCodec._();

  static const String _dateKey = '__dt__';
  static const String _refKey = '__ref__';
  static const String _incKey = '__inc__';

  /// Serializa [data] (que pode conter `DateTime`/`Timestamp`/`DocumentReference`)
  /// em JSON.
  static String encode(Map<String, dynamic> data) =>
      jsonEncode(data, toEncodable: _toEncodable);

  /// Desserializa o JSON, reconstruindo datas como `DateTime` e referências como
  /// `DocumentReference`.
  static Map<String, dynamic> decode(String json) =>
      Map<String, dynamic>.from(_revive(jsonDecode(json)) as Map);

  static Object? _toEncodable(Object? value) {
    if (value is DateTime) return {_dateKey: value.toIso8601String()};
    if (value is Timestamp) {
      return {_dateKey: value.toDate().toIso8601String()};
    }
    if (value is DocumentReference) return {_refKey: value.path};
    if (value is QueueIncrement) return {_incKey: value.by};
    return value; // tipos genuinamente não suportados ainda lançam (intencional)
  }

  static dynamic _revive(dynamic value) {
    if (value is Map) {
      if (value.length == 1 && value[_dateKey] is String) {
        return DateTime.parse(value[_dateKey] as String);
      }
      if (value.length == 1 && value[_refKey] is String) {
        return FirebaseFirestore.instance.doc(value[_refKey] as String);
      }
      if (value.length == 1 && value[_incKey] is int) {
        return FieldValue.increment(value[_incKey] as int);
      }
      return value.map((k, v) => MapEntry(k, _revive(v)));
    }
    if (value is List) return value.map(_revive).toList();
    return value;
  }
}
