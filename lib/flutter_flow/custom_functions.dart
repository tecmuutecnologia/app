import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

String somarDataParto(String dtInseminacao) {
  try {
    DateTime data = DateFormat('dd/MM/yyyy').parse(dtInseminacao);
    DateTime dataAtualizada = data.add(Duration(days: 280));
    String dataAtualizadaString =
        DateFormat('dd/MM/yyyy').format(dataAtualizada);
    return dataAtualizadaString;
  } catch (e) {
    print('Erro ao converter a data: $e');
    return dtInseminacao;
  }
}

int mediaDiasEntreDatasInd(
  String listaPP,
  String listaPartoPrevisto,
) {
  // Formatador para converter a string em DateTime
  DateFormat formatoData = DateFormat('dd/MM/yyyy');

  try {
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
    throw Exception('Erro ao converter as datas: $e');
  }
}

int calcularIntervaloMedioIndi(
  String datasUltimoParto,
  String datasInseminacao,
) {
  DateFormat formato = DateFormat("dd/MM/yyyy");

  // Verifica se ambas as datas não são nulas ou vazias
  if (datasUltimoParto.isEmpty || datasInseminacao.isEmpty) {
    return 0;
  }

  try {
    DateTime dataParto = formato.parse(datasUltimoParto);
    DateTime dataInseminacao = formato.parse(datasInseminacao);

    // Verifica se a data de inseminação é posterior à data do parto
    if (dataInseminacao.isAfter(dataParto)) {
      // Calcula o número de dias entre as datas
      int diasDeDiferenca = dataInseminacao.difference(dataParto).inDays;
      return diasDeDiferenca;
    } else {
      return 0;
    }
  } catch (e) {
    print('Erro ao parsear datas: $e');
    return 0;
  }
}

String somarDataSecagem(String dtInseminacao) {
  try {
    DateTime data = DateFormat('dd/MM/yyyy').parse(dtInseminacao);
    DateTime dataAtualizada = data.add(Duration(days: 220));
    String dataAtualizadaString =
        DateFormat('dd/MM/yyyy').format(dataAtualizada);
    return dataAtualizadaString;
  } catch (e) {
    print('Erro ao converter a data: $e');
    return dtInseminacao;
  }
}

String somarDataPreParto(String dtInseminacao) {
  try {
    DateTime data = DateFormat('dd/MM/yyyy').parse(dtInseminacao);
    DateTime dataAtualizada = data.add(Duration(days: 259));
    String dataAtualizadaString =
        DateFormat('dd/MM/yyyy').format(dataAtualizada);
    return dataAtualizadaString;
  } catch (e) {
    print('Erro ao converter a data: $e');
    return dtInseminacao;
  }
}

DateTime converterStringParaData(
  String dataString,
  String quantidadeDiasString,
) {
  try {
    DateTime dataConvertida = DateFormat('dd/MM/yyyy').parse(dataString);
    int quantidadeDias = int.parse(quantidadeDiasString);
    return dataConvertida.add(Duration(days: quantidadeDias));
  } catch (e) {
    print('Erro ao converter a data: $e');
    // Você pode tratar o erro conforme necessário, por exemplo, lançar uma exceção ou retornar null.
    return DateTime.now().add(
        Duration(days: 28)); // Retorna a data atual + 28 dias em caso de erro.
  }
}

DateTime retornaDataDiasDg(
  DateTime dataAtual,
  String diasDg,
) {
  try {
    int diasParaAdicionar = int.parse(diasDg);
    return dataAtual.add(Duration(days: diasParaAdicionar));
  } catch (e) {
    print('Erro ao converter a quantidade de dias: $e');
    return dataAtual; // Retorna a data atual em caso de erro.
  }
}

DateTime obterDataAtual() {
  return DateTime.now();
}

DateTime obterDataAtualFormat() {
  DateTime dataAtual = DateTime.now();
  String dataFormatada = DateFormat('dd/MM/yyyy').format(dataAtual);
  return DateFormat('dd/MM/yyyy').parse(dataFormatada);
}

