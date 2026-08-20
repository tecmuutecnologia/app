import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/sincronizacao/domain/decisao_pos_login.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';

void main() {
  group('decidirPosLogin', () {
    test('produtor que entrou pela porta do tecnico vai para a area dele', () {
      final d = decidirPosLogin(
        papelDeclarado: SyncPapel.tecnico,
        temPropriedadeDeProdutor: true,
        temTecnico: false,
      );

      expect(d.papel, PapelResolvido.produtor);
      expect(d.conflita, isTrue);
    });
  
    test('tecnico que entrou pela porta do produtor vai para o dashboard', () {
      final d = decidirPosLogin(
        papelDeclarado: SyncPapel.produtor,
        temPropriedadeDeProdutor: false,
        temTecnico: true,
      );

      expect(d.papel, PapelResolvido.tecnico);
      expect(d.conflita, isTrue);
    });

    test('produtor pela porta certa nao conflita', () {
      final d = decidirPosLogin(
        papelDeclarado: SyncPapel.produtor,
        temPropriedadeDeProdutor: true,
        temTecnico: false,
      );

      expect(d.papel, PapelResolvido.produtor);
      expect(d.conflita, isFalse);
    });

    test('tecnico pela porta certa nao conflita', () {
      final d = decidirPosLogin(
        papelDeclarado: SyncPapel.tecnico,
        temPropriedadeDeProdutor: false,
        temTecnico: true,
      );

      expect(d.papel, PapelResolvido.tecnico);
      expect(d.conflita, isFalse);
    });

    test('a propriedade de produtor vence o tecnico fantasma', () {
      // Caso teste100: um TecnicoRecord espurio criado pelo cadastro indevido
      // nao pode sequestrar quem tem propriedade como produtor.
      final d = decidirPosLogin(
        papelDeclarado: SyncPapel.tecnico,
        temPropriedadeDeProdutor: true,
        temTecnico: true,
      );

      expect(d.papel, PapelResolvido.produtor);
    });

    test('sem propriedade e sem tecnico, o papel declarado decide', () {
      expect(
        decidirPosLogin(
          papelDeclarado: SyncPapel.tecnico,
          temPropriedadeDeProdutor: false,
          temTecnico: false,
        ).papel,
        PapelResolvido.cadastroTecnico,
      );

      expect(
        decidirPosLogin(
          papelDeclarado: SyncPapel.produtor,
          temPropriedadeDeProdutor: false,
          temTecnico: false,
        ).papel,
        PapelResolvido.produtor,
      );
    });

    test('abertura pela rota / (sem papel) nao conflita', () {
      final d = decidirPosLogin(
        papelDeclarado: null,
        temPropriedadeDeProdutor: true,
        temTecnico: false,
      );

      expect(d.papel, PapelResolvido.produtor);
      expect(d.conflita, isFalse);
    });
});
}
