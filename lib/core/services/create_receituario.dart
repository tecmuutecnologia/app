// Automatic FlutterFlow imports
import '/domain/animais/ordenacao_animal.dart';
import '/domain/animais/diagnostico_gestacao.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/data/objectbox/assinaturas_locais.dart';
import '/core/ui/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../util/data_flexivel.dart';

Future<void> createReceituario(
  DocumentReference uidResumoVisita,
  String? nomeProdutor,
  String? enderecoProdutor,
  String? nomeTecnico,
  String? telefoneTecnico,
  String dtVisitaFormatado,
  String? emailTecnico,
  String? nomeEmpresaTecnico, // Campo opcional
) async {
  final cronometro = Stopwatch()..start();
  try {
    // Logo empacotado como asset. Antes vinha por HTTP e, se a busca
    // falhasse (offline), lançava exceção e abortava o receituário inteiro.
    final Uint8List logoImage =
        (await rootBundle.load('assets/images/logo-2.png'))
            .buffer
            .asUint8List();

    // Cria um documento PDF
    final pdf = pw.Document();

    // Resumo da visita do ObjectBox (fonte única offline-first).
    final resumoEntity =
        ResumoVisitaRepository().getByFirestoreId(uidResumoVisita.id);
    if (resumoEntity == null) {
      throw Exception('Resumo da visita não encontrado');
    }
    final resumoVisitaData = <String, dynamic>{
      'assinaturaProdutor': resumoEntity.assinaturaProdutor,
      'assinaturaTecnico': resumoEntity.assinaturaTecnico,
      'dtVisita': resumoEntity.dtVisita,
      'uidPropriedade': resumoEntity.uidPropriedadePath == null
          ? null
          : FirebaseFirestore.instance.doc(resumoEntity.uidPropriedadePath!),
      'uidTecnico': resumoEntity.uidTecnicoPath == null
          ? null
          : FirebaseFirestore.instance.doc(resumoEntity.uidTecnicoPath!),
    };
    final resumoPath = 'resumo_da_visita/${uidResumoVisita.id}';

    bool hasValidBrinco(dynamic brinco) {
      if (brinco == null) return false;

      final brincoStr = brinco.toString().trim();
      if (brincoStr.isEmpty) return false;

      if (brincoStr == '-1' ||
          brincoStr == '0' ||
          brincoStr == '99999' ||
          brincoStr == '999999') {
        return false;
      }

      final brincoInt = int.tryParse(brincoStr);
      if (brincoInt == null) return false;

      return brincoInt > 0 && brincoInt != 99999 && brincoInt != 999999;
    }

    // Busca recomendações relacionadas ao resumo da visita
    // Recomendações do ObjectBox, ligadas pelo CAMPO uidResumoDaVisita
    // (elas passaram a ser subcoleção da propriedade, não do resumo).
    final sortedRecomendacoes = RecomendacaoRepository()
        .getDaVisita(resumoPath)
        .map((e) => <String, dynamic>{
              'tituloRecomendacao': e.tituloRecomendacao,
              'descricaoRecomendacao': e.descricaoRecomendacao,
            })
        .toList();
    sortedRecomendacoes.sort((a, b) {
      String tituloA = a['tituloRecomendacao'] ?? '';
      String tituloB = b['tituloRecomendacao'] ?? '';
      if (tituloA == 'Secagem' || tituloA == 'Pré Parto') {
        return 1;
      }
      if (tituloB == 'Secagem' || tituloB == 'Pré Parto') {
        return -1;
      }
      return tituloA.compareTo(tituloB);
    });

    // Constrói a lista de recomendações e tratamentos
    final List<pw.Widget> recomendacoesWidgets = [];
    final List<pw.Widget> diagnosticoWidgets = [];

    for (final recomendacaoData in sortedRecomendacoes) {
      // Busca tratamentos relacionados à recomendação atual dentro de resumo_da_visita
      final tratamentosDoTipo = TratamentoRepository()
          .getDaVisita(resumoPath,
              tipoAcao: recomendacaoData['tituloRecomendacao'] as String?)
          .map((e) => <String, dynamic>{
                'nomeAnimal': e.nomeAnimal,
                'brincoAnimal': e.brincoAnimal,
                // O sort abaixo lê esta chave, que antes não era preenchida:
                // todo brinco virava null, a ordem caía só no nome e, como os
                // animais costumam não ter nome, a lista saía embaralhada.
                'brincoAnimalOrder':
                    numeroParaOrdenar(e.brincoAnimal, e.nomeAnimal),
                'grupoAnimal': e.grupoAnimal,
                'observacaoAcao': _observacaoDoTratamento(e),
              })
          .toList();

      // Ordena os tratamentos
      final sortedTratamentos = tratamentosDoTipo;

      String tipoAcaoAtual = recomendacaoData['tituloRecomendacao'] ?? '';

      if (tipoAcaoAtual == 'Secagem' || tipoAcaoAtual == 'Pré Parto') {
        // Ordena por data (observacaoAcao contém a data no formato dd/MM/yyyy), se não conseguir, ordena por nomeAnimal
        sortedTratamentos.sort((a, b) {
          String dataA = a['observacaoAcao'] ?? '';
          String dataB = b['observacaoAcao'] ?? '';
          DateTime? dateA;
          DateTime? dateB;
          try {
            List<String> partesA = dataA.split('/');
            if (partesA.length == 3) {
              dateA = DateTime(int.parse(partesA[2]), int.parse(partesA[1]),
                  int.parse(partesA[0]));
            }
          } catch (_) {}
          try {
            List<String> partesB = dataB.split('/');
            if (partesB.length == 3) {
              dateB = DateTime(int.parse(partesB[2]), int.parse(partesB[1]),
                  int.parse(partesB[0]));
            }
          } catch (_) {}
          if (dateA != null && dateB != null) {
            return dateA.compareTo(dateB);
          } else if (dateA != null) {
            return -1;
          } else if (dateB != null) {
            return 1;
          } else {
            // Se não conseguir converter para data, ordena por nomeAnimal
            String nomeA = (a['nomeAnimal'] ?? '').toString().toLowerCase();
            String nomeB = (b['nomeAnimal'] ?? '').toString().toLowerCase();
            return nomeA.compareTo(nomeB);
          }
        });
      } else {
        // Regra unica do dominio: brinco -> nome.
        sortedTratamentos.sort((a, b) => compararAnimais(
              brincoA: a['brincoAnimalOrder'] as int?,
              nomeA: a['nomeAnimal']?.toString(),
              brincoB: b['brincoAnimalOrder'] as int?,
              nomeB: b['nomeAnimal']?.toString(),
            ));
      }

      // Constrói a lista de tratamentos para a recomendação atual
      final List<pw.TableRow> tratamentosRows = [];

      // Adiciona o cabeçalho da tabela de tratamentos
      String observacaoTitulo = 'Observação';
      if (recomendacaoData['tituloRecomendacao'] == 'Pré Parto') {
        observacaoTitulo = 'Pré parto prev.';
      } else if (recomendacaoData['tituloRecomendacao'] == 'Secagem') {
        observacaoTitulo = 'Data secagem';
      }

      tratamentosRows.add(
        pw.TableRow(
          repeat: true,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                color: PdfColor.fromHex('#f2f2f2'), // Cinza clarinho
                child: pw.Text(
                  'Categoria',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                color: PdfColor.fromHex('#f2f2f2'), // Cinza clarinho
                child: pw.Text(
                  'Animal',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                color: PdfColor.fromHex('#f2f2f2'), // Cinza clarinho
                child: pw.Text(
                  observacaoTitulo,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );

      for (final tratamentoData in sortedTratamentos) {
        String brincoNomeAnimal;
        if (hasValidBrinco(tratamentoData['brincoAnimal']) &&
            tratamentoData['nomeAnimal'] != null &&
            tratamentoData['nomeAnimal'].isNotEmpty) {
          brincoNomeAnimal =
              '${tratamentoData['brincoAnimal']} - ${tratamentoData['nomeAnimal']}';
        } else if (tratamentoData['nomeAnimal'] != null &&
            tratamentoData['nomeAnimal'].isNotEmpty) {
          brincoNomeAnimal = tratamentoData['nomeAnimal'];
        } else if (hasValidBrinco(tratamentoData['brincoAnimal'])) {
          brincoNomeAnimal = tratamentoData['brincoAnimal'].toString();
        } else {
          brincoNomeAnimal = 'Sem informação';
        }

        // Função para obter a cor baseada no grupoAnimal
        PdfColor getColorForGrupoAnimal(String grupoAnimal) {
          switch (grupoAnimal) {
            case 'Vacas':
              return PdfColor.fromHex('#048508');
            case 'Novilhas':
              return PdfColor.fromHex('#ff0076');
            default:
              return PdfColor.fromHex('#ee8b60');
          }
        }

        // Busca o grupoAnimal da tabela animaisProdutores
        String grupoAnimal = 'Sem informação';
        grupoAnimal = tratamentoData['grupoAnimal'] ?? 'Sem informação';

        // Obter as três primeiras letras em maiúsculas
        String grupoAnimalIniciais = grupoAnimal.toUpperCase();

        // Obter a cor de fundo para o círculo
        PdfColor circleColor = getColorForGrupoAnimal(grupoAnimal);

        tratamentosRows.add(
          pw.TableRow(
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 10,
                        height: 10,
                        decoration: pw.BoxDecoration(
                          color: circleColor,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Text(grupoAnimalIniciais),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(brincoNomeAnimal),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(tratamentoData['observacaoAcao'] as String),
                ),
              ),
            ],
          ),
        );
      }

      // Adiciona a recomendação e seus tratamentos ao PDF.
      //
      // Os widgets entram achatados, não dentro de uma pw.Column: pw.Table
      // sabe se dividir entre páginas, mas pw.Column só quebra ENTRE os filhos
      // dela. Uma tabela mais alta que a página vira um filho indivisível, a
      // paginação nunca avança e o dart_pdf lança TooManyPagesException. Como
      // filha direta do MultiPage, a tabela pagina (e repete o cabeçalho).
      recomendacoesWidgets.addAll(tabelaComTitulo(
        [
          pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              '${recomendacaoData['tituloRecomendacao']}',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 16,
                color: PdfColor.fromHex('#f75e38'),
              ),
            ),
          ),
          pw.SizedBox(height: 10),
        ],
        tratamentosRows,
      ));
      if (recomendacaoData['descricaoRecomendacao'] != null &&
          recomendacaoData['descricaoRecomendacao'].isNotEmpty) {
        recomendacoesWidgets.add(
          pw.Text(
            'Tratamento: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        );
        recomendacoesWidgets.add(
          pw.Text(
            '${recomendacaoData['descricaoRecomendacao']}',
          ),
        );
      }
      recomendacoesWidgets.add(pw.SizedBox(height: 20));
    }

    // ============================================================
    // SEÇÃO DE DIAGNÓSTICO DE GESTAÇÃO
    // ============================================================

    // Buscar a propriedade e técnico do resumo da visita
    final uidPropriedade =
        resumoVisitaData['uidPropriedade'] as DocumentReference?;
    final uidTecnico = resumoVisitaData['uidTecnico'] as DocumentReference?;
    // Vem `DateTime` do ObjectBox e `Timestamp` de documento do Firestore; o
    // cast fixo para `Timestamp` derrubava a geração inteira do receituário.
    final dtVisita = comoData(resumoVisitaData['dtVisita']);

    // Buscar todas as ações de diagnóstico de gestação do mesmo dia da visita

    if (uidPropriedade != null && uidTecnico != null && dtVisita != null) {
      // Calcular início e fim do dia da visita
      final dtVisitaDate = dtVisita;
      final dtInicioDia = DateTime(
          dtVisitaDate.year, dtVisitaDate.month, dtVisitaDate.day, 0, 0, 0);
      final dtFimDia = DateTime(
          dtVisitaDate.year, dtVisitaDate.month, dtVisitaDate.day, 23, 59, 59);

      // Buscar todas as ações do técnico no dia da visita usando dataDaAcao
      // Ações do dia da visita, do ObjectBox. Só PP/DG+/DG-/Aborto com
      // animal vinculado.
      // 'Secagem' entra por causa do DG+ de novilha gravado no legado; ver
      // tipoDiagnostico.
      final acoesDiagnosticoTemp = AcaoRepository()
          .findComAnimalNoPeriodo(dtInicioDia, dtFimDia,
              tipos: tiposConsultaDiagnostico)
          .map((e) => <String, dynamic>{
                'acao': tipoDiagnostico(acao: e.acao, dtDgMais: e.dtDgMais),
                'uidAnimalAnimaisProdutoresPath':
                    e.uidAnimalAnimaisProdutoresPath,
                'dataDaAcao': e.dataDaAcao,
              })
          .where((e) => e['acao'] != null)
          .toList();

      // Filtrar apenas animais que pertencem à propriedade atual
      // Mantém só as ações de animais DESTA propriedade.
      final acoesDiagnostico = acoesDiagnosticoTemp.where((acaoData) {
        final caminho = acaoData['uidAnimalAnimaisProdutoresPath'] as String?;
        if (caminho == null) return false;
        final animal =
            AnimalRepository().getByFirestoreId(caminho.split('/').last);
        return animal != null &&
            animal.uidTecnicoPropriedadePath == uidPropriedade.path;
      }).toList();

      if (acoesDiagnostico.isNotEmpty) {
        // Separar em duas listas
        final acoesPPDGMais = acoesDiagnostico.where((data) {
          final acao = data['acao'] as String? ?? '';
          return acao == 'PP' || acao == 'DG+';
        }).toList();

        final acoesDGMenos = acoesDiagnostico.where((data) {
          final acao = data['acao'] as String? ?? '';
          return acao == 'DG-';
        }).toList();

        final acoesAbortos = acoesDiagnostico.where((data) {
          final acao = data['acao'] as String? ?? '';
          return acao == 'Aborto';
        }).toList();

        // Função auxiliar para buscar dados do animal
        Map<String, dynamic>? getAnimalData(String? animalPath) {
          if (animalPath == null) return null;
          final animal =
              AnimalRepository().getByFirestoreId(animalPath.split('/').last);
          return animal == null ? null : animal.toFirestore();
        }

        // Função para buscar a última data de inseminação do animal (do próprio documento do animal)
        String getUltimaInseminacaoFromAnimal(
            Map<String, dynamic>? animalData) {
          if (animalData == null) return '';
          return animalData['dtUltimaInseminacao'] as String? ?? '';
        }

        final inseminacoes = AcaoRepository().datasInseminacaoPorAnimal(
            acoesDGMenos.map(
                (a) => a['uidAnimalAnimaisProdutoresPath'] as String));

        // Função para construir linhas da tabela de diagnóstico
        Future<List<pw.TableRow>> buildDiagnosticoRows(
            List<Map<String, dynamic>> acoes) async {
          final List<Map<String, dynamic>> animaisData = [];

          for (final acaoData in acoes) {
            final animalData = getAnimalData(
                acaoData['uidAnimalAnimaisProdutoresPath'] as String?);
            // O DG- zera dtUltimaInseminacao do animal: para as vazias, a
            // IA diagnosticada vem do histórico de ações 'Inseminada'.
            final ultimaInseminacao = acaoData['acao'] == 'DG-'
                ? inseminacaoDiagnosticada(
                    inseminacoes[acaoData['uidAnimalAnimaisProdutoresPath']] ??
                        const [],
                    ate: acaoData['dataDaAcao'] as DateTime? ?? dtVisitaDate)
                : getUltimaInseminacaoFromAnimal(animalData);

            if (animalData != null) {
              animaisData.add({
                'nomeAnimal': animalData['nomeAnimal'] ?? '',
                'brincoAnimal': animalData['brincoAnimal'],
                'grupoAnimal': animalData['grupoAnimal'] ?? '',
                'dtUltimaInseminacao': ultimaInseminacao,
                'acao': acaoData['acao'] ?? '',
              });
            }
          }

          // Ordenar por brinco numérico e depois por nome
          animaisData.sort((a, b) {
            final brincoA = a['brincoAnimal'];
            final brincoB = b['brincoAnimal'];

            final numA = numeroParaOrdenar(brincoA, a['nomeAnimal']);
            final numB = numeroParaOrdenar(brincoB, b['nomeAnimal']);

            if (numA != null && numB != null) {
              return numA.compareTo(numB);
            }
            if (numA != null) return -1;
            if (numB != null) return 1;

            String nomeA = (a['nomeAnimal'] ?? '').toString().toLowerCase();
            String nomeB = (b['nomeAnimal'] ?? '').toString().toLowerCase();
            return nomeA.compareTo(nomeB);
          });

          final List<pw.TableRow> rows = [];

          for (final animal in animaisData) {
            String displayName;
            final nomeAnimal = animal['nomeAnimal'] as String;
            final brincoAnimal = animal['brincoAnimal'];

            if (nomeAnimal.isNotEmpty && hasValidBrinco(brincoAnimal)) {
              displayName = '$brincoAnimal - $nomeAnimal';
            } else if (hasValidBrinco(brincoAnimal)) {
              displayName = brincoAnimal.toString();
            } else {
              displayName = nomeAnimal;
            }

            // Obter cor do grupo animal
            PdfColor circleColor;
            String grupoAnimal = animal['grupoAnimal'] as String;
            if (grupoAnimal == 'Vacas') {
              circleColor = PdfColor.fromHex('#048508');
            } else if (grupoAnimal == 'Novilhas') {
              circleColor = PdfColor.fromHex('#ff0076');
            } else {
              circleColor = PdfColor.fromHex('#ee8b60');
            }

            rows.add(
              pw.TableRow(
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            width: 10,
                            height: 10,
                            decoration: pw.BoxDecoration(
                              color: circleColor,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(grupoAnimal.toUpperCase()),
                        ],
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(displayName),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        animal['acao'] as String,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: const {'DG-', 'Aborto'}
                                  .contains(animal['acao'] as String)
                              ? PdfColor.fromHex('#ee0000')
                              : PdfColor.fromHex('#048508'),
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(animal['dtUltimaInseminacao'] as String),
                    ),
                  ),
                ],
              ),
            );
          }

          return rows;
        }

        // Construir widget de diagnóstico de gestação

        // Título da seção: não entra sozinho, vai junto da primeira
        // subseção para não ficar órfão no pé da página.
        final tituloDiagnostico = <pw.Widget>[
          pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              'Diagnóstico de Gestação',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 16,
                color: PdfColor.fromHex('#f75e38'),
              ),
            ),
          ),
          pw.SizedBox(height: 10),
        ];
        List<pw.Widget> comTituloDaSecao(List<pw.Widget> subtitulo) {
          final titulos = [...tituloDiagnostico, ...subtitulo];
          tituloDiagnostico.clear();
          return titulos;
        }

        // Cabeçalho da tabela
        pw.TableRow buildDiagnosticoHeader(
            {String colunaData = 'Últ. Insem.'}) {
          return pw.TableRow(
            repeat: true,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  color: PdfColor.fromHex('#f2f2f2'),
                  child: pw.Text(
                    'Categoria',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  color: PdfColor.fromHex('#f2f2f2'),
                  child: pw.Text(
                    'Animal',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  color: PdfColor.fromHex('#f2f2f2'),
                  child: pw.Text(
                    'Resultado',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  color: PdfColor.fromHex('#f2f2f2'),
                  child: pw.Text(
                    colunaData,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        }

        // Seção de Prenhes (PP/DG+)
        if (acoesPPDGMais.isNotEmpty) {
          final rowsPPDGMais = await buildDiagnosticoRows(acoesPPDGMais);
          diagnosticoWidgets.addAll(tabelaComTitulo(
            comTituloDaSecao([
              pw.Text(
                'Prenhes (PP/DG+)',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#048508'),
                ),
              ),
              pw.SizedBox(height: 5),
            ]),
            [buildDiagnosticoHeader(), ...rowsPPDGMais],
          ));
          diagnosticoWidgets.add(pw.SizedBox(height: 10));
        }

        // Seção de Vazias (DG-)
        if (acoesDGMenos.isNotEmpty) {
          final rowsDGMenos = await buildDiagnosticoRows(acoesDGMenos);
          diagnosticoWidgets.addAll(tabelaComTitulo(
            comTituloDaSecao([
              pw.Text(
                'Vazias (DG-)',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#ee0000'),
                ),
              ),
              pw.SizedBox(height: 5),
            ]),
            [
              buildDiagnosticoHeader(),
              ...rowsDGMenos,
            ],
          ));
          diagnosticoWidgets.add(pw.SizedBox(height: 10));
        }

        // Seção de Abortos
        if (acoesAbortos.isNotEmpty) {
          final List<Map<String, dynamic>> acoesAbortosVacas = [];

          for (final acaoData in acoesAbortos) {
            final animalData = getAnimalData(
                acaoData['uidAnimalAnimaisProdutoresPath'] as String?);

            if (animalData != null && animalData['grupoAnimal'] == 'Vacas') {
              acoesAbortosVacas.add(acaoData);
            }
          }

          if (acoesAbortosVacas.isNotEmpty) {
            final rowsAbortos = await buildDiagnosticoRows(acoesAbortosVacas);
            diagnosticoWidgets.addAll(tabelaComTitulo(
              comTituloDaSecao([
                pw.Text(
                  'Abortos',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#ee0000'),
                  ),
                ),
                pw.SizedBox(height: 5),
              ]),
              [buildDiagnosticoHeader(), ...rowsAbortos],
            ));
          }
        }

        diagnosticoWidgets.add(pw.SizedBox(height: 20));
      }
    }

    // Assinaturas: do arquivo local se ainda não subiram ao Storage, senão da
    // URL. Sem rede, a imagem só falta no PDF em vez de abortar a geração.
    final msConsultas = cronometro.elapsedMilliseconds;
    final assinaturas = await Future.wait([
      AssinaturasLocais.bytes(
          resumoVisitaData['assinaturaProdutor'] as String?),
      AssinaturasLocais.bytes(resumoVisitaData['assinaturaTecnico'] as String?),
    ]);
    final assinaturaProdutor = assinaturas[0];
    final assinaturaTecnico = assinaturas[1];

    final msDados = cronometro.elapsedMilliseconds;

    // Adiciona uma página ao documento PDF com a lista de recomendações e tratamentos
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Image(
                        pw.MemoryImage(logoImage),
                        fit: pw.BoxFit.cover,
                        width: 30, // Reduzido para 40
                        height: 30, // Reduzido para 40
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 9,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (nomeTecnico != null && nomeTecnico.isNotEmpty)
                          pw.Text(nomeTecnico,
                              style: const pw.TextStyle(
                                fontSize: 18,
                              )),
                        if (nomeEmpresaTecnico != null &&
                            nomeEmpresaTecnico.isNotEmpty)
                          pw.Text(nomeEmpresaTecnico,
                              style: const pw.TextStyle(
                                fontSize: 18,
                              )),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        if (nomeProdutor != null && nomeProdutor.isNotEmpty)
                          pw.Text(nomeProdutor,
                              style: const pw.TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: pw.TextAlign.right),
                        if (enderecoProdutor != null &&
                            enderecoProdutor.isNotEmpty)
                          pw.Text(
                            enderecoProdutor,
                            style: const pw.TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: pw.TextAlign.right,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return pw.SizedBox(); // Retorna um widget vazio para outras páginas
          }
        },
        build: (pw.Context context) {
          return [
            pw.Divider(color: PdfColor.fromHex('#D3D3D3')),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Receituário - $dtVisitaFormatado',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Divider(color: PdfColor.fromHex('#D3D3D3')),
            ...recomendacoesWidgets,
            ...diagnosticoWidgets,
            pw.SizedBox(height: 50),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (assinaturaTecnico != null)
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(
                        pw.MemoryImage(assinaturaTecnico),
                        width:
                            100, // Ajuste a largura da imagem conforme necessário
                        height:
                            50, // Ajuste a altura da imagem conforme necessário
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Assinatura Técnico',
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                if (assinaturaProdutor != null)
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Image(
                        pw.MemoryImage(assinaturaProdutor),
                        width:
                            100, // Ajuste a largura da imagem conforme necessário
                        height:
                            50, // Ajuste a altura da imagem conforme necessário
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Assinatura Produtor',
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ];
        },
      ),
    );

    // Define o nome do arquivo PDF com base na data atual
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);
    final fileName = 'receituario-$formattedDate.pdf';

    // Salva o documento PDF em um arquivo temporário
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    final msPdf = cronometro.elapsedMilliseconds;

    // Abre o documento PDF usando o visualizador de PDF padrão
    // Antes de abrir: no iOS o OpenFile só retorna quando o visualizador fecha.
    debugPrint(
        '🧾 Receituário pronto em ${msPdf}ms (consultas ${msConsultas}ms, '
        'assinaturas ${msDados - msConsultas}ms, montar PDF ${msPdf - msDados}ms)');
    final result = await OpenFile.open(file.path);
    debugPrint('🧾 Visualizador: ${result.message}');
  } catch (e, st) {
    // Propaga em vez de engolir. Enquanto este catch só imprimia, o clique em
    // "Gerar PDF" não fazia nada e a tela não dizia por quê — um cast quebrado
    // (DateTime x Timestamp) passou despercebido até alguém ler o console.
    debugPrint('❌ Erro ao gerar o receituário: $e');
    debugPrint('$st');
    rethrow;
  }
}