DateTime converteDataStringDate(String dataString) {
  final dateFormat = DateFormat('dd/MM/yyyy');

  try {
    DateTime data = dateFormat.parseStrict(dataString);
    return data;
  } catch (e) {
    print("Erro ao converter data: $e");
    throw Exception("Falha ao converter a data.");
  }
}

List<String> retornaStringEmLista(String valor) {
  // Verifica se a string de entrada não é nula ou vazia
  if (valor == null || valor.isEmpty) {
    return []; // Retorna uma lista vazia se a string for nula ou vazia
  }

  // Divida a string usando a vírgula como delimitador
  List<String> lista = valor.split(',');

  // Remova espaços em branco adicionais em cada item da lista
  lista = lista.map((item) => item.trim()).toList();

  return lista;
}

String obterDataAtualMenosTresAnos() {
  // Obter a data atual
  DateTime dataAtual = DateTime.now();

  // Subtrair 3 anos
  DateTime dataMenosTresAnos = dataAtual.subtract(Duration(days: 3 * 365));

  // Formatar a data como uma string no formato desejado
  String dataFormatada = DateFormat('dd/MM/yyyy').format(dataMenosTresAnos);

  return dataFormatada;
}

int calcularDiferencaEmDias(String dataUltimoPartoString) {
  // Verifique se a string é "0" ou null e ignore
  if (dataUltimoPartoString == "0" || dataUltimoPartoString == null) {
    return 0; // ou outro valor padrão que você desejar
  }

  List<String> partesData = dataUltimoPartoString.split('/');

  // Certifique-se de que há três partes na data
  if (partesData.length == 3) {
    try {
      int dia = int.parse(partesData[0]);
      int mes = int.parse(partesData[1]);
      int ano = int.parse(partesData[2]);

      DateTime dataUltimoParto = DateTime(ano, mes, dia);

      // Obtenha a data atual
      DateTime dataAtual = DateTime.now();

      // Calcule a diferença em dias
      Duration diferenca = dataAtual.difference(dataUltimoParto);

      return diferenca.inDays;
    } catch (e) {
      // Retorne um valor padrão ou relance a exceção, se necessário
      throw FormatException("Erro ao processar a data: ${e.toString()}");
    }
  } else {
    // Se a string da data não estiver no formato esperado
    throw FormatException("Formato de data inválido");
  }
}

bool verificaDataIgualAtualString(String dataString) {
  // Formato da data esperado
  final dateFormat = DateFormat('dd/MM/yyyy');

  // Convertendo a string para um objeto DateTime
  DateTime dataParametro = dateFormat.parse(dataString);

  // Obtendo a data de hoje sem considerar a hora
  DateTime dataAtual = DateTime.now();
  dataAtual = DateTime(dataAtual.year, dataAtual.month, dataAtual.day);

  // Comparando as datas
  return dataParametro.isAtSameMomentAs(dataAtual);
}

bool verificarDataUltimoPartoMenorMaiorAtual(
  String dtUltimaInseminacao,
  String dtInseminacaoNova,
) {
  try {
    // Converte as strings para objetos DateTime
    DateTime ultimaInseminacao =
        DateTime.parse(dtUltimaInseminacao.split('/').reversed.join('-'));
    DateTime inseminacaoNova =
        DateTime.parse(dtInseminacaoNova.split('/').reversed.join('-'));

    // Compara as datas
    if (inseminacaoNova.isAfter(ultimaInseminacao) ||
        inseminacaoNova.isAtSameMomentAs(ultimaInseminacao)) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Erro ao converter as datas: $e");
    return false;
  }
}

String obterDataAtualFormatada() {
  DateTime dataAtual = DateTime.now();
  String formatoData = DateFormat('dd/MM/yyyy').format(dataAtual);
  return formatoData;
}

bool verificaDataAcaoDataAtual(String dataString) {
  DateTime dataAtual = DateTime.now();

  DateFormat formatador = DateFormat('dd/MM/yyyy');
  DateTime data = formatador.parse(dataString);

  bool saoIguais = data.isAtSameMomentAs(
      DateTime(dataAtual.year, dataAtual.month, dataAtual.day));

  return saoIguais;
}

