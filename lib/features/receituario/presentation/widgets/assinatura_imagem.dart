import 'dart:io';

import 'package:flutter/material.dart';

import '/core/sync/assinatura_local.dart';
import '/data/objectbox/assinaturas_locais.dart';

/// Imagem da assinatura: cópia do aparelho quando existe (sempre, enquanto
/// não subiu ao Storage), URL quando não.
class AssinaturaImagem extends StatefulWidget {
  const AssinaturaImagem(
    this.referencia, {
    super.key,
    this.width,
    this.height,
  });

  final String referencia;
  final double? width;
  final double? height;

  @override
  State<AssinaturaImagem> createState() => _AssinaturaImagemState();
}

class _AssinaturaImagemState extends State<AssinaturaImagem> {
  Future<File?>? _arquivo;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void didUpdateWidget(covariant AssinaturaImagem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.referencia != widget.referencia) _carregar();
  }

  void _carregar() {
    // Cópia do aparelho primeiro, também para URL (ver AssinaturasLocais).
    _arquivo = AssinaturasLocais.arquivo(widget.referencia);
  }

  @override
  Widget build(BuildContext context) {
    // URL quebrada (assinatura removida do Storage) ou arquivo que sumiu não
    // podem derrubar a tela.
    Widget vazio(_, __, ___) => const SizedBox.shrink();

    return FutureBuilder<File?>(
      future: _arquivo,
      builder: (context, snap) {
        final f = snap.data;
        if (f == null) {
          if (snap.connectionState != ConnectionState.done ||
              ehAssinaturaLocal(widget.referencia)) {
            return SizedBox(width: widget.width, height: widget.height);
          }
          return Image.network(
            widget.referencia,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.contain,
            errorBuilder: vazio,
          );
        }
        return Image.file(
          f,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
          errorBuilder: vazio,
        );
      },
    );
  }
}
