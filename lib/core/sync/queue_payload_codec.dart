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
class QueuePayloadCodec {
  const QueuePayloadCodec._();

  static const String _dateKey = '__dt__';

  /// Serializa [data] (que pode conter `DateTime`/`Timestamp`) em JSON.
  static String encode(Map<String, dynamic> data) =>
      jsonEncode(data, toEncodable: _toEncodable);

  /// Desserializa o JSON, reconstruindo datas como `DateTime`.
  static Map<String, dynamic> decode(String json) =>
      Map<String, dynamic>.from(_revive(jsonDecode(json)) as Map);

  static Object? _toEncodable(Object? value) {
    if (value is DateTime) return {_dateKey: value.toIso8601String()};
    if (value is Timestamp) {
      return {_dateKey: value.toDate().toIso8601String()};
    }
    return value; // tipos genuinamente não suportados ainda lançam (intencional)
  }

  static dynamic _revive(dynamic value) {
    if (value is Map) {
      if (value.length == 1 && value[_dateKey] is String) {
        return DateTime.parse(value[_dateKey] as String);
      }
      return value.map((k, v) => MapEntry(k, _revive(v)));
    }
    if (value is List) return value.map(_revive).toList();
    return value;
  }
}
