import 'sync_state.dart';

/// Quem a conta E de fato, decidido pelos dados do servidor.
enum PapelResolvido {
  /// Tem propriedade ligada a ela: area do produtor.
  produtor,

  /// Tem TecnicoRecord: painel do tecnico.
  tecnico,

  /// Nem um nem outro: conta nova, segue para o cadastro de tecnico.
  cadastroTecnico,
}

/// [papel] e quem a conta e; [conflita] diz se isso contraria a porta pela qual
/// a pessoa entrou — o login e abortado nesse caso.
typedef DecisaoPosLogin = ({PapelResolvido papel, bool conflita});

/// Decide, a partir do que existe no servidor, quem e a conta — e se isso
/// contraria a tela de login usada.
///
/// Roda ANTES de qualquer download: uma conta de produtor que entrou pela area
/// tecnica nao pode baixar nada, senao o cache local mistura os dois mundos.
DecisaoPosLogin decidirPosLogin({
  required SyncPapel? papelDeclarado,
  required bool temPropriedadeDeProdutor,
  required bool temTecnico,
}) {
  // Uma propriedade ligada a esta pessoa e o sinal mais forte de "produtor", e
  // vence ate um TecnicoRecord existente: e assim que um tecnico fantasma —
  // criado por um cadastro indevido — deixa de sequestrar a conta.
  if (temPropriedadeDeProdutor) {
    return (
      papel: PapelResolvido.produtor,
      conflita: papelDeclarado == SyncPapel.tecnico,
    );
  }

  if (temTecnico) {
    return (
      papel: PapelResolvido.tecnico,
      conflita: papelDeclarado == SyncPapel.produtor,
    );
  }

  // Nem propriedade nem tecnico: nada nos dados desempata, entao vale a porta
  // pela qual a pessoa entrou — e por definicao nao ha conflito com ela.
  return (
    papel: papelDeclarado == SyncPapel.produtor
        ? PapelResolvido.produtor
        : PapelResolvido.cadastroTecnico,
    conflita: false,
  );
}

/// Quem e a conta, resolvido pelo servidor ANTES de qualquer download.
class ResolucaoPapel {
  const ResolucaoPapel({
    required this.papel,
    required this.conflita,
    this.propriedade,
  });

  final PapelResolvido papel;

  /// A porta usada no login contraria o que a conta e. Login abortado.
  final bool conflita;

  /// `PropriedadesRecord?`. Object? para o dominio nao depender do schema do
  /// Firestore, o que quebraria os testes puros. Guardado aqui para o destino
  /// ser montado sem repetir a consulta.
  final Object? propriedade;
}
