// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Certifique-se de importar o pacote intl

Future<void> createResumoRebanho(
  List<DocumentReference> animaisProdutores,
  bool ultimoParto,
  bool ultimaInseminacao,
  bool del,
  bool touro,
  bool secagem,
  bool preParto,
  bool paricao,
  bool diasEmAberto,
  bool intervaloPartos,
  List<String> categorias, // Lista de categorias selecionadas
  List<String>? filtroStatus, // Lista de status selecionados
  String nomeProdutor,
  String enderecoProdutor,
  String nomeTecnico,
  String telefoneTecnico,
  String emailTecnico,
  String nomeEmpresaTecnico, // Campo opcional
  String logoUrl,
) async {
  try {
    // Baixar a imagem da URL
    final http.Response response = await http.get(Uri.parse(logoUrl));
    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar a imagem');
    }
    final Uint8List logoImage = response.bodyBytes;

    // Lista para armazenar os dados dos animais filtrados
    List<Map<String, dynamic>> animaisData = [];

    // Filtrar os animais produtores de acordo com as categorias selecionadas
    for (var animalRef in animaisProdutores) {
      DocumentSnapshot documentSnapshot = await animalRef.get();
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;

        // Filtrar por Categoria
        if (!categorias.contains(data['grupoAnimal'])) {
          continue;
        }

        // Filtrar por Status para Vacas e Novilhas
        if (['Vacas', 'Novilhas'].contains(data['grupoAnimal'])) {
          if (filtroStatus != null && filtroStatus.isNotEmpty) {
            bool statusMatch = false;

            for (var status in filtroStatus) {
              if (status == 'Indução de Lactação') {
                if (data['status'] == 'Vazia' &&
                    data['dtInducaoLactacao'] != null) {
                  statusMatch = true;
                  break;
                }
              } else {
                if (data['status'] == status) {
                  statusMatch = true;
                  break;
                }
              }
            }

            if (!statusMatch) {
              continue;
            }
          }
        }

        // Determinar Status Reprodutivo
        String statusReprodutivo = '';
        if (data['status'] == 'Vazia' &&
            (data['grupoAnimal'] == 'Novilhas' ||
                data['grupoAnimal'] == 'Vacas') &&
            data['dtInducaoLactacao'] is Timestamp) {
          statusReprodutivo = 'Indução de Lactação';
        } else if ([
          'Inseminada',
          'Inseminada PP',
          'Vazia',
          'Prenha',
          'Pré Parto',
          'Seca',
          'Descarte'
        ].contains(data['status'])) {
          statusReprodutivo = data['status'];
        }

        // Adicionar os dados do animal à lista
        animaisData.add({
          'nomeAnimal': data['nomeAnimal'] ?? null,
          'brincoAnimal': data['brincoAnimal'] ?? null,
          'grupoAnimal': data['grupoAnimal'] ?? null,
          'statusReprodutivo': statusReprodutivo,
          'dtUltimoPartoContingencia':
              data['dtUltimoPartoContingencia'] ?? null,
          'dtUltimaInseminacao': data['dtUltimaInseminacao'] ?? null,
          'nomeTouroUltimaInseminacao':
              data['nomeTouroUltimaInseminacao'] ?? null,
          'dtSecagem':
              (data['status'] == 'Vazia' && data['dtSecPrevista'] == null)
                  ? ''
                  : data['dtSecPrevista'] ?? null,
          'dtPrePartoPrevista': data['dtPrePartoPrevista'] ?? null,
          'dtSecPrevista': data['grupoAnimal'] == 'Vacas'
              ? data['dtSecPrevista'] ?? null
              : null,
          'dtUltimoParto':
              data['dtUltimoParto'] ?? null, // Adiciona a data do último parto
          'dtPartoPrevisto': data['dtPartoPrevisto'] ?? null,
        });
      }
    }

    // Ordenar a lista de animais por nomeAnimal e brincoAnimal
    animaisData.sort((a, b) {
      int nameComparison =
          (a['nomeAnimal'] ?? '').compareTo(b['nomeAnimal'] ?? '');
      if (nameComparison != 0) return nameComparison;
      return (a['brincoAnimal'] ?? '').compareTo(b['brincoAnimal'] ?? '');
    });

    // Contar quantas colunas booleanas são verdadeiras
    int colunasAtivas = [
      ultimoParto,
      ultimaInseminacao,
      del,
      touro,
      secagem,
      preParto,
      paricao,
      diasEmAberto,
      intervaloPartos
    ].where((c) => c).toList().length;

    // Ajustar o tamanho da fonte se houver mais de quatro colunas booleanas ativas
    double fontSize = colunasAtivas > 4 ? 8.0 : 12.0;

    // Cria um documento PDF
    final pdf = pw.Document();

    // Função que retorna a linha do cabeçalho da tabela
    pw.TableRow buildTableHeader() {
      return pw.TableRow(
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Nome/brinco',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Categoria',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Status Reprod.',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          if (ultimoParto)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Últ. parto',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (del)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'DEL',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (ultimaInseminacao)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Últ. Insem.',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (touro)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Touro',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (diasEmAberto)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Dias Aberto',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (intervaloPartos)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Inter. Partos',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (secagem)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Secagem',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (preParto)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Pré Par. P.',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          if (paricao)
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Dt. Par. P.',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    // Adiciona uma página ao documento PDF com a lista de animais
    pdf.addPage(
      pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        header: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Container(
                alignment: pw.Alignment.center,
                margin: pw.EdgeInsets.only(bottom: 20.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Informações do Produtor:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 10),
                          pw.Text('Nome: $nomeProdutor'),
                          pw.Text('Endereço: $enderecoProdutor'),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        alignment: pw.Alignment.center,
                        child: pw.Image(
                          pw.MemoryImage(logoImage),
                          fit: pw.BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('Informações do Técnico:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 10),
                          pw.Text('Nome: $nomeTecnico'),
                          if (nomeEmpresaTecnico.isNotEmpty)
                            pw.Text('Empresa: $nomeEmpresaTecnico'),
                          pw.Text('Telefone: $telefoneTecnico'),
                          pw.Text('E-mail: $emailTecnico'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              // Adiciona o cabeçalho da tabela em cada página
              pw.Table(
                border: pw.TableBorder.all(),
                children: [buildTableHeader()],
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                for (var animalData in animaisData)
                  pw.TableRow(
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            (animalData['nomeAnimal'] != null &&
                                    animalData['brincoAnimal'] != null &&
                                    animalData['brincoAnimal'] != -1)
                                ? '${animalData['nomeAnimal']} - ${animalData['brincoAnimal']}'
                                : (animalData['brincoAnimal'] != null &&
                                        animalData['brincoAnimal'] != -1)
                                    ? '${animalData['brincoAnimal']}'
                                    : (animalData['nomeAnimal'] != null
                                        ? animalData['nomeAnimal']
                                        : ''),
                            style: pw.TextStyle(fontSize: fontSize),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            animalData['grupoAnimal'].toString() ?? '',
                            style: pw.TextStyle(fontSize: fontSize),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            animalData['statusReprodutivo'].toString() ?? '',
                            style: pw.TextStyle(fontSize: fontSize),
                          ),
                        ),
                      ),
                      if (ultimoParto)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              animalData['dtUltimoPartoContingencia'] ?? '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      if (del)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              animalData['dtUltimoParto'] != null &&
                                      animalData['dtUltimoParto'].isNotEmpty &&
                                      animalData['grupoAnimal'] == 'Vacas' &&
                                      [
                                        'Vazia',
                                        'Inseminada',
                                        'Inseminada PP',
                                        'Prenha'
                                      ].contains(
                                          animalData['statusReprodutivo'])
                                  ? calcularDiferencaEmDias(
                                      animalData['dtUltimoParto'],
                                    ).toString()
                                  : '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      if (ultimaInseminacao)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              animalData['dtUltimaInseminacao'] ?? '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      if (touro)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              animalData['nomeTouroUltimaInseminacao'] ?? '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      if (diasEmAberto)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              (animalData['dtUltimaInseminacao'] != null &&
                                      animalData['dtUltimaInseminacao']
                                          .isNotEmpty &&
                                      animalData['dtUltimoPartoContingencia'] !=
                                          null &&
                                      animalData['dtUltimoPartoContingencia']
                                          .isNotEmpty)
                                  ? calcularIntervaloMedioIndi(
                                      animalData['dtUltimoPartoContingencia'],
                                      animalData['dtUltimaInseminacao'],
                                    ).toString()
                                  : '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      if (intervaloPartos)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              (animalData['dtUltimoPartoContingencia'] != null &&
                                      animalData['dtUltimoPartoContingencia']
                                          .isNotEmpty &&
                                      animalData['dtPrePartoPrevista'] !=
                                          null &&
                                      animalData['dtPrePartoPrevista']
                                          .isNotEmpty &&
                                      animalData['grupoAnimal'] == 'Vacas')
                                  ? mediaDiasEntreDatasInd(
                                      animalData['dtUltimoPartoContingencia'],
                                      animalData['dtPrePartoPrevista'],
                                    ).toString()
                                  : '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      if (secagem)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              animalData['dtSecPrevista'] ?? '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      if (preParto)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              animalData['dtPrePartoPrevista'] ?? '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      if (paricao)
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              animalData['dtPartoPrevisto'] ?? '',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
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
    final fileName = '$nomeProdutor-$formattedDate.pdf';

    // Salva o documento PDF em um arquivo temporário
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    // Abre o documento PDF usando o visualizador de PDF padrão
    final result = await OpenFile.open(file.path);
    print('OpenFile result: $result');
  } catch (e) {
    print('Erro ao gerar PDF: $e');
  }
}

// Função revisada para calcular a média de dias entre datas
int mediaDiasEntreDatasInd(
  String listaPP,
  String listaPartoPrevisto,
) {
  // Formatador para converter a string em DateTime
  DateFormat formatoData = DateFormat('dd/MM/yyyy');

  try {
    // Ignora se qualquer uma das datas estiver vazia
    if (listaPP.isEmpty || listaPartoPrevisto.isEmpty) {
      return 0; // Retorna 0 ou algum valor padrão que você prefira
    }

    // Converter a data do último PP para DateTime
    DateTime dataPPConvertida = formatoData.parse(listaPP);

    // Converter a data de parto previsto para DateTime
    DateTime dataPartoPrevistoConvertida =
        formatoData.parse(listaPartoPrevisto);

    // Calcular a diferença em dias entre as duas datas
    int diferencaDias =
        dataPartoPrevistoConvertida.difference(dataPPConvertida).inDays;

    // Retornar a diferença de dias
    return diferencaDias;
  } catch (e) {
    print('Erro ao converter as datas: $e');
    return 0; // Retorna 0 em caso de erro
  }
}
