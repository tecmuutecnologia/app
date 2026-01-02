import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PropriedadesRecord extends FirestoreRecord {
  PropriedadesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uidPersonProdutor" field.
  DocumentReference? _uidPersonProdutor;
  DocumentReference? get uidPersonProdutor => _uidPersonProdutor;
  bool hasUidPersonProdutor() => _uidPersonProdutor != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "cpf" field.
  String? _cpf;
  String get cpf => _cpf ?? '';
  bool hasCpf() => _cpf != null;

  // "endereco" field.
  String? _endereco;
  String get endereco => _endereco ?? '';
  bool hasEndereco() => _endereco != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  bool hasCidade() => _cidade != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "diasParaDg" field.
  String? _diasParaDg;
  String get diasParaDg => _diasParaDg ?? '';
  bool hasDiasParaDg() => _diasParaDg != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _uidPersonProdutor =
        snapshotData['uidPersonProdutor'] as DocumentReference?;
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _cpf = snapshotData['cpf'] as String?;
    _endereco = snapshotData['endereco'] as String?;
    _cidade = snapshotData['cidade'] as String?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _diasParaDg = snapshotData['diasParaDg'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('propriedades')
          : FirebaseFirestore.instance.collectionGroup('propriedades');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('propriedades').doc(id);

  static Stream<PropriedadesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PropriedadesRecord.fromSnapshot(s));

  static Future<PropriedadesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PropriedadesRecord.fromSnapshot(s));

  static PropriedadesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PropriedadesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PropriedadesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PropriedadesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PropriedadesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PropriedadesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPropriedadesRecordData({
  DocumentReference? uidPersonProdutor,
  String? email,
  String? displayName,
  String? cpf,
  String? endereco,
  String? cidade,
  String? phoneNumber,
  String? diasParaDg,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uidPersonProdutor': uidPersonProdutor,
      'email': email,
      'display_name': displayName,
      'cpf': cpf,
      'endereco': endereco,
      'cidade': cidade,
      'phone_number': phoneNumber,
      'diasParaDg': diasParaDg,
    }.withoutNulls,
  );

  return firestoreData;
}

class PropriedadesRecordDocumentEquality
    implements Equality<PropriedadesRecord> {
  const PropriedadesRecordDocumentEquality();

  @override
  bool equals(PropriedadesRecord? e1, PropriedadesRecord? e2) {
    return e1?.uidPersonProdutor == e2?.uidPersonProdutor &&
        e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.cpf == e2?.cpf &&
        e1?.endereco == e2?.endereco &&
        e1?.cidade == e2?.cidade &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.diasParaDg == e2?.diasParaDg;
  }

  @override
  int hash(PropriedadesRecord? e) => const ListEquality().hash([
        e?.uidPersonProdutor,
        e?.email,
        e?.displayName,
        e?.cpf,
        e?.endereco,
        e?.cidade,
        e?.phoneNumber,
        e?.diasParaDg
      ]);

  @override
  bool isValidKey(Object? o) => o is PropriedadesRecord;
}
