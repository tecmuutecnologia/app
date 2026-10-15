import '/data/backend.dart';
import '/data/objectbox/index.dart';

/// Dados do cabeçalho do receituário (produtor e técnico).
class CabecalhoReceituario {
  const CabecalhoReceituario({
    this.nomeProdutor,
    this.enderecoProdutor,
    this.nomeTecnico,
    this.telefoneTecnico,
    this.emailTecnico,
    this.empresaTecnico,
  });

  final String? nomeProdutor;
  final String? enderecoProdutor;
  final String? nomeTecnico;
  final String? telefoneTecnico;
  final String? emailTecnico;
  final String? empresaTecnico;
}

/// Lê o cabeçalho do ObjectBox (offline-first).
///
/// Antes eram três leituras do Firestore em sequência (propriedade, técnico,
/// person) a cada "Gerar PDF": com rede fraca era a maior parte da espera, e
/// offline o PDF não saía. O Firestore fica só de reserva para o que não
/// estiver no aparelho.
Future<CabecalhoReceituario> carregarCabecalhoReceituario({
  required DocumentReference uidPropriedade,
  required DocumentReference uidTecnico,
}) async {
  final propriedade =
      PropriedadeRepository().getByFirestoreId(uidPropriedade.id);
  final tecnico = TecnicoRepository().getByFirestoreId(uidTecnico.id);
  final uidPerson = tecnico?.uidPerson;
  final person = (uidPerson == null || uidPerson.isEmpty)
      ? null
      : PersonRepository().getByUid(uidPerson);

  String? nomeProdutor = propriedade?.displayName;
  String? enderecoProdutor = propriedade?.endereco;
  if (propriedade == null) {
    try {
      final doc = await PropriedadesRecord.getDocumentOnce(uidPropriedade);
      nomeProdutor = doc.displayName;
      enderecoProdutor = doc.endereco;
    } catch (_) {}
  }

  if (person != null) {
    return CabecalhoReceituario(
      nomeProdutor: nomeProdutor,
      enderecoProdutor: enderecoProdutor,
      nomeTecnico: person.displayName,
      telefoneTecnico: person.phoneNumber,
      emailTecnico: person.email,
      empresaTecnico: person.empresa,
    );
  }

  PersonRecord? personRemoto;
  try {
    final uid = (uidPerson == null || uidPerson.isEmpty)
        ? (await TecnicoRecord.getDocumentOnce(uidTecnico)).uidPerson
        : uidPerson;
    personRemoto = await queryPersonRecordOnce(
      queryBuilder: (q) => q.where('uid', isEqualTo: uid),
      singleRecord: true,
    ).then((s) => s.firstOrNull);
  } catch (_) {}

  return CabecalhoReceituario(
    nomeProdutor: nomeProdutor,
    enderecoProdutor: enderecoProdutor,
    nomeTecnico: personRemoto?.displayName,
    telefoneTecnico: personRemoto?.phoneNumber,
    emailTecnico: personRemoto?.email,
    empresaTecnico: personRemoto?.empresa,
  );
}
