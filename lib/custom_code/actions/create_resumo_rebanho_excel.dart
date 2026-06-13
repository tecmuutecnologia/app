// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/core/ui/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

Future<void> createResumoRebanhoExcel(
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
  bool ultimaAcao, // Novo parâmetro para coluna Última Ação
  DocumentReference uidTecnico, // Referência do técnico para buscar ações
) async {
  try {
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

        // Buscar última ação para animais com status "Vazia" se a opção estiver habilitada
        String ultimaAcaoAnimal = '';
        if (ultimaAcao &&
            statusReprodutivo == 'Vazia' &&
            (data['grupoAnimal'] == 'Vacas' ||
                data['grupoAnimal'] == 'Novilhas')) {
          try {
            // Buscar todas as ações do animal (sem orderBy para evitar necessidade de índice composto)
            final acoesSnapshot = await FirebaseFirestore.instance
                .collection('tecnico')
                .doc(uidTecnico.id)
                .collection('acoes')
                .where('uidAnimalAnimaisProdutores', isEqualTo: animalRef)
                .get();

            if (acoesSnapshot.docs.isNotEmpty) {
              // Filtrar ações que têm dataDaAcao e ordenar manualmente
              final acoesComData = acoesSnapshot.docs.where((doc) {
                final docData = doc.data();
                return docData['dataDaAcao'] != null;
              }).toList();

              // Ordenar por dataDaAcao (mais recente primeiro)
              acoesComData.sort((a, b) {
                final dataA = (a.data()['dataDaAcao'] as Timestamp).toDate();
                final dataB = (b.data()['dataDaAcao'] as Timestamp).toDate();
                return dataB.compareTo(dataA); // Ordem decrescente
              });

              // Filtrar ações válidas do exame ginecológico (IATF, CGI, CGII, Liberada, etc.)
              // Excluir: Inseminada, Cio, PP, DG+, DG-, Inseminada PP
              final acoesValidas = acoesComData.where((doc) {
                final acaoNome = (doc.data())['acao'] as String? ?? '';
                return acaoNome != 'Inseminada' &&
                    acaoNome != 'Cio' &&
                    acaoNome != 'PP' &&
                    acaoNome != 'DG+' &&
                    acaoNome != 'DG-' &&
                    acaoNome != 'Inseminada PP';
              }).toList();

              if (acoesValidas.isNotEmpty) {
                final acaoData = acoesValidas.first.data();
                ultimaAcaoAnimal = acaoData['acao'] ?? '';

                // Adicionar a data da ação para melhor contexto
                final dataAcao = acaoData['dataDaAcao'] as Timestamp?;
                if (dataAcao != null) {
                  final dataFormatada =
                      DateFormat('dd/MM').format(dataAcao.toDate());
                  ultimaAcaoAnimal = '$ultimaAcaoAnimal ($dataFormatada)';
                }

                print(
                    'Última ação encontrada para ${data['nomeAnimal']}: $ultimaAcaoAnimal');
              }
            }
          } catch (e) {
            print('Erro ao buscar última ação para ${data['nomeAnimal']}: $e');
          }
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
          'ultimaAcao':
              ultimaAcaoAnimal, // Última ação do animal (apenas para Vazias)
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

    // Criar um novo arquivo Excel
    var excel = Excel.createExcel();

    // Adicionar nova planilha
    Sheet sheet = excel['Sheet1'];

    // Preparar cabeçalho da tabela
    List<dynamic> headerRow = [
      'Nome/brinco',
      'Categoria',
      'Status Reprod.',
    ];

    if (ultimoParto) headerRow.add('Últ. parto');
    if (del) headerRow.add('DEL');
    if (ultimaInseminacao) headerRow.add('Últ. Insem.');
    if (touro) headerRow.add('Touro');
    if (diasEmAberto) headerRow.add('Dias Aberto');
    if (intervaloPartos) headerRow.add('Inter. Partos');
    if (secagem) headerRow.add('Secagem');
    if (preParto) headerRow.add('Pré Par. P.');
    if (paricao) headerRow.add('Dt. Par. P.');
    if (ultimaAcao) headerRow.add('Últ. Ação');

    // Adicionar informações do produtor e técnico acima da tabela
    sheet.appendRow(['INFORMAÇÕES DO PRODUTOR E TÉCNICO']);
    sheet.appendRow(['']);
    sheet.appendRow(['Produtor: $nomeProdutor']);
    sheet.appendRow(['Endereço: $enderecoProdutor']);
    sheet.appendRow(['']);
    sheet.appendRow(['Técnico: $nomeTecnico']);
    if (nomeEmpresaTecnico.isNotEmpty) {
      sheet.appendRow(['Empresa: $nomeEmpresaTecnico']);
    }
    sheet.appendRow(['Telefone: $telefoneTecnico']);
    sheet.appendRow(['E-mail: $emailTecnico']);
    sheet.appendRow(['']);
    sheet.appendRow(['']);

    // Adicionar cabeçalho da tabela
    sheet.appendRow(headerRow);

    // Adicionar dados dos animais
    for (var animalData in animaisData) {
      List<dynamic> row = [
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
        animalData['grupoAnimal'].toString() ?? '',
        animalData['statusReprodutivo'].toString() ?? '',
      ];

      if (ultimoParto) {
        row.add(animalData['dtUltimoPartoContingencia'] ?? '');
      }

      if (del) {
        row.add(animalData['dtUltimoParto'] != null &&
                animalData['dtUltimoParto'].isNotEmpty &&
                animalData['grupoAnimal'] == 'Vacas' &&
                ['Vazia', 'Inseminada', 'Inseminada PP', 'Prenha']
                    .contains(animalData['statusReprodutivo'])
            ? functions.calcularDiferencaEmDias(
                animalData['dtUltimoParto'],
              )
            : '');
      }

      if (ultimaInseminacao) {
        row.add(animalData['dtUltimaInseminacao'] ?? '');
      }

      if (touro) {
        row.add(animalData['nomeTouroUltimaInseminacao'] ?? '');
      }

      if (diasEmAberto) {
        row.add((animalData['dtUltimaInseminacao'] != null &&
                animalData['dtUltimaInseminacao'].isNotEmpty &&
                animalData['dtUltimoPartoContingencia'] != null &&
                animalData['dtUltimoPartoContingencia'].isNotEmpty)
            ? functions.calcularIntervaloMedioIndi(
                animalData['dtUltimoPartoContingencia'],
                animalData['dtUltimaInseminacao'],
              )
            : '');
      }

      if (intervaloPartos) {
        row.add((animalData['dtUltimoPartoContingencia'] != null &&
                animalData['dtUltimoPartoContingencia'].isNotEmpty &&
                animalData['dtPrePartoPrevista'] != null &&
                animalData['dtPrePartoPrevista'].isNotEmpty &&
                animalData['grupoAnimal'] == 'Vacas')
            ? mediaDiasEntreDatasExcel(
                animalData['dtUltimoPartoContingencia'],
                animalData['dtPrePartoPrevista'],
              )
            : '');
      }

      if (secagem) {
        row.add(animalData['dtSecPrevista'] ?? '');
      }

      if (preParto) {
        row.add(animalData['dtPrePartoPrevista'] ?? '');
      }

      if (paricao) {
        row.add(animalData['dtPartoPrevisto'] ?? '');
      }

      if (ultimaAcao) {
        row.add(animalData['statusReprodutivo'] == 'Vazia'
            ? (animalData['ultimaAcao'] ?? '')
            : '');
      }

      sheet.appendRow(row);
    }

    // Define o nome do arquivo Excel com base na data atual
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);
    final fileName = '$nomeProdutor-$formattedDate.xlsx';

    // Salva o arquivo Excel em um diretório temporário
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');

    // Codificar o Excel e escrever para o arquivo
    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);

      // Abrir o arquivo Excel usando o aplicativo padrão
      final result = await OpenFile.open(file.path);
      print('OpenFile result: $result');
    }
  } catch (e) {
    print('Erro ao gerar Excel: $e');
  }
}

// Função para calcular a média de dias entre datas no Excel
int mediaDiasEntreDatasExcel(
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