DateTime converterDataUltimaInseminacao(String data) {
  final formatoEntrada = DateFormat('dd/MM/yyyy');

  try {
    DateTime dataConvertida = formatoEntrada.parse(data);
    return dataConvertida;
  } catch (e) {
    print("Erro ao converter a data: $e");
    // Retornar a data de hoje em caso de falha na conversão
    return DateTime.now();
  }
}

String obterDataFormatadaString() {
  DateTime dataAtual = DateTime.now();
  String dataFormatada = DateFormat('dd/MM/yyyy').format(dataAtual);
  return dataFormatada;
}

String formataMoedaText(double valor) {
  final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return formatoMoeda.format(valor);
}

String subtracaoFaturamentoLiquido(
  String valor1,
  String valor2,
) {
  // Removendo o prefixo "R$ " e convertendo para número
  double valor1Numerico =
      double.parse(valor1.replaceAll(RegExp('[^0-9]'), '')) / 100;

  // O valor2 já é um número sem formatação, apenas convertendo para double
  double valor2Numerico = double.parse(valor2);

  // Subtraindo os valores
  double resultadoNumerico = valor1Numerico - valor2Numerico;

  // Formatando o resultado para o formato de moeda
  String resultadoFormatado = 'R\$ ${resultadoNumerico.toStringAsFixed(2)}';

  // Separando os milhares com ponto e o decimal com vírgula
  List<String> parts = resultadoFormatado.split('.');
  String integerPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match match) => '${match[1]}.',
  );
  resultadoFormatado = '$integerPart,${parts[1]}';

  return resultadoFormatado;
}

int calcularLitrosLeiteMes(String litrosPorDiaStr) {
  // Converter a string para número inteiro
  int litrosPorDia = int.parse(litrosPorDiaStr);

  // Calcular a produção mensal multiplicando por 30 (como inteiro)
  int producaoMensal = litrosPorDia * 30;

  // Retornar a produção mensal como número inteiro
  return producaoMensal;
}

double calcularMediaProducaoPorVaca(
  String litrosPorDiaStr,
  String vacasEmLactacaoStr,
) {
  double litrosPorDia = double.parse(litrosPorDiaStr);
  int vacasEmLactacao = int.parse(vacasEmLactacaoStr);

  // Calcular a média de produção por vaca
  double mediaProducaoPorVaca = litrosPorDia / vacasEmLactacao;

  // Retornar o resultado com apenas duas casas decimais
  return double.parse(mediaProducaoPorVaca.toStringAsFixed(2));
}

String calcularTotalRecebido(
  String precoPorLitroStr,
  String litrosRecebidosMesStr,
) {
  // Limpar espaços e caracteres indesejados do preço por litro
  String precoPorLitroLimpo = precoPorLitroStr
      .replaceAll(RegExp(r'[^\d.,]'), '') // Remover caracteres não numéricos
      .replaceAll(',', '.'); // Substituir vírgulas por pontos para decimais

  // Converter o preço por litro para double
  double precoPorLitro = double.parse(precoPorLitroLimpo);

  // Converter litros recebidos no mês para número
  double litrosRecebidosMes = double.parse(litrosRecebidosMesStr.trim());

  // Calcular o total recebido
  double totalRecebido = precoPorLitro * litrosRecebidosMes;

  // Formatando o total recebido para o formato de moeda
  String resultadoFormatado =
      'R\$ ${totalRecebido.toStringAsFixed(2).replaceAll('.', ',')}';

  // Separando os milhares com ponto
  List<String> parts = resultadoFormatado.split(',');
  String integerPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match match) => '${match[1]}.',
  );
  resultadoFormatado = '$integerPart,${parts[1]}';

  return resultadoFormatado;
}

String calcularCustoPorLitro(
  String litros,
  String despesas,
) {
  // Converter o número de litros para inteiro
  int litrosDeLeite;
  try {
    litrosDeLeite = int.parse(litros);
  } catch (e) {
    return 'Erro ao converter litros para inteiro';
  }

  // Converter despesas para número decimal (sem formatação)
  double valorDespesas;
  try {
    valorDespesas = double.parse(despesas);
  } catch (e) {
    return 'Erro ao converter despesas para número';
  }

  // Dividir despesas por litros para obter o custo por litro
  double custoPorLitro = valorDespesas / litrosDeLeite;

  // Formatar como moeda brasileira com duas casas decimais
  final formatoMoeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2);

  // Retornar o custo por litro no formato de moeda
  return formatoMoeda.format(custoPorLitro);
}

