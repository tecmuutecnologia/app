// ignore_for_file: unnecessary_null_comparison, unnecessary_null_in_if_null_operators, unnecessary_non_null_assertion, invalid_null_aware_operator
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/ui/app_card.dart';
import '/data/backend.dart';
import '/core/ui/flutter_flow_icon_button.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/flutter_flow_util.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/features/propriedades/presentation/pages/propriedades_excluidas_page.dart';
import '/features/dashboard/presentation/pages/dashboard_tecnico_page.dart';
import '/features/propriedades/presentation/pages/inicio_propriedade_page.dart';
import '/features/propriedades/presentation/pages/editar_propriedade_page.dart';
import '/features/propriedades/presentation/pages/nova_propriedade_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListaPropriedadePage extends StatefulWidget {
  const ListaPropriedadePage({
    super.key,
    required this.visitaPresencial,
  });

  final bool? visitaPresencial;

  static String routeName = 'listaPropriedade';
  static String routePath = '/listaPropriedade';

  @override
  State<ListaPropriedadePage> createState() => _ListaPropriedadePageState();
}

class _ListaPropriedadePageState extends State<ListaPropriedadePage> {
  late TextEditingController _searchController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  Widget _p1(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 50.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed(DashboardTecnicoPage.routeName);
            },
          ),
        ),
        Text(
          'Propriedades',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
                fontWeight:
                    FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle:
                    FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
        ),
      ],
    );
  }

  Widget _p2(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: TextFormField(
        controller: _searchController,
        onChanged: (_) => safeSetState(() {}),
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Pesquisar propriedade',
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTokens.secondary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? InkWell(
                  onTap: () => safeSetState(() {
                    _searchController?.clear();
                  }),
                  child: Icon(
                    Icons.clear,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 18.0,
                  ),
                )
              : null,
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.readexPro(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        maxLines: 1,
        validator: _searchController == null ? null : (value) => null,
      ),
    );
  }

  Widget _p3(BuildContext context, dynamic listaPropriedadeTecnicoRecord) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _p5(context, listaPropriedadeTecnicoRecord),
      ],
    );
  }

  Widget _p4(BuildContext context, dynamic listaPropriedadeTecnicoRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            child: FFButtonWidget(
              onPressed: () async {
                context.pushNamed(
                  PropriedadesExcluiasPage.routeName,
                  queryParameters: {
                    'visitaPresencial': serializeParam(
                      widget.visitaPresencial,
                      ParamType.bool,
                    ),
                    'uidTecnico': serializeParam(
                      listaPropriedadeTecnicoRecord?.reference,
                      ParamType.DocumentReference,
                    ),
                  }.withoutNulls,
                );
              },
              text: '',
              icon: Icon(
                Icons.delete_outline,
                size: 32.0,
              ),
              options: FFButtonOptions(
                width: 65.0,
                height: 65.0,
                padding: EdgeInsets.all(0.0),
                iconPadding:
                    EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                color: Color(0xFFA8A8A8),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 45.0,
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
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(1.0, 1.0),
            child: FFButtonWidget(
              onPressed: () async {
                if (listaPropriedadeTecnicoRecord!.restanteLimiteProdutores >
                    0) {
                  context.pushNamed(
                    NovaPropriedadePage.routeName,
                    queryParameters: {
                      'visitaPresencial': serializeParam(
                        widget.visitaPresencial,
                        ParamType.bool,
                      ),
                      'uidTecnico': serializeParam(
                        listaPropriedadeTecnicoRecord.reference,
                        ParamType.DocumentReference,
                      ),
                      'email': serializeParam(
                        currentUserEmail,
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );

                  return;
                } else {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text('Limite propriedades atingida.'),
                        content: Text(
                            'Contrate um novo plano ou elimine alguma propriedade.'),
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
              text: '',
              icon: Icon(
                Icons.add_rounded,
                size: 35.0,
              ),
              options: FFButtonOptions(
                width: 65.0,
                height: 65.0,
                padding: EdgeInsets.all(0.0),
                iconPadding:
                    EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                color: Color(0xFFEC3B5B),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 45.0,
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
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _p5(BuildContext context, dynamic listaPropriedadeTecnicoRecord) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
        child: StreamBuilder<List<PropriedadesRecord>>(
          stream: queryPropriedadesRecord(
            parent: listaPropriedadeTecnicoRecord?.reference,
            queryBuilder: (propriedadesRecord) =>
                propriedadesRecord.orderBy('display_name'),
          ),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFF75E38),
                    ),
                  ),
                ),
              );
            }
            List<PropriedadesRecord> listViewPropriedadesRecordList =
                snapshot.data!;

            // Filter out deleted properties
            listViewPropriedadesRecordList = listViewPropriedadesRecordList
                .where((property) => !property.isDeleted)
                .toList();

            // Filter properties based on search query
            final searchQuery = _searchController.text.toLowerCase();
            if (searchQuery.isNotEmpty) {
              listViewPropriedadesRecordList = listViewPropriedadesRecordList
                  .where((property) =>
                      property.displayName.toLowerCase().contains(searchQuery))
                  .toList();
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: listViewPropriedadesRecordList.isEmpty &&
                      searchQuery.isNotEmpty
                  ? 1
                  : listViewPropriedadesRecordList.length,
              itemBuilder: (context, listViewIndex) {
                if (listViewPropriedadesRecordList.isEmpty &&
                    searchQuery.isNotEmpty) {
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
                    child: Center(
                      child: Text(
                        'Nenhuma propriedade encontrada com "$searchQuery"',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  );
                }
                final listViewPropriedadesRecord =
                    listViewPropriedadesRecordList[listViewIndex];
                return Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 10.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(
                        InicioPropriedadePage.routeName,
                        queryParameters: {
                          'nomePropriedade': serializeParam(
                            listViewPropriedadesRecord.displayName,
                            ParamType.String,
                          ),
                          'uidPropriedade': serializeParam(
                            listViewPropriedadesRecord.reference,
                            ParamType.DocumentReference,
                          ),
                          'uidTecnico': serializeParam(
                            listaPropriedadeTecnicoRecord?.reference,
                            ParamType.DocumentReference,
                          ),
                          'emailPropriedade': serializeParam(
                            listViewPropriedadesRecord.email,
                            ParamType.String,
                          ),
                          'visitaPresencial': serializeParam(
                            widget.visitaPresencial,
                            ParamType.bool,
                          ),
                          'diasDg': serializeParam(
                            listViewPropriedadesRecord.diasParaDg,
                            ParamType.String,
                          ),
                        }.withoutNulls,
                      );
                    },
                    onDoubleTap: () async {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('Segure pressionado para editar.'),
                            content: Text(
                                'Atualize as informações segurando pressionado.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext),
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onLongPress: () async {
                      context.pushNamed(
                        EditarPropriedadePage.routeName,
                        queryParameters: {
                          'uidPropriedade': serializeParam(
                            listViewPropriedadesRecord.reference,
                            ParamType.DocumentReference,
                          ),
                          'nomePropriedade': serializeParam(
                            listViewPropriedadesRecord.displayName,
                            ParamType.String,
                          ),
                          'uidTecnico': serializeParam(
                            listaPropriedadeTecnicoRecord?.reference,
                            ParamType.DocumentReference,
                          ),
                          'emailPropriedade': serializeParam(
                            listViewPropriedadesRecord.email,
                            ParamType.String,
                          ),
                          'visitaPresencial': serializeParam(
                            widget.visitaPresencial,
                            ParamType.bool,
                          ),
                          'emailTecnico': serializeParam(
                            currentUserEmail,
                            ParamType.String,
                          ),
                        }.withoutNulls,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 72.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: AppTokens.softShadow(context),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xFFEC3B5B),
                                  width: 2.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(44.0),
                                  child: Image.asset(
                                    'assets/images/Logo-white_(1).png',
                                    width: 35.0,
                                    height: 35.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 4.0),
                                      child: Text(
                                        listViewPropriedadesRecord.displayName,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      listViewPropriedadesRecord.cidade,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TecnicoRecord>>(
      stream: queryTecnicoRecord(
        queryBuilder: (tecnicoRecord) => tecnicoRecord.where(
          'uidPerson',
          isEqualTo: currentUserUid,
        ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF75E38),
                  ),
                ),
              ),
            ),
          );
        }
        List<TecnicoRecord> listaPropriedadeTecnicoRecordList = snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final listaPropriedadeTecnicoRecord =
            listaPropriedadeTecnicoRecordList.isNotEmpty
                ? listaPropriedadeTecnicoRecordList.first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
                      begin: AlignmentDirectional(-1.0, -1.0),
                      end: AlignmentDirectional(1.0, 1.0),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    actions: [],
                    flexibleSpace: FlexibleSpaceBar(
                      title: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _p1(context),
                        ],
                      ),
                      centerTitle: true,
                      expandedTitleScale: 1.0,
                    ),
                    elevation: 0.0,
                  )),
            ),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _p2(context),
                    _p3(context, listaPropriedadeTecnicoRecord),
                    _p4(context, listaPropriedadeTecnicoRecord),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
