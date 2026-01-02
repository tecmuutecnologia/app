// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class EmpresasStruct extends FFFirebaseStruct {
  EmpresasStruct({
    String? nome,
    String? razaoSocial,
    String? cnpj,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _razaoSocial = razaoSocial,
        _cnpj = cnpj,
        super(firestoreUtilData);

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "razaoSocial" field.
  String? _razaoSocial;
  String get razaoSocial => _razaoSocial ?? '';
  set razaoSocial(String? val) => _razaoSocial = val;

  bool hasRazaoSocial() => _razaoSocial != null;

  // "cnpj" field.
  String? _cnpj;
  String get cnpj => _cnpj ?? '';
  set cnpj(String? val) => _cnpj = val;

  bool hasCnpj() => _cnpj != null;

  static EmpresasStruct fromMap(Map<String, dynamic> data) => EmpresasStruct(
        nome: data['nome'] as String?,
        razaoSocial: data['razaoSocial'] as String?,
        cnpj: data['cnpj'] as String?,
      );

  static EmpresasStruct? maybeFromMap(dynamic data) =>
      data is Map ? EmpresasStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'razaoSocial': _razaoSocial,
        'cnpj': _cnpj,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'razaoSocial': serializeParam(
          _razaoSocial,
          ParamType.String,
        ),
        'cnpj': serializeParam(
          _cnpj,
          ParamType.String,
        ),
      }.withoutNulls;

  static EmpresasStruct fromSerializableMap(Map<String, dynamic> data) =>
      EmpresasStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        razaoSocial: deserializeParam(
          data['razaoSocial'],
          ParamType.String,
          false,
        ),
        cnpj: deserializeParam(
          data['cnpj'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EmpresasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EmpresasStruct &&
        nome == other.nome &&
        razaoSocial == other.razaoSocial &&
        cnpj == other.cnpj;
  }

  @override
  int get hashCode => const ListEquality().hash([nome, razaoSocial, cnpj]);
}

EmpresasStruct createEmpresasStruct({
  String? nome,
  String? razaoSocial,
  String? cnpj,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EmpresasStruct(
      nome: nome,
      razaoSocial: razaoSocial,
      cnpj: cnpj,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EmpresasStruct? updateEmpresasStruct(
  EmpresasStruct? empresas, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    empresas
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEmpresasStructData(
  Map<String, dynamic> firestoreData,
  EmpresasStruct? empresas,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (empresas == null) {
    return;
  }
  if (empresas.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && empresas.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final empresasData = getEmpresasFirestoreData(empresas, forFieldValue);
  final nestedData = empresasData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = empresas.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEmpresasFirestoreData(
  EmpresasStruct? empresas, [
  bool forFieldValue = false,
]) {
  if (empresas == null) {
    return {};
  }
  final firestoreData = mapToFirestore(empresas.toMap());

  // Add any Firestore field values
  empresas.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEmpresasListFirestoreData(
  List<EmpresasStruct>? empresass,
) =>
    empresass?.map((e) => getEmpresasFirestoreData(e, true)).toList() ?? [];
