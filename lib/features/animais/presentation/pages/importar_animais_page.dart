import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/connectivity/connectivity_service.dart';
import '/core/ui/app_card.dart';
import '/core/ui/cabecalho_tela.dart';
import '/core/ui/confirmar_acao.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/core/ui/secao_formulario.dart';
import '/data/backend.dart';
import '/data/objectbox/repositories/index.dart';
import '/domain/animais/importacao/planilha_animais.dart';
import '/domain/plano/vagas.dart';
import '/features/animais/application/compartilhar_modelo.dart';
import '/features/animais/application/importar_animais.dart';
import '/features/animais/application/ler_xlsx.dart';
import '/features/animais/presentation/widgets/resultado_importacao_view.dart';

/// Importação de animais por planilha (spec §5): baixar o modelo, escolher o
/// .xlsx preenchido, pré-analisar, avisar sobre vagas, gravar e mostrar o
/// resultado. Só o técnico chega aqui (botão da lista de animais).
class ImportarAnimaisPage extends StatefulWidget {
  const ImportarAnimaisPage({
    super.key,
    required this.uidPropriedade,
    required this.uidTecnico,
  });

  final DocumentReference? uidPropriedade;
  final DocumentReference? uidTecnico;

  static String routeName = 'importarAnimais';
  static String routePath = '/importarAnimais';

  @override
  State<ImportarAnimaisPage> createState() => _ImportarAnimaisPageState();
}

class _ImportarAnimaisPageState extends State<ImportarAnimaisPage> {
  StreamSubscription<bool>? _conectividadeSub;
  bool _online = true;

  bool _lendo = false;
  bool _compartilhando = false;

  /// Não nulo enquanto grava: (feitos, total).
  (int, int)? _progresso;
  ResultadoImportacao? _resultado;

  @override
  void initState() {
    super.initState();
    _online = ConnectivityService.instance.isOnline;
    _conectividadeSub = ConnectivityService.instance.onStatusChange
        .listen((online) => safeSetState(() => _online = online));
  }

  @override
  void dispose() {
    _conectividadeSub?.cancel();
    super.dispose();
  }

  Future<void> _baixarModelo(Rect? origem) async {
    setState(() => _compartilhando = true);
    try {
      await compartilharModeloPlanilha(origem: origem);
    } catch (_) {
      if (mounted) showSnackbar(context, 'Não foi possível abrir a planilha.');
    } finally {
      safeSetState(() => _compartilhando = false);
    }
  }

  Future<void> _importar() async {
    setState(() => _lendo = true);
    try {
      final escolha = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );
      final bytes = escolha?.files.single.bytes;
      if (bytes == null || !mounted) return; // cancelou

      final List<List<Object?>> linhas;
      try {
        linhas = lerXlsx(bytes);
      } on FormatException catch (e) {
        return await _avisar(e.message);
      }
      if (linhas.isEmpty) return await _avisar('A planilha não tem animais.');
      final erro = erroDeCabecalho(linhas.first);
      if (erro != null) return await _avisar(erro);

      final referencias = ReferenciaRepository();
      final lidas = lerLinhas(
        linhas,
        racas: referencias.racas(),
        grupos: referencias.grupos(),
        status: referencias.statusAnimais(),
        hoje: DateTime.now(),
      );
      if (lidas.isEmpty) return await _avisar('A planilha não tem animais.');

      final analise = analisarImportacao(
        lidas,
        jaExiste: jaExisteNaPropriedade(widget.uidPropriedade!.path),
      );
      if (analise.validas.isEmpty) {
        safeSetState(() => _resultado =
            ResultadoImportacao(importados: 0, recusadas: analise.recusadas));
        return;
      }
      await _gravar(analise);
    } finally {
      safeSetState(() => _lendo = false);
    }
  }

  Future<void> _gravar(AnaliseImportacao analise) async {
    final tecnicoId = widget.uidTecnico!.id;
    final restante =
        TecnicoRepository().getByFirestoreId(tecnicoId)?.restanteLimiteAnimais;
    final validos = analise.validas.length;
    final cabem = quantosCabem(restante: restante, validos: validos);
    if (cabem == 0) {
      return await _avisar('Sua conta não tem vagas para novos animais.');
    }
    if (cabem < validos) {
      final seguir = await confirmarAcao(
        context,
        titulo: 'Limite do plano',
        mensagem: 'Sua conta permite mais $cabem animais e a planilha tem '
            '$validos válidos. Os ${validos - cabem} últimos ficarão de fora.',
        textoConfirmar: 'Importar os $cabem',
      );
      if (!seguir || !mounted) return;
    }

    setState(() => _progresso = (0, cabem));
    final resultado = await importarAnimais(
      analise,
      uidPropriedade: widget.uidPropriedade!,
      tecnicoFirestoreId: tecnicoId,
      restante: restante,
      aoProgredir: (feitos, total) =>
          safeSetState(() => _progresso = (feitos, total)),
    );
    safeSetState(() {
      _progresso = null;
      _resultado = resultado;
    });
  }

  Future<void> _avisar(String mensagem) => showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final resultado = _resultado;
    final progresso = _progresso;
    return PopScope(
      // Sair no meio deixaria a cota sem débito: a tela trava até terminar.
      canPop: progresso == null,
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: CabecalhoTela(
          titulo: 'Importar animais',
          online: _online,
          aoVoltar: progresso == null ? null : () {},
        ),
        body: SafeArea(
          top: false,
          child: resultado != null
              ? ResultadoImportacaoView(
                  resultado: resultado,
                  aoVoltar: () => context.safePop(),
                )
              : progresso != null
                  ? _Progresso(feitos: progresso.$1, total: progresso.$2)
                  : _Inicio(
                      ocupado: _lendo || _compartilhando,
                      aoBaixar: _baixarModelo,
                      aoImportar: _importar,
                    ),
        ),
      ),
    );
  }
}