double? calcularIntervaloMedio(
  List<String>? datasUltimoParto,
  List<String>? datasInseminacao,
) {
  // Verifica se ambas as listas são nulas ou se pelo menos uma está vazia
  if (datasUltimoParto == null ||
      datasInseminacao == null ||
      datasUltimoParto.isEmpty ||
      datasInseminacao.isEmpty) {
    return null; // Retorna null caso as listas sejam inválidas
  }

  DateFormat formato = DateFormat("dd/MM/yyyy");

  List<int> intervalos = [];

  for (int i = 0;
      i < datasUltimoParto.length && i < datasInseminacao.length;
      i++) {
    try {
      // Remover espaços extras e validar as strings
      String dataUltimoPartoStr = datasUltimoParto[i].trim();
      String dataInseminacaoStr = datasInseminacao[i].trim();

      if (dataUltimoPartoStr.isEmpty || dataInseminacaoStr.isEmpty) {
        throw FormatException('Data vazia encontrada');
      }

      // Converter as strings para DateTime
      DateTime dataParto = formato.parseStrict(dataUltimoPartoStr);
      DateTime dataInseminacao = formato.parseStrict(dataInseminacaoStr);

      // Verifica se a data de inseminação é posterior à data do parto
      if (dataInseminacao.isAfter(dataParto)) {
        // Calcula o número de dias entre as datas
        int diasDeDiferenca = dataInseminacao.difference(dataParto).inDays;
        intervalos.add(diasDeDiferenca);
      }
    } catch (e) {
      print(
          'Erro ao processar datas na posição $i: ${datasUltimoParto[i]}, ${datasInseminacao[i]} - $e');
      // Ignorar a entrada inválida e continuar
      continue;
    }
  }

  // Se não houver intervalos válidos, retorna null para indicar ausência de dados
  if (intervalos.isEmpty) {
    return null;
  }

  // Calcula a soma dos intervalos e depois a média
  int somaIntervalos =
      intervalos.fold(0, (total, elemento) => total + elemento);
  double media = somaIntervalos / intervalos.length;

  return media.roundToDouble();
}

int somaDiasDesdeDatas(List<String> listaDatas) {
  //prod
  DateTime dataAtual = DateTime.now();
  int totalDias = 0;
  int quantidadeDatasValidas = 0;

  // Formatador para converter a string em DateTime
  DateFormat formatoData = DateFormat('dd/MM/yyyy');

  for (String dataString in listaDatas) {
    try {
      // Converter a string para DateTime
      DateTime dataAnterior = formatoData.parse(dataString);

      // Calcular a diferença em dias entre hoje e a data anterior
      int diferencaDias = dataAtual
          .difference(dataAnterior)
          .inDays
          .abs(); // Usamos abs para garantir que a diferença seja positiva

      // Adicionar ao total
      totalDias += diferencaDias;
      quantidadeDatasValidas++;
    } catch (e) {
      // Se houver erro na conversão da data, imprima a mensagem
      print('Erro ao converter a data $dataString: $e');
    }
  }

  // Verificar se há datas válidas para evitar divisão por zero
  if (quantidadeDatasValidas > 0) {
    // Calcular a média
    int media = totalDias ~/
        quantidadeDatasValidas; // A operação ~/ realiza a divisão inteira
    return media;
  } else {
    // Caso não haja datas válidas, retornar 0
    return 0;
  }
  //prod
}

