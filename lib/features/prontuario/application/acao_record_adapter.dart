import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/objectbox/entities/index.dart';
import '../../../data/schema/acoes_record.dart';

/// Converte uma [AcaoEntity] (ObjectBox) no [AcoesRecord] que os cards do
/// prontuário já consomem.
///
/// Existe para que a tela leia do ObjectBox sem reescrever os cinco
/// construtores de card. Antes, cada seção do prontuário abria um
/// `StreamBuilder` sobre `.snapshots()` do Firestore — cinco listeners de rede
/// por animal aberto, mesmo com os dados já baixados localmente.
///
/// É a mesma ponte que `animalEntityToStruct` faz para as telas de lista.

/// O mapa que alimenta o record.
///
/// Separado do [acaoEntityToRecord] porque é a parte que quebra em silêncio:
/// `AcoesRecord._initializeFields` lê por NOME de chave, então um nome errado
/// não dá erro de compilação — o campo só chega vazio na tela. Assim ele fica
/// testável sem precisar do Firebase.
Map<String, dynamic> acaoEntityToSnapshotData(AcaoEntity e) => {
      'uidAnimalAnimaisProdutores':
          _refOuNulo(e.uidAnimalAnimaisProdutoresPath),
      'nomeAnimal': e.nomeAnimal,
      'acao': e.acao,
      'obsVisita': e.obsVisita,
      'touroInseminacao': e.touroInseminacao,
      'dataVisita': e.dataVisita,
      'dataPartoPrevisto': e.dataPartoPrevisto,
      'dataSecPrevista': e.dataSecPrevista,
      'dataPrePartoPrevista': e.dataPrePartoPrevista,
      'dataDaAcao': e.dataDaAcao,
      'dtPP': e.dtPP,
      'dtDgMais': e.dtDgMais,
      'dtDgMenos': e.dtDgMenos,
      'dtAborto': e.dtAborto,
      'uidPropriedade': _refOuNulo(e.uidPropriedadePath),
    };

/// Converte a entidade no record consumido pelos cards.
///
/// A ação criada offline ainda não tem `firestoreId`; nesse caso a referência
/// aponta para um documento que ainda não existe no servidor. Isso é
/// suficiente: os cards usam a referência para navegar e para identidade, não
/// para ler dados — os dados vêm do mapa acima.
AcoesRecord acaoEntityToRecord(AcaoEntity e) => AcoesRecord.getDocumentFromData(
      acaoEntityToSnapshotData(e),
      _referenciaDa(e),
    );

DocumentReference? _refOuNulo(String? path) => (path == null || path.isEmpty)
    ? null
    : FirebaseFirestore.instance.doc(path);

DocumentReference _referenciaDa(AcaoEntity e) {
  final colecao = (e.parentPath == null || e.parentPath!.isEmpty)
      ? FirebaseFirestore.instance.collection('acoes')
      : FirebaseFirestore.instance.doc(e.parentPath!).collection('acoes');
  final id = e.firestoreId;
  return (id == null || id.isEmpty) ? colecao.doc() : colecao.doc(id);
}
