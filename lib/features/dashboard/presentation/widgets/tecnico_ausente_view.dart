import 'package:flutter/material.dart';

/// Tela para o tecnico autenticado cujo cadastro nao esta no cache local.
///
/// O dashboard le o tecnico do ObjectBox. Quando ele falta, a tela nao tem o
/// que montar — e antes disso ela devolvia um `Container()` vazio, que pintava
/// a tela inteira de preto sem uma linha de log. Um estado invisivel e
/// indistinguivel de um travamento, tanto para quem usa quanto para quem
/// depura.
///
/// A saida oferecida e sair da conta porque e a unica que recupera de fato: o
/// logout limpa as marcas de sincronizacao, e so entao o proximo login volta a
/// fazer o download completo que traz o documento do tecnico. Um "tentar
/// novamente" ali rodaria zero etapas — o download retoma por checkpoint, e
/// todas ja estao marcadas como concluidas.
class TecnicoAusenteView extends StatelessWidget {
  const TecnicoAusenteView({super.key, required this.onSair});

  final VoidCallback onSair;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_off_outlined,
                size: 56.0, color: Color(0xFFF75E38)),
            const SizedBox(height: 20.0),
            const Text(
              'Cadastro não encontrado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Seu cadastro de técnico não está salvo neste aparelho. '
              'Entre na conta de novo para baixar seus dados.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, height: 1.4),
            ),
            const SizedBox(height: 28.0),
            FilledButton(
              onPressed: onSair,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF75E38),
                minimumSize: const Size(double.infinity, 52.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              child: const Text('Sair e entrar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
