// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PersonStruct extends FFFirebaseStruct {
  PersonStruct({
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
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _dtNascimento = dtNascimento,
        _cpf = cpf,
        _uid = uid,
        _endereco = endereco,
        _cidade = cidade,
        _bairro = bairro,
        _email = email,
        _createdTime = createdTime,
        _displayName = displayName,
        _photoUrl = photoUrl,
        _phoneNumber = phoneNumber,
        _empresa = empresa,
        super(firestoreUtilData);

  // "dtNascimento" field.
  String? _dtNascimento;
  String get dtNascimento => _dtNascimento ?? '';
  set dtNascimento(String? val) => _dtNascimento = val;

  bool hasDtNascimento() => _dtNascimento != null;

  // "cpf" field.
  String? _cpf;
  String get cpf => _cpf ?? '';
  set cpf(String? val) => _cpf = val;

  bool hasCpf() => _cpf != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  set uid(String? val) => _uid = val;

  bool hasUid() => _uid != null;

  // "endereco" field.
  String? _endereco;
  String get endereco => _endereco ?? '';
  set endereco(String? val) => _endereco = val;

  bool hasEndereco() => _endereco != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  set cidade(String? val) => _cidade = val;

  bool hasCidade() => _cidade != null;

  // "bairro" field.
  String? _bairro;
  String get bairro => _bairro ?? '';
  set bairro(String? val) => _bairro = val;

  bool hasBairro() => _bairro != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  set createdTime(DateTime? val) => _createdTime = val;

  bool hasCreatedTime() => _createdTime != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  set displayName(String? val) => _displayName = val;

  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  set photoUrl(String? val) => _photoUrl = val;

  bool hasPhotoUrl() => _photoUrl != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  set phoneNumber(String? val) => _phoneNumber = val;

  bool hasPhoneNumber() => _phoneNumber != null;

  // "empresa" field.
  String? _empresa;
  String get empresa => _empresa ?? '';
  set empresa(String? val) => _empresa = val;

  bool hasEmpresa() => _empresa != null;

  static PersonStruct fromMap(Map<String, dynamic> data) => PersonStruct(
        dtNascimento: data['dtNascimento'] as String?,
        cpf: data['cpf'] as String?,
        uid: data['uid'] as String?,
        endereco: data['endereco'] as String?,
        cidade: data['cidade'] as String?,
        bairro: data['bairro'] as String?,
        email: data['email'] as String?,
        createdTime: data['created_time'] as DateTime?,
        displayName: data['display_name'] as String?,
        photoUrl: data['photo_url'] as String?,
        phoneNumber: data['phone_number'] as String?,
        empresa: data['empresa'] as String?,
      );

  static PersonStruct? maybeFromMap(dynamic data) =>
      data is Map ? PersonStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'dtNascimento': _dtNascimento,
        'cpf': _cpf,
        'uid': _uid,
        'endereco': _endereco,
        'cidade': _cidade,
        'bairro': _bairro,
        'email': _email,
        'created_time': _createdTime,
        'display_name': _displayName,
        'photo_url': _photoUrl,
        'phone_number': _phoneNumber,
        'empresa': _empresa,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'dtNascimento': serializeParam(
          _dtNascimento,
          ParamType.String,
        ),
        'cpf': serializeParam(
          _cpf,
          ParamType.String,
        ),
        'uid': serializeParam(
          _uid,
          ParamType.String,
        ),
        'endereco': serializeParam(
          _endereco,
          ParamType.String,
        ),
        'cidade': serializeParam(
          _cidade,
          ParamType.String,
        ),
        'bairro': serializeParam(
          _bairro,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'created_time': serializeParam(
          _createdTime,
          ParamType.DateTime,
        ),
        'display_name': serializeParam(
          _displayName,
          ParamType.String,
        ),
        'photo_url': serializeParam(
          _photoUrl,
          ParamType.String,
        ),
        'phone_number': serializeParam(
          _phoneNumber,
          ParamType.String,
        ),
        'empresa': serializeParam(
          _empresa,
          ParamType.String,
        ),
      }.withoutNulls;

  static PersonStruct fromSerializableMap(Map<String, dynamic> data) =>
      PersonStruct(
        dtNascimento: deserializeParam(
          data['dtNascimento'],
          ParamType.String,
          false,
        ),
        cpf: deserializeParam(
          data['cpf'],
          ParamType.String,
          false,
        ),
        uid: deserializeParam(
          data['uid'],
          ParamType.String,
          false,
        ),
        endereco: deserializeParam(
          data['endereco'],
          ParamType.String,
          false,
        ),
        cidade: deserializeParam(
          data['cidade'],
          ParamType.String,
          false,
        ),
        bairro: deserializeParam(
          data['bairro'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        createdTime: deserializeParam(
          data['created_time'],
          ParamType.DateTime,
          false,
        ),
        displayName: deserializeParam(
          data['display_name'],
          ParamType.String,
          false,
        ),
        photoUrl: deserializeParam(
          data['photo_url'],
          ParamType.String,
          false,
        ),
        phoneNumber: deserializeParam(
          data['phone_number'],
          ParamType.String,
          false,
        ),
        empresa: deserializeParam(
          data['empresa'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PersonStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PersonStruct &&
        dtNascimento == other.dtNascimento &&
        cpf == other.cpf &&
        uid == other.uid &&
        endereco == other.endereco &&
        cidade == other.cidade &&
        bairro == other.bairro &&
        email == other.email &&
        createdTime == other.createdTime &&
        displayName == other.displayName &&
        photoUrl == other.photoUrl &&
        phoneNumber == other.phoneNumber &&
        empresa == other.empresa;
  }

  @override
  int get hashCode => const ListEquality().hash([
        dtNascimento,
        cpf,
        uid,
        endereco,
        cidade,
        bairro,
        email,
        createdTime,
        displayName,
        photoUrl,
        phoneNumber,
        empresa
      ]);
}

PersonStruct createPersonStruct({
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
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PersonStruct(
      dtNascimento: dtNascimento,
      cpf: cpf,
      uid: uid,
      endereco: endereco,
      cidade: cidade,
      bairro: bairro,
      email: email,
      createdTime: createdTime,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      empresa: empresa,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PersonStruct? updatePersonStruct(
  PersonStruct? person, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    person
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPersonStructData(
  Map<String, dynamic> firestoreData,
  PersonStruct? person,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (person == null) {
    return;
  }
  if (person.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && person.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final personData = getPersonFirestoreData(person, forFieldValue);
  final nestedData = personData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = person.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPersonFirestoreData(
  PersonStruct? person, [
  bool forFieldValue = false,
]) {
  if (person == null) {
    return {};
  }
  final firestoreData = mapToFirestore(person.toMap());

  // Add any Firestore field values
  person.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPersonListFirestoreData(
  List<PersonStruct>? persons,
) =>
    persons?.map((e) => getPersonFirestoreData(e, true)).toList() ?? [];
