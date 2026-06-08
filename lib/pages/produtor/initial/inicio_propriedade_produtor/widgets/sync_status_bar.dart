import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Widget que exibe o status de sincronização offline/online.
class SyncStatusBar extends StatelessWidget {
  const SyncStatusBar({
    super.key,
    required this.isOnline,
    required this.offlineAnimaisCount,
    required this.editedAnimaisCount,
    required this.offlineActionsCount,
    required this.uidTecnico,
    required this.uidPropriedade,
  });

  final bool isOnline;
  final int offlineAnimaisCount;
  final int editedAnimaisCount;
  final int offlineActionsCount;
  final DocumentReference? uidTecnico;
  final DocumentReference? uidPropriedade;

  bool get hasOfflineData =>
      offlineAnimaisCount > 0 ||
      editedAnimaisCount > 0 ||
      offlineActionsCount > 0;

  @override
  Widget build(BuildContext context) {
    // Sem internet
    if (!isOnline) {
      return _buildNoInternetBar(context);
    }

    // Com internet mas tem dados offline para sincronizar
    if (hasOfflineData) {
      return _buildSyncRequiredBar(context);
    }

    return const SizedBox.shrink();
  }

  Widget _buildNoInternetBar(BuildContext context) {
    return Opacity(
      opacity: 0.0,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              color: Color(0xFFD50000),
              size: 24.0,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
              child: Text(
                'Sem internet! Depois sincronize os dados.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: const Color(0xFFD50000),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncRequiredBar(BuildContext context) {
    return Opacity(
      opacity: 0.0,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Wrap(
          spacing: 0.0,
          runSpacing: 0.0,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.start,
          verticalDirection: VerticalDirection.down,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
              child: Text(
                'Você tem $offlineAnimaisCount novos animais cadastrados, '
                '$editedAnimaisCount animais modificados e '
                '$offlineActionsCount novas ações feitas. '
                'Deseja sincronizá-los agora?',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: const Color(0xFFD50000),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
