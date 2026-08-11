import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/prontuario/application/acao_record_adapter.dart';

/// Valida o mapa que alimenta o `AcoesRecord`.
///
/// É esta parte que quebra em silêncio: `AcoesRecord._initializeFields` lê o
/// mapa por NOME de chave, então uma chave errada não dá erro de compilação —
/// o campo simplesmente chega vazio na tela.
///
/// A montagem do `AcoesRecord` em si precisa de uma `DocumentReference`, que
/// exige `FirebaseFirestore.instance`; essa parte é exercitada em device.
void main() {
  test('mapeia os campos de dados da ação com as chaves que o record lê', () {
    final e = AcaoEntity(
      nomeAnimal: 'Mimosa',
      acao: 'Inseminada',
      obsVisita: 'sem intercorrências',
      touroInseminacao: 'Touro X',
      dataVisita: '25/05/2026',
      dataPartoPrevisto: '01/03/2027',
      dataSecPrevista: '10/01/2027',
      dataPrePartoPrevista: '20/02/2027',
      dtPP: '01/01/2027',
      dtDgMais: '10/06/2026',
      dtDgMenos: '11/06/2026',
      dtAborto: '12/06/2026',
      dataDaAcao: DateTime.utc(2026, 5, 25),
    );

    final m = acaoEntityToSnapshotData(e);

    expect(m['nomeAnimal'], 'Mimosa');
    expect(m['acao'], 'Inseminada');
    expect(m['obsVisita'], 'sem intercorrências');
    expect(m['touroInseminacao'], 'Touro X');
    expect(m['dataVisita'], '25/05/2026');
    expect(m['dataPartoPrevisto'], '01/03/2027');
    expect(m['dataSecPrevista'], '10/01/2027');
    expect(m['dataPrePartoPrevista'], '20/02/2027');
    expect(m['dtPP'], '01/01/2027');
    expect(m['dtDgMais'], '10/06/2026');
    expect(m['dtDgMenos'], '11/06/2026');
    expect(m['dtAborto'], '12/06/2026');
    expect(m['dataDaAcao'], DateTime.utc(2026, 5, 25));
  });

  test('entidade vazia produz mapa sem lançar', () {
    final m = acaoEntityToSnapshotData(AcaoEntity());

    expect(m['nomeAnimal'], isNull);
    expect(m['acao'], isNull);
    expect(m['dataDaAcao'], isNull);
  });

  test('cobre todas as chaves que AcoesRecord lê do snapshot', () {
    // Espelha `_initializeFields` de acoes_record.dart. Se um campo novo entrar
    // lá e não aqui, a tela o mostraria vazio sem nenhum aviso.
    const esperadas = {
      'uidAnimalAnimaisProdutores',
      'nomeAnimal',
      'acao',
      'obsVisita',
      'touroInseminacao',
      'dataVisita',
      'dataPartoPrevisto',
      'dataSecPrevista',
      'dataPrePartoPrevista',
      'dataDaAcao',
      'dtPP',
      'dtDgMais',
      'dtDgMenos',
      'dtAborto',
      'uidPropriedade',
    };

    expect(acaoEntityToSnapshotData(AcaoEntity()).keys.toSet(), esperadas);
  });
}
