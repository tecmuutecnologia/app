import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../backend/objectbox/entities/index.dart';
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
    uidAnimalOffline: e.firestoreId,
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
