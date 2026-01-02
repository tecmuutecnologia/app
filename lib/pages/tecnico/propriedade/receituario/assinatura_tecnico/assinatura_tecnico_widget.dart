import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature/signature.dart';
import 'assinatura_tecnico_model.dart';
export 'assinatura_tecnico_model.dart';

class AssinaturaTecnicoWidget extends StatefulWidget {
  const AssinaturaTecnicoWidget({
    super.key,
    required this.uidResumoVisita,
  });

  final DocumentReference? uidResumoVisita;

  @override
  State<AssinaturaTecnicoWidget> createState() =>
      _AssinaturaTecnicoWidgetState();
}

class _AssinaturaTecnicoWidgetState extends State<AssinaturaTecnicoWidget> {
  late AssinaturaTecnicoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssinaturaTecnicoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRect(
            child: Signature(
              controller: _model.assTecnicoController ??= SignatureController(
                penStrokeWidth: 2.0,
                penColor: FlutterFlowTheme.of(context).primaryText,
                exportBackgroundColor: Colors.white,
              ),
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              height: 120.0,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: FFButtonWidget(
              onPressed: () async {
                final signatureImage =
                    await _model.assTecnicoController!.toPngBytes(height: 120);
                if (signatureImage == null) {
                  showUploadMessage(
                    context,
                    'Arquivo vazio. Por favor, envie uma assinatura válida.',
                  );
                  return;
                }
                showUploadMessage(
                  context,
                  'Seus dados estão sendo enviados...',
                  showLoading: true,
                );
                final downloadUrl = (await uploadData(
                    getSignatureStoragePath(), signatureImage));

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                if (downloadUrl != null) {
                  safeSetState(() => _model.uploadedSignatureUrl = downloadUrl);
                  showUploadMessage(
                    context,
                    'Sucesso!',
                  );
                } else {
                  showUploadMessage(
                    context,
                    'Envio de dados falhou. Por favor, tente novamente.',
                  );
                  return;
                }

                if (_model.uploadedSignatureUrl != '') {
                  await widget.uidResumoVisita!
                      .update(createResumoDaVisitaRecordData(
                    assinaturaTecnico: _model.uploadedSignatureUrl,
                  ));
                  Navigator.pop(context);
                  return;
                } else {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text('Informe uma assinatura.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
              },
              text: 'Assinar',
              icon: Icon(
                Icons.assignment,
                size: 22.0,
              ),
              options: FFButtonOptions(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 40.0,
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Color(0xFFBE6740),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                elevation: 3.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: FFButtonWidget(
              onPressed: () async {
                Navigator.pop(context);
              },
              text: 'Cancelar',
              options: FFButtonOptions(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 40.0,
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Color(0xFFB3B5B9),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                elevation: 3.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
