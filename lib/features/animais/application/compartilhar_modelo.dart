import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

const _mimeXlsx =
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

/// Copia o modelo (asset) para a pasta temporária e abre o menu de
/// compartilhar do sistema — de lá o técnico salva, manda no WhatsApp ou abre
/// no Excel. [origem] é o retângulo do botão, exigido pelo iPad.
Future<void> compartilharModeloPlanilha({Rect? origem}) async {
  final dados =
      await rootBundle.load('assets/planilhas/modelo_importacao_animais.xlsx');
  final pasta = await getTemporaryDirectory();
  final arquivo = File('${pasta.path}/Modelo importacao de animais.xlsx');
  await arquivo.writeAsBytes(
    dados.buffer.asUint8List(dados.offsetInBytes, dados.lengthInBytes),
    flush: true,
  );
  await SharePlus.instance.share(ShareParams(
    files: [XFile(arquivo.path, mimeType: _mimeXlsx)],
    sharePositionOrigin: origem,
  ));
}
