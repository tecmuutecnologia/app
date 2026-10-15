import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/assinatura_local.dart';

void main() {
  group('ehAssinaturaLocal', () {
    test('reconhece só a referência local', () {
      expect(ehAssinaturaLocal(referenciaLocal('signature_1.png')), isTrue);
      expect(ehAssinaturaLocal('https://firebasestorage.googleapis.com/x'),
          isFalse);
      expect(ehAssinaturaLocal(null), isFalse);
      expect(ehAssinaturaLocal(''), isFalse);
    });

    test('nomeArquivoLocal desfaz referenciaLocal', () {
      expect(nomeArquivoLocal(referenciaLocal('signature_1.png')),
          'signature_1.png');
    });
  });

  group('assinaturaAposDownload', () {
    const local = 'local:signature_1.png';
    const url = 'https://firebasestorage.googleapis.com/assinatura.png';

    test('eco da subida sem assinatura não apaga a local', () {
      expect(assinaturaAposDownload(local: local, baixada: null), local);
      expect(assinaturaAposDownload(local: local, baixada: ''), local);
    });

    test('URL de verdade do servidor substitui a local', () {
      expect(assinaturaAposDownload(local: local, baixada: url), url);
    });

    test('sem assinatura local, vale o que veio do servidor', () {
      expect(assinaturaAposDownload(local: null, baixada: url), url);
      expect(assinaturaAposDownload(local: url, baixada: null), isNull);
    });
  });

  group('nomeArquivoDaUrl', () {
    test('extrai o nome do objeto da URL de download do Storage', () {
      expect(
        nomeArquivoDaUrl(
            'https://firebasestorage.googleapis.com/v0/b/x.appspot.com'
            '/o/users%2FNSKd%2Fuploads%2Fsignature_1792035225882852.png'
            '?alt=media&token=5444460c'),
        'signature_1792035225882852.png',
      );
    });

    test('URL sem nome de imagem não vira chave', () {
      expect(nomeArquivoDaUrl('https://exemplo.com/'), isNull);
      expect(nomeArquivoDaUrl('https://exemplo.com/o/..%2F..%2Fetc'), isNull);
    });
  });
}
