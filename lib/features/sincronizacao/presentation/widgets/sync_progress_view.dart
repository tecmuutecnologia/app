import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/sync/sync_etapa.dart';
import '../../domain/sync_state.dart';

/// Etapas com linha propria na checklist.
///
/// `usuario` e `tecnico` ficam de fora: sao um documento cada e a linha
/// piscaria. As duas sao cobertas pela linha de `referencias`.
const List<SyncEtapa> linhasVisiveis = [
  SyncEtapa.referencias,
  SyncEtapa.produtores,
  SyncEtapa.propriedades,
  SyncEtapa.animais,
  SyncEtapa.acoes,
  SyncEtapa.financeiro,
];

String rotuloLinha(SyncEtapa etapa) => switch (etapa) {
      SyncEtapa.referencias ||
      SyncEtapa.usuario ||
      SyncEtapa.tecnico =>
        'Tabelas de referência',
      SyncEtapa.produtores => 'Produtores',
      SyncEtapa.propriedades => 'Propriedades',
      SyncEtapa.animais => 'Animais',
      SyncEtapa.acoes => 'Ações e tratamentos',
      SyncEtapa.financeiro => 'Financeiro e visitas',
    };

/// Linha da checklist que representa esta etapa. `usuario` e `tecnico` nao tem
/// linha propria — sao cobertas pela linha de `referencias`.
SyncEtapa linhaDaEtapa(SyncEtapa etapa) => switch (etapa) {
      SyncEtapa.referencias ||
      SyncEtapa.usuario ||
      SyncEtapa.tecnico =>
        SyncEtapa.referencias,
      SyncEtapa.produtores => SyncEtapa.produtores,
      SyncEtapa.propriedades => SyncEtapa.propriedades,
      SyncEtapa.animais => SyncEtapa.animais,
      SyncEtapa.acoes => SyncEtapa.acoes,
      SyncEtapa.financeiro => SyncEtapa.financeiro,
    };

/// Separador de milhar em pt-BR sem depender de `intl`.
String _milhar(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

class SyncProgressView extends StatelessWidget {
  const SyncProgressView({
    super.key,
    required this.estado,
    required this.onTentarNovamente,
    required this.onContinuarAssimMesmo,
  });

  final SyncState estado;
  final VoidCallback onTentarNovamente;
  final VoidCallback onContinuarAssimMesmo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(0.87, -1.0),
          end: AlignmentDirectional(-0.87, 1.0),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: switch (estado) {
              final SyncErro e => _erro(context, e),
              final SyncBaixando e => _baixando(context, e),
              SyncPreparando() => _preparando(context),
              // A page navega assim que o estado vira concluido; manter a tela
              // de preparo evita um flash de layout durante a transicao.
              SyncConcluido() => _preparando(context),
            },
          ),
        ),
      ),
    );
  }

  Widget _vaca() => Lottie.asset(
        'assets/jsons/animation_lmv2wwnc.json',
        width: 190.0,
        height: 160.0,
        fit: BoxFit.contain,
        animate: true,
        errorBuilder: (_, __, ___) => const SizedBox(height: 160),
      );

  Widget _preparando(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _vaca(),
          const SizedBox(height: 16),
          const Text(
            'Preparando seus dados',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ],
      );

  Widget _baixando(BuildContext context, SyncBaixando e) {
    final detalhes = <String>[];
    if (e.temContador) {
      detalhes.add('${_milhar(e.atual!)} de ${_milhar(e.total!)}');
      if (e.ritmo != null) detalhes.add('~${e.ritmo!.round()}/s');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _vaca(),
        const SizedBox(height: 16),
        const Text(
          'Preparando seus dados',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: e.progresso,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${(e.progresso * 100).round()}%',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          e.rotulo,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        if (detalhes.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            detalhes.join(' · '),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
        if (e.eta != null) ...[
          const SizedBox(height: 2),
          Text(
            'Restam ~${e.eta!.inSeconds}s',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
        const SizedBox(height: 24),
        ...linhasVisiveis.map((linha) => _linha(linha, e.etapa)),
      ],
    );
  }

  Widget _linha(SyncEtapa linha, SyncEtapa atual) {
    final indiceLinha = linhasVisiveis.indexOf(linha);
    final indiceAtual = linhasVisiveis.indexOf(linhaDaEtapa(atual));

    final (icone, cor) = switch (indiceLinha.compareTo(indiceAtual)) {
      < 0 => (Icons.check_circle, Colors.white),
      0 => (Icons.radio_button_checked, Colors.white),
      _ => (Icons.radio_button_unchecked, Colors.white38),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icone, size: 16, color: cor),
          const SizedBox(width: 8),
          Text(
            rotuloLinha(linha),
            style: TextStyle(color: cor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _erro(BuildContext context, SyncErro e) {
    final titulo = e.tipo == SyncErroTipo.semConexao
        ? 'Sem conexão'
        : 'Não foi possível concluir a sincronização';

    final explicacao = e.tipo == SyncErroTipo.semConexao
        ? 'A primeira sincronização precisa de internet. Conecte-se e tente de novo.'
        : e.etapa != null
            ? 'Falhou ao baixar: ${rotuloLinha(e.etapa!)}.'
            : 'Algo deu errado durante a sincronização.';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          e.tipo == SyncErroTipo.semConexao
              ? Icons.cloud_off
              : Icons.error_outline,
          size: 56,
          color: Colors.white,
        ),
        const SizedBox(height: 16),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          explicacao,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            textTheme: Typography.whiteMountainView,
          ),
          child: ExpansionTile(
            iconColor: Colors.white70,
            collapsedIconColor: Colors.white70,
            title: const Text(
              'Detalhes técnicos',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            children: [
              Text(
                e.mensagem,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onTentarNovamente,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFF75E38),
            minimumSize: const Size(double.infinity, 44),
          ),
          child: const Text('Tentar novamente'),
        ),
        if (e.podeContinuarAssimMesmo) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: onContinuarAssimMesmo,
            child: const Text(
              'Continuar assim mesmo',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Você poderá sincronizar depois; nada será perdido.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