/// Número pelo qual o animal entra na ordem do receituário.
///
/// É o brinco quando ele é válido. Sem brinco, vale o nome se ele for só um
/// número: há vacas cadastradas com o número no nome e brinco zerado (a 182,
/// por exemplo), e o PDF mostra esse número na coluna "Animal" como se fosse
/// brinco. Ordenar só pelo brinco jogava esses animais para o fim da lista.
@visibleForTesting
int? numeroParaOrdenar(dynamic brinco, dynamic nome) {
  bool valido(int? n) => n != null && n > 0 && n != 99999 && n != 999999;
  final doBrinco = int.tryParse(brinco?.toString().trim() ?? '');
  if (valido(doBrinco)) return doBrinco;
  final doNome = int.tryParse(nome?.toString().trim() ?? '');
  return valido(doNome) ? doNome : null;
}

const _bordaTabela = pw.TableBorder(
  top: pw.BorderSide(style: pw.BorderStyle.dashed),
  bottom: pw.BorderSide(style: pw.BorderStyle.dashed),
  left: pw.BorderSide(style: pw.BorderStyle.dashed),
  right: pw.BorderSide(style: pw.BorderStyle.dashed),
  horizontalInside: pw.BorderSide(style: pw.BorderStyle.dashed),
  verticalInside: pw.BorderSide(style: pw.BorderStyle.dashed),
);

