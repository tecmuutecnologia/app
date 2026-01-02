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
import 'package:intl/intl.dart';

Future<void> createReceituario(
  DocumentReference uidResumoVisita,
  String? nomeProdutor,
  String? enderecoProdutor,
  String? nomeTecnico,
  String? telefoneTecnico,
  String dtVisitaFormatado,
  String? emailTecnico,
  String? nomeEmpresaTecnico, // Campo opcional
  String logoUrl,
) async {
  try {
    // Baixar a imagem da URL
    final http.Response response = await http.get(Uri.parse(logoUrl));
    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar a imagem');
    }
    final Uint8List logoImage = response.bodyBytes;

    // Cria um documento PDF
    final pdf = pw.Document();

    // Busca o resumo da visita no banco de dados
    final resumoVisitaSnapshot = await uidResumoVisita.get();
    if (!resumoVisitaSnapshot.exists) {
      throw Exception('Resumo da visita não encontrado');
    }
    final resumoVisitaData =
        resumoVisitaSnapshot.data() as Map<String, dynamic>?;
    if (resumoVisitaData == null) {
      throw Exception('Dados do resumo da visita não encontrados');
    }
    print('Resumo da visita encontrado: $resumoVisitaData');

    // Busca recomendações relacionadas ao resumo da visita
    final recomendacoesSnapshot = await FirebaseFirestore.instance
        .collection('resumo_da_visita')
        .doc(uidResumoVisita.id)
        .collection('recomendacoes')
        .where('uidResumoDaVisita', isEqualTo: uidResumoVisita)
        .get();

    print('Recomendações encontradas: ${recomendacoesSnapshot.docs.length}');

    // Ordena as recomendações
    List<QueryDocumentSnapshot> sortedRecomendacoes =
        recomendacoesSnapshot.docs.toList();
    sortedRecomendacoes.sort((a, b) {
      String tituloA =
          (a.data() as Map<String, dynamic>)['tituloRecomendacao'] ?? '';
      String tituloB =
          (b.data() as Map<String, dynamic>)['tituloRecomendacao'] ?? '';
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

    for (final recomendacaoDoc in sortedRecomendacoes) {
      final recomendacaoData = recomendacaoDoc.data() as Map<String, dynamic>?;
      if (recomendacaoData == null) continue;
      print('Recomendação: ${recomendacaoData['tituloRecomendacao']}');

      // Busca tratamentos relacionados à recomendação atual dentro de resumo_da_visita
      final tratamentosSnapshot = await FirebaseFirestore.instance
          .collection('resumo_da_visita')
          .doc(uidResumoVisita.id)
          .collection('tratamentos')
          .where('tipoAcao', isEqualTo: recomendacaoData['tituloRecomendacao'])
          .get();

      print(
          'Tratamentos encontrados para ${recomendacaoData['tituloRecomendacao']}: ${tratamentosSnapshot.docs.length}');

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

      for (final tratamentoDoc in tratamentosSnapshot.docs) {
        final tratamentoData = tratamentoDoc.data() as Map<String, dynamic>?;
        if (tratamentoData == null) continue;
        print('Tratamento: ${tratamentoData['observacaoAcao']}');

        String brincoNomeAnimal;
        if (tratamentoData['brincoAnimal'] != null &&
            tratamentoData['brincoAnimal'] != -1 &&
            tratamentoData['brincoAnimal'] != '-1' &&
            tratamentoData['brincoAnimal'].toString().isNotEmpty &&
            tratamentoData['nomeAnimal'] != null &&
            tratamentoData['nomeAnimal'].isNotEmpty) {
          brincoNomeAnimal =
              '${tratamentoData['brincoAnimal']} - ${tratamentoData['nomeAnimal']}';
        } else if (tratamentoData['nomeAnimal'] != null &&
            tratamentoData['nomeAnimal'].isNotEmpty) {
          brincoNomeAnimal = tratamentoData['nomeAnimal'];
        } else if (tratamentoData['brincoAnimal'] != null &&
            tratamentoData['brincoAnimal'] != -1 &&
            tratamentoData['brincoAnimal'] != '-1' &&
            tratamentoData['brincoAnimal'].toString().isNotEmpty) {
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
                  child: pw.Text(tratamentoData['observacaoAcao']),
                ),
              ),
            ],
          ),
        );
      }

      // Adiciona a recomendação e seus tratamentos ao PDF
      recomendacoesWidgets.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
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
            pw.Table(
              border: pw.TableBorder(
                top: pw.BorderSide(style: pw.BorderStyle.dashed),
                bottom: pw.BorderSide(style: pw.BorderStyle.dashed),
                left: pw.BorderSide(style: pw.BorderStyle.dashed),
                right: pw.BorderSide(style: pw.BorderStyle.dashed),
                horizontalInside: pw.BorderSide(style: pw.BorderStyle.dashed),
                verticalInside: pw.BorderSide(style: pw.BorderStyle.dashed),
              ),
              children: tratamentosRows,
            ),
            if (recomendacaoData['descricaoRecomendacao'] != null &&
                recomendacaoData['descricaoRecomendacao'].isNotEmpty)
              pw.Text(
                'Tratamento: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            if (recomendacaoData['descricaoRecomendacao'] != null &&
                recomendacaoData['descricaoRecomendacao'].isNotEmpty)
              pw.Text(
                '${recomendacaoData['descricaoRecomendacao']}',
              ),
            pw.SizedBox(height: 20),
          ],
        ),
      );
    }

    // Função para baixar a imagem da assinatura do técnico
    Future<Uint8List?> downloadSignature(String url) async {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    }

    // Baixar a assinatura do produtor, se disponível
    Uint8List? assinaturaProdutor;
    if (resumoVisitaData.containsKey('assinaturaProdutor') &&
        resumoVisitaData['assinaturaProdutor'] != null) {
      assinaturaProdutor =
          await downloadSignature(resumoVisitaData['assinaturaProdutor']);
    }

    // Baixar a assinatura do técnico, se disponível
    Uint8List? assinaturaTecnico;
    if (resumoVisitaData.containsKey('assinaturaTecnico') &&
        resumoVisitaData['assinaturaTecnico'] != null) {
      assinaturaTecnico =
          await downloadSignature(resumoVisitaData['assinaturaTecnico']);
    }

    // Adiciona uma página ao documento PDF com a lista de recomendações e tratamentos
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return pw.Container(
              alignment: pw.Alignment.center,
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Transform.rotate(
                        angle: 0, // Virar a logomarca
                        child: pw.Image(
                          pw.MemoryImage(logoImage),
                          fit: pw.BoxFit.cover,
                          width: 30, // Reduzido para 40
                          height: 30, // Reduzido para 40
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 9,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (nomeTecnico != null && nomeTecnico.isNotEmpty)
                          pw.Text('$nomeTecnico',
                              style: pw.TextStyle(
                                fontSize: 18,
                              )),
                        if (nomeEmpresaTecnico != null &&
                            nomeEmpresaTecnico.isNotEmpty)
                          pw.Text('$nomeEmpresaTecnico',
                              style: pw.TextStyle(
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
                          pw.Text('$nomeProdutor',
                              style: pw.TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: pw.TextAlign.right),
                        if (enderecoProdutor != null &&
                            enderecoProdutor.isNotEmpty)
                          pw.Text(
                            '$enderecoProdutor',
                            style: pw.TextStyle(
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
                        style: pw.TextStyle(
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
                        style: pw.TextStyle(
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

    // Abre o documento PDF usando o visualizador de PDF padrão
    final result = await OpenFile.open(file.path);
    print('OpenFile result: $result');
  } catch (e) {
    print('Erro ao gerar PDF: $e');
  }
}
