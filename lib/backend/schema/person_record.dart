import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PersonRecord extends FirestoreRecord {
  PersonRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "dtNascimento" field.
  String? _dtNascimento;
  String get dtNascimento => _dtNascimento ?? '';
  bool hasDtNascimento() => _dtNascimento != null;

  // "cpf" field.
  String? _cpf;
  String get cpf => _cpf ?? '';
  bool hasCpf() => _cpf != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "endereco" field.
  String? _endereco;
  String get endereco => _endereco ?? '';
  bool hasEndereco() => _endereco != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  bool hasCidade() => _cidade != null;

  // "bairro" field.
  String? _bairro;
  String get bairro => _bairro ?? '';
  bool hasBairro() => _bairro != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "empresa" field.
  String? _empresa;
  String get empresa => _empresa ?? '';
  bool hasEmpresa() => _empresa != null;

  // "tipo" field.
  String? _tipo;
  String get tipo => _tipo ?? '';
  bool hasTipo() => _tipo != null;

  void _initializeFields() {
    _dtNascimento = snapshotData['dtNascimento'] as String?;
    _cpf = snapshotData['cpf'] as String?;
    _uid = snapshotData['uid'] as String?;
    _endereco = snapshotData['endereco'] as String?;
    _cidade = snapshotData['cidade'] as String?;
    _bairro = snapshotData['bairro'] as String?;
    _email = snapshotData['email'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _empresa = snapshotData['empresa'] as String?;
    _tipo = snapshotData['tipo'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('person');

  static Stream<PersonRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PersonRecord.fromSnapshot(s));

  static Future<PersonRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PersonRecord.fromSnapshot(s));

  static PersonRecord fromSnapshot(DocumentSnapshot snapshot) => PersonRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PersonRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PersonRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PersonRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PersonRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPersonRecordData({
  String? dtNascimento,
  String? cpf,
  String? uid,
  String? endereco,
  String? cidade,
  String? bairro,
  String? email,
  DateTime? createdTime,
  String? displayName,
  String? photoUrl,
  String? phoneNumber,
  String? empresa,
  String? tipo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'dtNascimento': dtNascimento,
      'cpf': cpf,
      'uid': uid,
      'endereco': endereco,
      'cidade': cidade,
      'bairro': bairro,
      'email': email,
      'created_time': createdTime,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'empresa': empresa,
      'tipo': tipo,
    }.withoutNulls,
  );

  return firestoreData;
}

class PersonRecordDocumentEquality implements Equality<PersonRecord> {
  const PersonRecordDocumentEquality();

  @override
  bool equals(PersonRecord? e1, PersonRecord? e2) {
    return e1?.dtNascimento == e2?.dtNascimento &&
        e1?.cpf == e2?.cpf &&
        e1?.uid == e2?.uid &&
        e1?.endereco == e2?.endereco &&
        e1?.cidade == e2?.cidade &&
        e1?.bairro == e2?.bairro &&
        e1?.email == e2?.email &&
        e1?.createdTime == e2?.createdTime &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.empresa == e2?.empresa &&
        e1?.tipo == e2?.tipo;
  }

  @override
  int hash(PersonRecord? e) => const ListEquality().hash([
        e?.dtNascimento,
        e?.cpf,
        e?.uid,
        e?.endereco,
        e?.cidade,
        e?.bairro,
        e?.email,
        e?.createdTime,
        e?.displayName,
        e?.photoUrl,
        e?.phoneNumber,
        e?.empresa,
        e?.tipo
      ]);

  @override
  bool isValidKey(Object? o) => o is PersonRecord;
}