/// Linhas que viajam junto com o título da seção.
const _linhasPresasAoTitulo = 3;

/// Título + tabela, sem deixar o título órfão no pé da página.
///
/// O MultiPage quebra a tabela entre linhas, mas não sabe que o título
/// pertence a ela: quando só o título cabia, ele ficava sozinho no fim da
/// página e a tabela começava na seguinte, deixando um vão em branco. Agora
/// título, cabeçalho e as primeiras linhas formam um bloco indivisível.
///
/// O resto da tabela continua como filho direto do MultiPage — dentro de uma
/// pw.Column ela não paginaria (TooManyPagesException). Ela não repete o
/// cabeçalho: com `repeat` ele sairia duplicado logo abaixo do bloco.
/// [linhas] começa pelo cabeçalho.
List<pw.Widget> tabelaComTitulo(
    List<pw.Widget> titulos, List<pw.TableRow> linhas) {
  final corte = (1 + _linhasPresasAoTitulo).clamp(0, linhas.length);
  return [
    // Sem o Inseparable a pw.Column é "spanning" e o MultiPage a quebraria
    // justamente entre o título e a tabela.
    pw.Inseparable(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          ...titulos,
          pw.Table(border: _bordaTabela, children: linhas.sublist(0, corte)),
        ],
      ),
    ),
    if (linhas.length > corte)
      pw.Table(border: _bordaTabela, children: linhas.sublist(corte)),
  ];
}

/// Texto da coluna "Observação" / "Data secagem" do tratamento. Nunca nulo:
/// `pw.Text` não aceita null e o PDF inteiro falhava.
///
/// A secagem gravou `observacaoAcao` nulo de a1ea501 até out/2026 (antes, e
/// de novo agora, ali vai a data da secagem). Para esses registros a data vem
/// do animal, que guarda `dtSecagem`.
String _observacaoDoTratamento(TratamentoEntity e) {
  final obs = e.observacaoAcao;
  if (obs != null && obs.isNotEmpty) return obs;
  if (e.tipoAcao == 'Secagem' && e.uidAnimalPath != null) {
    final animal =
        AnimalRepository().getByFirestoreId(e.uidAnimalPath!.split('/').last);
    return animal?.dtSecagem ?? '';
  }
  return obs ?? '';
}
