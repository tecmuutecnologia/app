import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Header "hero" do dashboard (reskin baseado em `layout_inspirations/`):
/// gradiente da marca com cantos inferiores arredondados, uma saudação com
/// avatar e pílula de status, e os cards de estatística (brancos) sobrepostos
/// logo abaixo. O gradiente esmaece quando offline.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.email,
    required this.isOnline,
    required this.child,
  });

  final String email;
  final bool isOnline;
  final Widget child;

  List<Color> get _gradient => isOnline
      ? const [Color(0xFFF75E38), Color(0xFFEC3B5B)]
      : const [Color(0xFFF2886E), Color(0xFFE98199)];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradient,
          begin: const AlignmentDirectional(-1.0, -1.0),
          end: const AlignmentDirectional(1.0, 1.0),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28.0),
          bottomRight: Radius.circular(28.0),
        ),
        boxShadow: AppTokens.softShadow(context),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 26.0),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá,',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(),
                                  // ignore: deprecated_member_use
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 13.0,
                                  letterSpacing: 0.0,
                                ),
                      ),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600),
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
                _StatusPill(isOnline: isOnline),
              ],
            ),
            const SizedBox(height: 18.0),
            // Os stat cards são uma lista horizontal; precisa de altura limitada.
            SizedBox(height: 150.0, child: child),
          ],
        ),
      ),
    );
  }
}

/// Pílula translúcida de status (online/offline) no canto do header.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
            color: Colors.white,
            size: 16.0,
          ),
          const SizedBox(width: 5.0),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                  color: Colors.white,
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
