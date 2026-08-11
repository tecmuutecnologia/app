import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/objectbox/entities/index.dart';
import '../../../data/objectbox/objectbox_service.dart';
import '../../../data/objectbox/repositories/animal_repository.dart';
import '../../../data/schema/structs/index.dart';
import '../../../domain/animais/ordenacao_animal.dart';

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

/// Migração única (legado → ObjectBox): move para o ObjectBox os animais que
/// ainda estiverem no array persistido do mecanismo antigo
/// (`FFAppState().animaisProdutoresOffline`), via [criarAnimalOffline].
///
/// Substitui o antigo `animaisProdutoresOffline = []` do fluxo de login, que
/// DESCARTAVA esses animais silenciosamente (perda de dados de campo em quem
/// criou animais offline antes desta migração). Idempotente: pula os que já
/// existem no ObjectBox por `uidAnimalOffline`. Retorna quantos migrou.
///
/// O caller deve limpar o array APÓS o retorno normal (se lançar no meio, os já
/// criados são pulados na próxima execução graças à idempotência).
Future<int> migrarAnimaisOfflineLegado(
    List<AnimaisProdutoresStruct> legado) async {
  if (legado.isEmpty) return 0;
  final repo = AnimalRepository();
  var migrados = 0;
  for (final s in List<AnimaisProdutoresStruct>.from(legado)) {
    final uid = s.uidAnimalOffline;
    if (uid.isNotEmpty && repo.getByUidAnimalOffline(uid) != null) continue;
    await criarAnimalOffline(s);
    migrados++;
  }
  return migrados;
}

/// Chave de SharedPreferences onde o mecanismo FlutterFlow antigo persistia os
/// animais criados offline (`FFAppState().animaisProdutoresOffline`).
const String kPrefsAnimaisOfflineLegado = 'ff_animaisProdutoresOffline';

/// Migração única, AUTÔNOMA do FFAppState (lê direto das prefs): resgata para o
/// ObjectBox quaisquer animais que tenham ficado no array persistido do
/// mecanismo antigo e **remove a chave** ao final. Substitui a drenagem que
/// dependia do campo `FFAppState().animaisProdutoresOffline` (removido).
///
/// Idempotente: se a chave não existe (instalações novas / já drenadas) é no-op;
/// [migrarAnimaisOfflineLegado] pula os que já existem por `uidAnimalOffline`.
/// Só remove a chave APÓS o sucesso da migração (em erro, tenta de novo depois).
Future<int> migrarAnimaisOfflineLegadoDePrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(kPrefsAnimaisOfflineLegado);
  if (raw == null || raw.isEmpty) return 0;

  final legado = <AnimaisProdutoresStruct>[];
  for (final x in raw) {
    try {
      legado.add(AnimaisProdutoresStruct.fromSerializableMap(jsonDecode(x)));
    } catch (_) {
      // Item corrompido: ignora (não trava o resgate dos demais).
    }
  }

  final migrados = await migrarAnimaisOfflineLegado(legado);
  await prefs.remove(kPrefsAnimaisOfflineLegado);
  return migrados;
}

/// Comparador de [AnimaisProdutoresStruct] pela regra única do domínio.
///
/// Existe aqui, e não em `domain/`, porque o struct é view-model do FlutterFlow
/// — o domínio não deve conhecê-lo. Esta é só a ponte de campos.
int compararStructs(AnimaisProdutoresStruct a, AnimaisProdutoresStruct b) =>
    compararAnimais(
      brincoA: a.brincoAnimal,
      nomeA: a.nomeAnimal,
      brincoB: b.brincoAnimal,
      nomeB: b.nomeAnimal,
    );