/// Os dois cartões: baixar o modelo e importar a planilha preenchida.
class _Inicio extends StatelessWidget {
  const _Inicio({
    required this.ocupado,
    required this.aoBaixar,
    required this.aoImportar,
  });

  final bool ocupado;
  final void Function(Rect? origem) aoBaixar;
  final VoidCallback aoImportar;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      children: [
        SecaoFormulario(
          icone: Icons.download_outlined,
          titulo: 'Baixar planilha padrão',
          ajuda: 'Preencha um animal por linha, sem mudar a ordem das colunas.',
          filhos: [
            Builder(
              builder: (botaoContext) => _BotaoCartao(
                texto: 'Baixar planilha padrão',
                icone: Icons.download_outlined,
                aoTocar:
                    ocupado ? null : () => aoBaixar(_retangulo(botaoContext)),
              ),
            ),
          ],
        ),
        SecaoFormulario(
          icone: Icons.upload_file_outlined,
          titulo: 'Importar planilha',
          ajuda: 'Escolha a planilha .xlsx preenchida.',
          filhos: [
            _BotaoCartao(
              texto: 'Importar planilha',
              icone: Icons.upload_file_outlined,
              aoTocar: ocupado ? null : aoImportar,
            ),
          ],
        ),
      ],
    );
  }

  /// Posição do botão na tela: o iPad ancora o menu de compartilhar nela.
  static Rect? _retangulo(BuildContext context) {
    final caixa = context.findRenderObject() as RenderBox?;
    if (caixa == null || !caixa.hasSize) return null;
    return caixa.localToGlobal(Offset.zero) & caixa.size;
  }
}

class _BotaoCartao extends StatelessWidget {
  const _BotaoCartao({
    required this.texto,
    required this.icone,
    required this.aoTocar,
  });

  final String texto;
  final IconData icone;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return FFButtonWidget(
      onPressed: aoTocar,
      text: texto,
      icon: Icon(icone, size: 20.0),
      options: FFButtonOptions(
        width: double.infinity,
        height: 44.0,
        padding: EdgeInsets.zero,
        iconPadding: EdgeInsets.zero,
        color: AppTokens.brand,
        textStyle: GoogleFonts.readexPro(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600),
        elevation: 0.0,
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10.0),
        disabledColor: tema.alternate,
        disabledTextColor: tema.secondaryText,
      ),
    );
  }
}

/// Barra "n de total" enquanto grava.
class _Progresso extends StatelessWidget {
  const _Progresso({required this.feitos, required this.total});

  final int feitos;
  final int total;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      children: [
        SecaoFormulario(
          icone: Icons.hourglass_top_rounded,
          titulo: 'Importando animais',
          ajuda: 'Não feche esta tela até terminar.',
          filhos: [
            LinearProgressIndicator(
              value: total == 0 ? null : feitos / total,
              color: AppTokens.brand,
              backgroundColor: AppTokens.brandTint,
              minHeight: 6.0,
              borderRadius: BorderRadius.circular(3.0),
            ),
            Text(
              '$feitos de $total',
              textAlign: TextAlign.center,
              style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  color: FlutterFlowTheme.of(context).primaryText),
            ),
          ],
        ),
      ],
    );
  }
}
