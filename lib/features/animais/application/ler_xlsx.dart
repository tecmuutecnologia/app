import 'dart:typed_data';

import 'package:excel/excel.dart';

/// Lê a primeira aba do .xlsx como linhas de valores simples. Texto (e datas,
/// que o pacote entrega como texto ISO) vira String; números ficam como estão.
List<List<Object?>> lerXlsx(Uint8List bytes) {
  final Excel excel;
  try {
    excel = Excel.decodeBytes(bytes);
  } catch (_) {
    throw const FormatException('Arquivo não é uma planilha .xlsx válida.');
  }
  if (excel.tables.isEmpty) {
    throw const FormatException('Arquivo não é uma planilha .xlsx válida.');
  }
  final aba = excel.tables.values.first;
  return [
    for (final linha in aba.rows)
      [
        for (final cell in linha)
          switch (cell?.value) {
            null => null,
            final SharedString s => s.toString(),
            final int n => n,
            final double n => n,
            final v => v.toString(),
          }
      ]
  ];
}