double? mediaDiasEntreDatas(
  List<String>? listaPP,
  List<String>? listaPartoPrevisto,
) {
  // Verifica se as listas são nulas ou estão vazias
  if (listaPP == null ||
      listaPartoPrevisto == null ||
      listaPP.isEmpty ||
      listaPartoPrevisto.isEmpty) {
    return null; // Retorna null caso as listas sejam inválidas
  }

  // Verifica se as listas têm tamanhos diferentes
  if (listaPP.length != listaPartoPrevisto.length) {
    throw ArgumentError(
        'As duas listas devem ter a mesma quantidade de itens.');
  }

  // Formatador para converter a string em DateTime
  DateFormat formatoData = DateFormat('dd/MM/yyyy');

  int somaTotalDias = 0;
  int entradasValidas = 0;

  // Iterar sobre as listas e calcular a diferença de dias
  for (int i = 0; i < listaPP.length; i++) {
    try {
      // Remover espaços extras e validar as strings
      String? dataPPStr = listaPP[i]?.trim();
      String? dataPartoPrevistoStr = listaPartoPrevisto[i]?.trim();

      // Verifica se ambas as datas estão presentes e não são vazias
      if (dataPPStr == null ||
          dataPPStr.isEmpty ||
          dataPartoPrevistoStr == null ||
          dataPartoPrevistoStr.isEmpty) {
        continue; // Ignora esta entrada
      }

      // Converter as strings para DateTime
      DateTime dataPP = formatoData.parseStrict(dataPPStr);
      DateTime dataPartoPrevisto =
          formatoData.parseStrict(dataPartoPrevistoStr);

      // Calcular a diferença em dias entre as duas datas
      int diferencaDias = dataPartoPrevisto.difference(dataPP).inDays;

      // Somar ao total e contar entrada válida
      somaTotalDias += diferencaDias;
      entradasValidas++;
    } catch (e) {
      print(
          'Erro ao processar datas na posição $i: ${listaPP[i]}, ${listaPartoPrevisto[i]} - $e');
      // Ignorar entradas inválidas e continuar
      continue;
    }
  }

  // Se nenhuma entrada válida foi encontrada, retornar null
  if (entradasValidas == 0) {
    return null;
  }

  // Calcular a média de dias
  double mediaDias = somaTotalDias / entradasValidas;

  return mediaDias.roundToDouble();
}

List<int> retornaReproducaoId(List<String> animalStatuses) {
  // Inicializar um mapa para contar cada status
  Map<String, int> statusCount = {
    "Inseminada": 0,
    "Vazia": 0,
    "Prenha": 0,
  };

  // Contar os status na lista de entrada
  for (String status in animalStatuses) {
    if (statusCount.containsKey(status)) {
      statusCount[status] = statusCount[status]! + 1;
    }
  }

  // Retornar apenas as contagens maiores que zero
  List<int> result = statusCount.values.where((count) => count > 0).toList();

  return result;
}

List<String> retornaReproducaoString(List<String> animalStatuses) {
  List<String> orderedStatuses = ["Lactação", "Seca", "Pré Parto"];

  List<String> uniqueStatusList = [];
  Set<String> seenStatuses = Set<String>();

  // Iterar sobre a lista para coletar status únicos mantendo a ordem padrão
  for (String status in animalStatuses) {
    String newStatus = status;
    if (["Vazia", "Inseminada", "Inseminada PP", "Prenha"].contains(status)) {
      newStatus = "Lactação";
    }
    if (!seenStatuses.contains(newStatus)) {
      seenStatuses.add(newStatus);
      uniqueStatusList.add(newStatus);
    }
  }

  // Verificar se "Seca" e "Pré Parto" estão presentes
  bool containsSeca = seenStatuses.contains("Seca");
  bool containsPreParto = seenStatuses.contains("Pré Parto");

  // Criar uma lista de resultado dependendo das condições
  if (containsSeca || containsPreParto) {
    List<String> resultList = ["Lactação"];
    if (containsSeca) {
      resultList.add("Seca");
    }
    if (containsPreParto) {
      resultList.add("Pré Parto");
    }
    return resultList;
  } else {
    return ["Lactação"];
  }
}

List<int> retornaRebanhoProdutivoId(List<String> animalStatuses) {
  List<String> orderedStatuses = ["Lactação", "Seca", "Pré Parto"];

  Map<String, int> statusCount = {};

  // Contar os status na lista de entrada
  for (String status in animalStatuses) {
    String newStatus = status;
    if (["Vazia", "Inseminada", "Inseminada PP", "Prenha"].contains(status)) {
      newStatus = "Lactação";
    }
    if (statusCount.containsKey(newStatus)) {
      statusCount[newStatus] = statusCount[newStatus]! + 1;
    } else {
      statusCount[newStatus] = 1;
    }
  }

  // Criar uma lista completa com as contagens dos status, preenchendo com zeros para os que não estão presentes
  List<int> result = [];
  for (String status in orderedStatuses) {
    result.add(statusCount.containsKey(status) ? statusCount[status]! : 0);
  }

  return result;
}

