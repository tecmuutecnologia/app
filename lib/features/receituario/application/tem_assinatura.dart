/// `true` quando há uma URL de assinatura para exibir.
///
/// A tela do receituário testava `assinatura != ''`. Campo NULO passa nesse
/// teste, e o `Image.network('')` seguinte lançava
/// `Invalid argument(s): No host specified in URI file:///` ao abrir a tela.
bool temAssinatura(String? url) => (url ?? '').trim().isNotEmpty;
