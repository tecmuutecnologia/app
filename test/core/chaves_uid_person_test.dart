import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/chaves_uid_person.dart';

/// `uidPerson` foi gravado ora com o uid do Auth, ora com o id do documento
/// `person`. Enquanto existir documento das duas épocas, a consulta precisa
/// aceitar os dois valores — sem repetir o mesmo valor no `whereIn`, que o
/// Firestore rejeita.
void main() {
  group('chavesUidPerson', () {
    test('valores diferentes viram duas chaves', () {
      expect(
        chavesUidPerson(authUid: 'uid1', personDocId: 'doc1'),
        ['uid1', 'doc1'],
      );
    });

    test('person/{uid} não duplica a chave', () {
      expect(chavesUidPerson(authUid: 'uid1', personDocId: 'uid1'), ['uid1']);
    });

    test('sem person local resta o uid do Auth', () {
      expect(chavesUidPerson(authUid: 'uid1', personDocId: null), ['uid1']);
    });

    test('person doc id vazio não vira chave', () {
      expect(chavesUidPerson(authUid: 'uid1', personDocId: ''), ['uid1']);
    });
  });
}
