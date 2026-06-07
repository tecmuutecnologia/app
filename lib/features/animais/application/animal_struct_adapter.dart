import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../backend/objectbox/entities/index.dart';
import '../../../backend/objectbox/objectbox_service.dart';
import '../../../backend/objectbox/repositories/animal_repository.dart';
import '../../../backend/schema/structs/index.dart';

/// Converte uma [AnimalEntity] (ObjectBox) no [AnimaisProdutoresStruct] usado
/// pelas telas FlutterFlow legadas (ex.: `listacompleta`, que renderiza a partir
/// de `FFAppState().animaisProdutoresExistentes`).
///
/// É a ponte que permite alimentar a UI legada a partir do ObjectBox — fonte
/// única — sem reescrever as centenas de widgets acoplados ao struct.
///
/// A referência do animal (`uidAnimal`) é reconstruída sob o técnico
/// (`<parentPath>/animaisProdutores/<firestoreId>`), pois é assim que os animais
/// vivem no Firestore (ver memória do modelo de dados).
AnimaisProdutoresStruct animalEntityToStruct(AnimalEntity e) {
  return AnimaisProdutoresStruct(
    uidTecnicoPropriedade: e.uidTecnicoPropriedadePath != null
        ? FirebaseFirestore.instance.doc(e.uidTecnicoPropriedadePath!)
        : null,
    uidAnimal: (e.parentPath != null && e.firestoreId != null)
        ? FirebaseFirestore.instance
            .doc('${e.parentPath}/animaisProdutores/${e.firestoreId}')
        : null,
    // Identidade local do animal criado offline (null/'' p/ animais já
    // sincronizados, que usam a ref `uidAnimal`).
    uidAnimalOffline: e.uidAnimalOffline,
    nomeAnimal: e.nomeAnimal,
    racaAnimal: e.racaAnimal,
    pesoAnimal: e.pesoAnimal,
    dtNascimento: e.dtNascimento,
    touro: e.touro,
    vaca: e.vaca,
    status: e.status,
    grupoAnimal: e.grupoAnimal,
    dtUltimaInseminacao: e.dtUltimaInseminacao,
    dtUltimoParto: e.dtUltimoParto,
    liberaInseminacao: e.liberaInseminacao,
    dtPartoPrevisto: e.dtPartoPrevisto,
    dtSecPrevista: e.dtSecPrevista,
    dtPrePartoPrevista: e.dtPrePartoPrevista,
    dtPP: e.dtPP,
    dtDgMais: e.dtDgMais,
    dtDgMenos: e.dtDgMenos,
    dtAborto: e.dtAborto,
    dtSecagem: e.dtSecagem,
    dtUltimoPP: e.dtUltimoPP,
    nomeTouroUltimaInseminacao: e.nomeTouroUltimaInseminacao,
    totalInseminacoes: e.totalInseminacoes,
    totalPartos: e.totalPartos,
    dtPreParto: e.dtPreParto,
    motivoDescarteAnimal: e.motivoDescarteAnimal,
    dtDescarteAnimal: e.dtDescarteAnimal,
    dtUltimaAcao: e.dtUltimaAcao,
    compararDtUltimaInseminacao: e.compararDtUltimaInseminacao,
    nomeBrincoConcat: e.nomeBrincoConcat,
    idGrupoAnimal: e.idGrupoAnimal,
    dtUltimoPartoContingencia: e.dtUltimoPartoContingencia,
    idStatusAnimal: e.idStatusAnimal,
    dtInducaoLactacao: e.dtInducaoLactacao,
    dtDesmame: e.dtDesmame,
    brincoAnimal: e.brincoAnimal,
    brincoAnimalOrder: e.brincoAnimalOrder,
  );
}

/// Fonte única da lista de animais existentes para a UI legada: lê do ObjectBox
/// (via [AnimalRepository]), descarta os soft-deletados e converte para struct.
///
/// Substitui o antigo cache global `FFAppState().animaisProdutoresExistentes`.
/// As telas de lista devem chamar isto UMA vez (no `initState`, guardando num
/// campo local) para não remapear a cada rebuild; leitores pontuais podem
/// chamar direto. Retorna lista vazia se o ObjectBox ainda não inicializou.
List<AnimaisProdutoresStruct> animaisProdutoresExistentesObjectBox() {
  if (!ObjectBoxService.isInitialized) return <AnimaisProdutoresStruct>[];
  return AnimalRepository()
      .getAll()
      .where((a) => !a.isDeleted)
      .map(animalEntityToStruct)
      .toList();
}