List<int> retornaContagemGrupos(List<String> animalGroups) {
  // Criar um mapa para contar cada grupo de animais esperado
  Map<String, int> groupCount = {
    "Novilhas": 0,
    "Sêmens": 0,
    "Bezerras": 0,
    "Touros": 0,
    "Bezerros": 0,
    "Vacas": 0,
  };

  // Contar os grupos na lista de entrada
  for (String group in animalGroups) {
    if (groupCount.containsKey(group)) {
      groupCount[group] = (groupCount[group] ?? 0) +
          1; // Incrementar a contagem apenas se o grupo estiver presente
    }
  }

  // Montar a lista de contagens na ordem correta
  List<int> result = groupCount.values.where((value) => value > 0).toList();

  return result; // Retornar a lista de contagens
}

List<String> retornaGruposUnicos(List<String> animalGroups) {
  List<String> uniqueGroupsList = [];
  Set<String> seenGroups = Set<String>();

  // Iterar sobre a lista para coletar grupos únicos mantendo a ordem
  for (String group in animalGroups) {
    if (!seenGroups.contains(group)) {
      seenGroups.add(group); // Adicionar ao conjunto para evitar duplicatas
      uniqueGroupsList.add(group); // Adicionar à lista para manter a ordem
    }
  }

  // Ordenar a lista de grupos únicos em ordem alfabética
  uniqueGroupsList.sort();

  return uniqueGroupsList; // Retornar a lista de grupos únicos
}

List<String> retornaReproducaoStringHold(List<String> animalStatuses) {
  List<String> orderedStatuses = ["Vazia", "Inseminada", "Prenha"];

  // Definir os status que devem ser agrupados como "Prenha"
  Set<String> prenhaStatuses = {"Inseminada PP", "Prenha", "Seca", "Pré Parto"};

  // Inicializa o mapa para verificar a presença dos status
  Map<String, bool> statusPresence = {
    "Vazia": false,
    "Inseminada": false,
    "Prenha": false
  };

  // Iterar sobre a lista para coletar status únicos mantendo a ordem padrão
  for (String status in animalStatuses) {
    if (prenhaStatuses.contains(status)) {
      status = "Prenha";
    }

    if (statusPresence.containsKey(status)) {
      statusPresence[status] = true;
    }
  }

  // Criar a lista de status únicos seguindo a ordem padrão
  List<String> uniqueStatusList = [];
  for (String status in orderedStatuses) {
    if (statusPresence[status] == true) {
      uniqueStatusList.add(status);
    }
  }

  return uniqueStatusList;
}

List<int> retornaReproducaoQuantidade(List<String> animalStatuses) {
  List<String> orderedStatuses = ["Vazia", "Inseminada", "Prenha"];

  // Inicializa o mapa para contar as ocorrências
  Map<String, int> statusCount = {"Vazia": 0, "Inseminada": 0, "Prenha": 0};

  // Define os status que devem ser agrupados como "Prenha"
  Set<String> prenhaStatuses = {"Inseminada PP", "Prenha", "Seca", "Pré Parto"};

  // Itera sobre a lista e conta os status
  for (String status in animalStatuses) {
    if (prenhaStatuses.contains(status)) {
      statusCount["Prenha"] = statusCount["Prenha"]! + 1;
    } else if (statusCount.containsKey(status)) {
      statusCount[status] = statusCount[status]! + 1;
    }
  }

  // Criar a lista de contagens seguindo a ordem padrão e removendo zeros
  List<int> countList = [];
  for (String status in orderedStatuses) {
    int count = statusCount[status]!;
    if (count > 0) {
      countList.add(count);
    }
  }

  return countList;
}

