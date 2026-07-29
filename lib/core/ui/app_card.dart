import 'package:flutter/material.dart';

import '/app/theme/flutter_flow_theme.dart';

/// Tokens do design-system (reskin baseado em `layout_inspirations/`): cards
/// brancos com cantos arredondados e sombra suave (em vez de borda dura),
/// espaçamento generoso. As CORES seguem o tema atual do app (laranja/vermelho)
/// — estes tokens só padronizam forma/elevação/raio.
class AppTokens {
  AppTokens._();

  /// Cor da marca (primária) — laranja do app.
  static const Color brand = Color(0xFFF75E38);

  /// Cor SECUNDÁRIA de acento — roxo. Complementa o laranja sem substituí-lo
  /// (usar em ícones/badges/ações secundárias para dar variedade visual).
  static const Color secondary = Color(0xFF7B61FF);

  /// Versão translúcida do acento secundário (fundo de avatar/chip).
  static const Color secondaryTint = Color(0x1A7B61FF);

  // --- Acentos funcionais -------------------------------------------------
  //
  // Estas três cores não são "variedade visual": elas dividem uma grade de
  // ações em zonas que se reconhecem de longe. Cor que não carrega informação
  // é ruído, e com 16 itens iguais na tela o ruído é caro.
  //
  // A paleta sai do mundo do próprio usuário — pasto, ardósia, ferramenta — e
  // não de uma rampa genérica de SaaS.

  /// Trabalho no rebanho: o animal vivo. Verde-pasto.
  static const Color rebanho = Color(0xFF1E7A55);

  /// Papel e número: relatório, receituário, calendário, financeiro.
  /// Azul-ardósia, deliberadamente frio para separar do verde.
  static const Color relatorio = Color(0xFF2E5F8A);

  /// Sair desta tela. Grafite dessaturado — é uma saída, não uma ação sobre o
  /// rebanho, e por isso fala mais baixo que as outras duas.
  static const Color navegacao = Color(0xFF5A6672);

  /// Laranja da marca em tom profundo, para superfícies sólidas com texto
  /// branco em cima. O brand puro (#F75E38) com texto branco dá contraste
  /// 3.2:1 e reprova em AA; este dá 5.2:1.
  static const Color brandDeep = Color(0xFFC2410C);

  /// Versão translúcida da marca (fundo de avatar/chip, splash de toque).
  static const Color brandTint = Color(0x1AF75E38);

  /// Marca ainda mais diluída — usada no highlight de toque, que fica na tela
  /// enquanto o dedo está pressionado e por isso precisa ser mais discreto
  /// que o splash.
  static const Color brandTintSoft = Color(0x0DF75E38);

  /// Fio de contorno na cor da marca. A sombra difusa some num LCD sob sol
  /// forte (o app é usado a campo); a hairline garante que a borda do alvo de
  /// toque continue legível nessa condição.
  static const Color brandHairline = Color(0x24F75E38);

  /// Fundo de página das telas cujos cards têm acento laranja. É um off-white
  /// QUENTE de propósito: o `primaryBackground` do tema (#F1F4F8) é um cinza
  /// azulado, e sob ele o halo laranja dos cards lê como sujeira. Card branco
  /// sobre página branca não lê como card nenhum — precisa de chão.
  static Color canvas(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? FlutterFlowTheme.of(context).primaryBackground
          : const Color(0xFFF7F4F1);

  /// Raio padrão dos cards/superfícies.
  static const double radius = 16.0;

  /// Raio menor (chips, inputs internos).
  static const double radiusSmall = 12.0;

  /// Padding interno padrão de um card.
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);

  /// Sombra suave padrão (substitui as bordas 2px duras do layout FlutterFlow).
  static List<BoxShadow> softShadow(BuildContext context) => const [
        BoxShadow(
          color: Color(0x14000000), // ~8% preto
          blurRadius: 16.0,
          offset: Offset(0.0, 6.0),
        ),
      ];

  /// Sombra "quente" dos cards de ação: um halo laranja difuso (a marca
  /// iluminando o card por baixo) apoiado numa sombra de contato neutra e
  /// curta. Duas camadas — ambiente larga + contato curta — leem como volume
  /// real; um blur único só borra o card.
  ///
  /// A hairline entra aqui como sombra de spread 1px e blur zero, e não como
  /// `border` do BoxDecoration, de propósito: `border` recuaria o conteúdo em
  /// 1px de cada lado, e os cards com badge já usam a altura de 120px inteira.
  /// Como sombra ela é pintada FORA da caixa e não custa layout nenhum.
  static List<BoxShadow> brandShadow(BuildContext context) => const [
        BoxShadow(
          color: brandHairline, // o fio de contorno
          spreadRadius: 1.0,
          blurRadius: 0.0,
        ),
        BoxShadow(
          color: Color(0x1FF75E38), // ~12% laranja — o halo
          blurRadius: 14.0,
          offset: Offset(0.0, 4.0),
        ),
        BoxShadow(
          color: Color(0x0F000000), // ~6% preto — o contato
          blurRadius: 3.0,
          offset: Offset(0.0, 1.0),
        ),
      ];
}

/// "Tile" quadrado-arredondado com o ícone tonalizado — base visual dos cards
/// de menu e de estatística (reskin). O fundo é uma versão translúcida do
/// [accent]; o ícone usa o [accent] cheio.
class MenuIconTile extends StatelessWidget {
  const MenuIconTile({
    super.key,
    required this.icon,
    this.accent = AppTokens.brand,
    this.iconSize = 26.0,
    this.size = 48.0,
  });

  final IconData icon;
  final Color accent;
  final double iconSize;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Icon(icon, color: accent, size: iconSize),
    );
  }
}

/// Card branco arredondado com sombra suave — superfície base do reskin.
/// Reutilizável em todas as telas (lista de stats, seções, linhas de menu).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppTokens.cardPadding,
    this.onTap,
    this.width,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color ?? FlutterFlowTheme.of(context).secondaryBackground,
      borderRadius: BorderRadius.circular(AppTokens.radius),
      boxShadow: AppTokens.softShadow(context),
    );

    final content = Padding(padding: padding, child: child);

    return Container(
      width: width,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppTokens.radius),
                child: content,
              ),
            ),
    );
  }
}
