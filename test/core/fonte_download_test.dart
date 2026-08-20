import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/fonte_download.dart';

/// O download decidia sozinho de quem era a sessão, por um critério diferente
/// do usado no login: "existe documento de técnico com este uid?". Um técnico
/// fantasma — criado por um cadastro indevido na conta de um produtor — fazia
/// o download inteiro apontar para um documento vazio, e o produtor entrava
/// sem propriedade e sem rebanho. Aqui o papel já resolvido no login vence.
void main() {
  group('fonteDeDownload', () {
    test('produtor declarado ignora o documento de técnico', () {
      expect(
        fonteDeDownload(ehProdutor: true, temDocumentoDeTecnico: true),
        FonteDeDownload.produtor,
      );
    });

    test('técnico declarado com documento baixa pelo técnico', () {
      expect(
        fonteDeDownload(ehProdutor: false, temDocumentoDeTecnico: true),
        FonteDeDownload.tecnico,
      );
    });

    test('técnico declarado sem documento cai no caminho do produtor', () {
      expect(
        fonteDeDownload(ehProdutor: false, temDocumentoDeTecnico: false),
        FonteDeDownload.produtor,
      );
    });

    test('sem papel informado vale o documento — comportamento antigo', () {
      expect(
        fonteDeDownload(ehProdutor: null, temDocumentoDeTecnico: true),
        FonteDeDownload.tecnico,
      );
      expect(
        fonteDeDownload(ehProdutor: null, temDocumentoDeTecnico: false),
        FonteDeDownload.produtor,
      );
    });
  });
}