/// Mapeia um [AnimaisProdutoresStruct] da UI legada para uma nova [AnimalEntity]
/// de animal CRIADO OFFLINE (ainda sem `firestoreId`).
///
/// [parentPath] deve ser o caminho do TÉCNICO (os animais vivem em
/// `tecnico/<id>/animaisProdutores`). [uidAnimalOffline] é a identidade local:
/// reaproveita a do struct se existir, senão gera uma.
AnimalEntity structToAnimalEntityOffline(
  AnimaisProdutoresStruct s, {
  required String parentPath,
}) {
  final uidOffline = s.uidAnimalOffline.isNotEmpty
      ? s.uidAnimalOffline
      : 'offline_${DateTime.now().microsecondsSinceEpoch}';
  return AnimalEntity(
    parentPath: parentPath,
    uidTecnicoPropriedadePath: s.uidTecnicoPropriedade?.path,
    uidAnimalOffline: uidOffline,
    nomeAnimal: s.nomeAnimal,
    racaAnimal: s.racaAnimal,
    pesoAnimal: s.pesoAnimal,
    dtNascimento: s.dtNascimento,
    touro: s.touro,
    vaca: s.vaca,
    status: s.status,
    grupoAnimal: s.grupoAnimal,
    dtUltimaInseminacao: s.dtUltimaInseminacao,
    dtUltimoParto: s.dtUltimoParto,
    liberaInseminacao: s.liberaInseminacao,
    dtPartoPrevisto: s.dtPartoPrevisto,
    dtSecPrevista: s.dtSecPrevista,
    dtPrePartoPrevista: s.dtPrePartoPrevista,
    dtPP: s.dtPP,
    dtDgMais: s.dtDgMais,
    dtDgMenos: s.dtDgMenos,
    dtAborto: s.dtAborto,
    dtSecagem: s.dtSecagem,
    dtUltimoPP: s.dtUltimoPP,
    nomeTouroUltimaInseminacao: s.nomeTouroUltimaInseminacao,
    totalInseminacoes: s.totalInseminacoes,
    totalPartos: s.totalPartos,
    dtPreParto: s.dtPreParto,
    motivoDescarteAnimal: s.motivoDescarteAnimal,
    dtDescarteAnimal: s.dtDescarteAnimal,
    dtUltimaAcao: s.dtUltimaAcao,
    compararDtUltimaInseminacao: s.compararDtUltimaInseminacao,
    nomeBrincoConcat: s.nomeBrincoConcat,
    idGrupoAnimal: s.idGrupoAnimal,
    dtUltimoPartoContingencia: s.dtUltimoPartoContingencia,
    idStatusAnimal: s.idStatusAnimal,
    dtInducaoLactacao: s.dtInducaoLactacao,
    dtDesmame: s.dtDesmame,
    brincoAnimal: s.brincoAnimal,
    brincoAnimalOrder: s.brincoAnimalOrder,
  );
}

/// Cria um animal OFFLINE no ObjectBox (fonte única) e enfileira o push para o
/// Firestore (`needsSync`). Substitui (drop-in 1-arg)
/// `FFAppState().addToAnimaisProdutoresOffline(struct)`.
///
/// O animal vive sob o técnico (`tecnico/<id>/animaisProdutores`). A referência
/// da propriedade do struct é `tecnico/<id>/propriedades/<pid>` (propriedades é
/// subcoleção de tecnico), logo o caminho do técnico é `parent.parent` dela.
/// Retorna o `uidAnimalOffline` gerado/usado, para identidade local nas ações.
Future<String> criarAnimalOffline(AnimaisProdutoresStruct s) async {
  final tecnicoPath = s.uidTecnicoPropriedade?.parent.parent?.path ?? '';
  final entity = structToAnimalEntityOffline(s, parentPath: tecnicoPath);
  await AnimalRepository().add(entity);
  return entity.uidAnimalOffline!;
}