List<String>? combinarListas(
  List<String>? lista1,
  List<String>? lista2,
) {
  // Inicializa uma lista vazia para combinar os valores
  List<String> listaCombinada = [];

  // Verifica se a primeira lista não é nula e adiciona os seus elementos na lista combinada
  if (lista1 != null) {
    listaCombinada.addAll(lista1);
  }

  // Verifica se a segunda lista não é nula e adiciona os seus elementos na lista combinada
  if (lista2 != null) {
    listaCombinada.addAll(lista2);
  }

  // Ordena a lista combinada em ordem alfabética
  listaCombinada.sort();

  // Retorna a lista combinada
  return listaCombinada;
}

String criarUidRandom() {
  const String chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var random = math.Random();
  var id = List.generate(20, (index) {
    final randomIndex = random.nextInt(chars.length);
    return chars[randomIndex];
  }).join();

  return id;
}

int converterStringToInt(String stringConvert) {
  // Regular expression para encontrar números na string
  RegExp regex = RegExp(r'\d+');
  // Tenta encontrar o primeiro match de número
  Match? match = regex.firstMatch(stringConvert);

  // Se encontrou um número, converte para int e retorna
  if (match != null) {
    return int.parse(match.group(0)!);
  }

  // Se não encontrou, retorna zero ou outro valor padrão
  return 0;
}

List<String>? duasListasEmUma(
  List<String>? listOnline,
  List<String>? listOffline,
) {
  // Se as listas forem null, define como listas vazias
  List<String> list1 = listOnline ?? [];
  List<String> list2 = listOffline ?? [];

  // Une as duas listas e ordena em ordem alfabética
  List<String> unifiedList = [...list1, ...list2];
  unifiedList.sort();

  return unifiedList;
}

List<String> formatAnimalData(
  List<String>? nomeAnimal,
  List<int>? brincoAnimal,
) {
  /// Verifica se ambas as listas não são nulas
  if (nomeAnimal == null || brincoAnimal == null) {
    throw Exception('As listas nomeAnimal e brincoAnimal não podem ser nulas.');
  }

  // Verifica se as listas têm o mesmo tamanho
  if (nomeAnimal.length != brincoAnimal.length) {
    throw Exception(
        'As listas nomeAnimal e brincoAnimal devem ter o mesmo tamanho.');
  }

  // Combina as listas em uma nova lista formatada
  List<String> result = [];
  for (int i = 0; i < nomeAnimal.length; i++) {
    String? nome = nomeAnimal[i];
    int? brinco = brincoAnimal[i];

    if (nome != null && nome.isNotEmpty && brinco != null) {
      result.add('$nome - $brinco');
    } else if (brinco != null) {
      result.add('$brinco');
    } else if (nome != null && nome.isNotEmpty) {
      result.add(nome);
    } else {
      result.add('');
    }
  }
  return result;
}

List<AnimaisProdutoresStruct>? ordenarAnimaisOffline(
    List<AnimaisProdutoresStruct>? listaAnimais) {
  // Verifica se a lista é nula ou vazia
  if (listaAnimais == null || listaAnimais.isEmpty) {
    return listaAnimais; // Retorna a lista sem alterações
  }

  // Ordena a lista pelo brincoAnimal e nomeAnimal
  listaAnimais.sort((a, b) {
    // Comparação pelo brincoAnimal
    final brincoComparison = a.brincoAnimal.compareTo(b.brincoAnimal);

    // Se forem diferentes, usa a comparação do brincoAnimal
    if (brincoComparison != 0) {
      return brincoComparison;
    }

    // Se forem iguais, compara pelo nomeAnimal
    return a.nomeAnimal.compareTo(b.nomeAnimal);
  });

  // Retorna a lista ordenada
  return listaAnimais;
}

int contarDias(String dataString) {
// Converter a string para DateTime
  DateTime dataRecebida = DateTime.parse(
      "${dataString.substring(6, 10)}-${dataString.substring(3, 5)}-${dataString.substring(0, 2)}");

  // Obter a data atual
  DateTime dataAtual = DateTime.now();

  // Calcular a diferença em dias
  Duration diferenca = dataAtual.difference(dataRecebida);

  // Retornar o número de dias
  return diferenca.inDays;
}

DocumentReference getAnimalProdutorUid(
  String uid,
  DocumentReference uidTecnico,
) {
  return uidTecnico.collection('animaisProdutores').doc(uid);
}
