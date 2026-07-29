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
import '/core/auth/produtor_account_service.dart';
import '/core/di/providers.dart';
import '/data/objectbox/entities/index.dart';
import '/features/propriedades/application/firestore_refs.dart';
import '/features/propriedades/application/propriedades_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaPropriedadePage extends ConsumerStatefulWidget {
  const ListaPropriedadePage({
    super.key,
    required this.visitaPresencial,
  });

  final bool? visitaPresencial;

  static String routeName = 'listaPropriedade';
  static String routePath = '/listaPropriedade';

  @override
  ConsumerState<ListaPropriedadePage> createState() =>
      _ListaPropriedadePageState();
}

class _ListaPropriedadePageState extends ConsumerState<ListaPropriedadePage> {
  /// Altura ocupada pelos botões flutuantes (botão de 65 + 15 de padding em
  /// cima e embaixo). A lista reserva isso no rodapé para que o último card
  /// consiga rolar até acima deles.
  static const double _alturaBotoes = 95.0;

  late TextEditingController _searchController;

  /// Termo de busca. É um [ValueNotifier] (e não `setState`) de propósito: a
  /// digitação só reconstrói o campo e a lista, não a página inteira.
  final ValueNotifier<String> _busca = ValueNotifier<String>('');

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _busca.dispose();

    super.dispose();
  }

  /// Mensagem centralizada (estado vazio / sem dados) — nunca um spinner de
  /// rede: a tela lê do ObjectBox e deve renderizar mesmo offline.
  Widget _mensagem(BuildContext context, String texto) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
      child: Center(
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.readexPro(),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }

  Widget cabecalhoPropriedades(BuildContext context) {
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

  Widget barraPesquisar(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _busca,
      builder: (context, termo, _) => _campoBusca(context, termo),
    );
  }

  Widget _campoBusca(BuildContext context, String termo) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) => _busca.value = value,
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
          suffixIcon: termo.isNotEmpty
              ? InkWell(
                  onTap: () {
                    _searchController.clear();
                    _busca.value = '';
                  },
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
      ),
    );
  }

  /// Lista única (pendentes + ativas), lida do ObjectBox. Um só scrollable,
  /// virtualizado — sem `shrinkWrap` dentro de scroll pai.
  Widget _listaPropriedades(BuildContext context, TecnicoEntity tecnico) {
    final tecnicoPath = 'tecnico/${tecnico.firestoreId}';
    final isOnline = ref.watch(isOnlineProvider).valueOrNull ?? false;
    final pendentes =
        ref.watch(propriedadesPendentesProvider(tecnicoPath)).valueOrNull ??
            const <PropriedadeEntity>[];
    final ativas =
        ref.watch(propriedadesAtivasProvider(tecnicoPath)).valueOrNull ??
            const <PropriedadeEntity>[];

    return ValueListenableBuilder<String>(
      valueListenable: _busca,
      builder: (context, termo, _) {
        final busca = termo.trim().toLowerCase();
        bool casa(PropriedadeEntity p) =>
            busca.isEmpty ||
            (p.displayName ?? '').toLowerCase().contains(busca);

        final pendentesFiltradas = pendentes.where(casa).toList();
        final ativasFiltradas = ativas.where(casa).toList();

        if (pendentesFiltradas.isEmpty && ativasFiltradas.isEmpty) {
          return _mensagem(
            context,
            busca.isEmpty
                ? 'Nenhuma propriedade cadastrada.'
                : 'Nenhuma propriedade encontrada com "${termo.trim()}"',
          );
        }

        return ListView.builder(
          // O padding inferior é o que deixa a última propriedade alcançável:
          // os botões flutuam por cima da lista, então sem ele o último card
          // pararia embaixo deles.
          padding: const EdgeInsets.only(top: 4.0, bottom: _alturaBotoes),
          itemCount: pendentesFiltradas.length + ativasFiltradas.length,
          itemBuilder: (context, index) => index < pendentesFiltradas.length
              ? _pendingCard(
                  context, pendentesFiltradas[index], isOnline, tecnico)
              : _propriedadeCard(
                  context,
                  ativasFiltradas[index - pendentesFiltradas.length],
                  tecnico,
                ),
        );
      },
    );
  }

  Widget barraBotoes(BuildContext context, TecnicoEntity tecnico) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: const AlignmentDirectional(0.0, 1.0),
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
                      tecnico.docRef,
                      ParamType.DocumentReference,
                    ),
                  }.withoutNulls,
                );
              },
              text: '',
              icon: const Icon(
                Icons.delete_outline,
                size: 32.0,
              ),
              options: FFButtonOptions(
                width: 65.0,
                height: 65.0,
                padding: const EdgeInsets.all(0.0),
                iconPadding:
                    const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                color: const Color(0xFFA8A8A8),
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
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(1.0, 1.0),
            child: FFButtonWidget(
              onPressed: () async {
                if (tecnico.restanteLimiteProdutores > 0) {
                  context.pushNamed(
                    NovaPropriedadePage.routeName,
                    queryParameters: {
                      'visitaPresencial': serializeParam(
                        widget.visitaPresencial,
                        ParamType.bool,
                      ),
                      'uidTecnico': serializeParam(
                        tecnico.docRef,
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
                        title: const Text('Limite propriedades atingida.'),
                        content: const Text(
                            'Contrate um novo plano ou elimine alguma propriedade.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
              },
              text: '',
              icon: const Icon(
                Icons.add_rounded,
                size: 35.0,
              ),
              options: FFButtonOptions(
                width: 65.0,
                height: 65.0,
                padding: const EdgeInsets.all(0.0),
                iconPadding:
                    const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                color: const Color(0xFFEC3B5B),
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
                borderSide: const BorderSide(
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

  /// Abre a edição de uma propriedade PENDENTE (id local, pois ainda não tem
  /// firestoreId) — usado para corrigir dados antes de ativar.
  void _abrirEdicaoPendente(
      BuildContext context, PropriedadeEntity entity, TecnicoEntity tecnico) {
    context.pushNamed(
      EditarPropriedadePage.routeName,
      queryParameters: {
        'propriedadePendenteId': serializeParam(entity.id, ParamType.int),
        'nomePropriedade': serializeParam(entity.displayName, ParamType.String),
        'uidTecnico':
            serializeParam(tecnico.docRef, ParamType.DocumentReference),
        'emailPropriedade': serializeParam(entity.email, ParamType.String),
        'visitaPresencial':
            serializeParam(widget.visitaPresencial, ParamType.bool),
        'emailTecnico': serializeParam(currentUserEmail, ParamType.String),
      }.withoutNulls,
    );
  }

  /// Abre uma propriedade PENDENTE (mesmo sem conta ativa) para operar offline
  /// — cadastrar animais, ações, parto etc. Usa o docRef reservado da entidade
  /// (path `tecnico/{id}/propriedades/local_{objectboxId}`), e sinaliza o modo
  /// pendente com `propriedadePendenteId` (id local) para as telas de destino.
  void _abrirPropriedadePendente(
      BuildContext context, PropriedadeEntity entity, TecnicoEntity tecnico) {
    // Backfill de pendente legada (sem firestoreId): garante o id antes de
    // montar o docRef que a tela de destino recebe.
    ref.read(propriedadeRepositoryProvider).ensureFirestoreId(entity);
    context.pushNamed(
      InicioPropriedadePage.routeName,
      queryParameters: {
        'nomePropriedade': serializeParam(entity.displayName, ParamType.String),
        'uidPropriedade':
            serializeParam(entity.docRef, ParamType.DocumentReference),
        'uidTecnico':
            serializeParam(tecnico.docRef, ParamType.DocumentReference),
        'emailPropriedade': serializeParam(entity.email, ParamType.String),
        'visitaPresencial':
            serializeParam(widget.visitaPresencial, ParamType.bool),
        'diasDg': serializeParam(entity.diasParaDg, ParamType.String),
        'propriedadePendenteId': serializeParam(entity.id, ParamType.int),
      }.withoutNulls,
    );
  }

  /// Card de propriedade criada offline, aguardando ativação da conta. Mantém a
  /// mesma linha de topo dos demais cards (avatar + nome + subtítulo), porém em
  /// moldura de alerta (borda + sombra laranja e ícone de atenção), com o botão
  /// "Ativar conta" logo abaixo — por isso é mais alto que os cards normais.
  /// Tocar na linha de topo abre a propriedade para operar offline.
  Widget _pendingCard(BuildContext context, PropriedadeEntity entity,
      bool isOnline, TecnicoEntity tecnico) {
    final laranja = AppTokens.brand;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: laranja, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: laranja.withValues(alpha: 0.25),
              blurRadius: 16.0,
              offset: const Offset(0.0, 6.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha de topo idêntica aos demais cards (avatar + nome +
              // subtítulo), com ícone de atenção no lugar do chevron. Tocar abre
              // a propriedade para operar offline.
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () =>
                    _abrirPropriedadePendente(context, entity, tecnico),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Color(0xFFEC3B5B), width: 2.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 4.0),
                              child: Text(
                                entity.displayName ?? 'Propriedade',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.readexPro(),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            Text(
                              'Conta pendente · toque para abrir',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.warning_amber_rounded,
                      color: laranja,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              if (isOnline)
                FFButtonWidget(
                  onPressed: () => _ativarConta(context, entity, tecnico),
                  text: 'Ativar conta',
                  icon: const Icon(Icons.check_circle_outline, size: 16.0),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 44.0,
                    color: AppTokens.secondary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.readexPro(),
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                )
              else
                Text(
                  'Conecte-se à internet para ativar a conta.',
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        font: GoogleFonts.readexPro(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ativa a conta do produtor de uma propriedade: cria a conta numa instância
  /// secundária do Firebase (sem deslogar o técnico), VINCULA o produtor ao
  /// documento da propriedade (que já existe/sincroniza sozinho), atualiza os
  /// contadores do técnico, envia o e-mail e reconcilia o registro local.
  Future<void> _ativarConta(BuildContext context, PropriedadeEntity entity,
      TecnicoEntity tecnico) async {
    final tecnicoRef = tecnico.docRef;
    if (tecnicoRef == null) return;

    // Backfill de pendente legada: garante o firestoreId (usado no path do doc).
    ref.read(propriedadeRepositoryProvider).ensureFirestoreId(entity);

    // Loading bloqueante enquanto a ativação acontece.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: SizedBox(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF75E38)),
          ),
        ),
      ),
    );

    try {
      // Senha padrão do produtor = CPF apenas com dígitos (bate com o e-mail).
      final senhaProdutor =
          (entity.cpf ?? '').replaceAll(RegExp(r'[^0-9]'), '');

      final produtorUid = await ProdutorAccountService.criarContaProdutor(
        email: entity.email!,
        password: senhaProdutor,
        buildPersonData: (uid) => createPersonRecordData(
          cpf: entity.cpf,
          uid: uid,
          endereco: entity.endereco,
          cidade: entity.cidade,
          email: entity.email,
          createdTime: getCurrentTimestamp,
          displayName: entity.displayName,
          phoneNumber: entity.phoneNumber,
          tipo: 'produtor',
        ),
      );

      // Referência (instância primária) ao person do produtor recém-criado.
      final produtorPersonRef = PersonRecord.collection.doc(produtorUid);

      // A ativação NÃO cria mais a propriedade — ela já nasceu com um
      // firestoreId real e sincroniza sozinha. Aqui apenas VINCULAMOS o produtor
      // ao documento existente (`set(merge)` cria-ou-mescla, idempotente mesmo se
      // a propriedade ainda não tinha subido). O firestoreId veio da criação.
      final propriedadeRef = FirebaseFirestore.instance
          .doc('${entity.parentPath}/propriedades/${entity.firestoreId}');
      await propriedadeRef.set(
        createPropriedadesRecordData(
          email: entity.email,
          displayName: entity.displayName,
          cpf: entity.cpf,
          endereco: entity.endereco,
          cidade: entity.cidade,
          phoneNumber: entity.phoneNumber,
          diasParaDg: entity.diasParaDg,
          uidPersonProdutor: produtorPersonRef,
        ),
        SetOptions(merge: true),
      );

      // Atualiza contadores do técnico.
      await tecnicoRef.update({
        ...createTecnicoRecordData(uidPerson: currentUserUid),
        ...mapToFirestore({
          'quantidadeProdutoresCadastrados': FieldValue.increment(1),
          'restanteLimiteProdutores': FieldValue.increment(-(1)),
        }),
      });

      // Reconcilia o registro local: vincula o produtor + marca conta criada. O
      // ObjectBox notifica os watchers, então o card pendente vira card normal
      // sozinho — sem setState.
      final propriedadeRepo = ref.read(propriedadeRepositoryProvider);
      final local = propriedadeRepo.getById(entity.id);
      if (local != null) {
        propriedadeRepo.markContaCriada(local,
            uidPersonProdutorPath: produtorPersonRef.path);
      }

      // Espelha localmente os contadores que o Firestore acabou de incrementar.
      // Sem isso, o gate do botão "+" (que agora lê o técnico do ObjectBox)
      // ficaria com o limite desatualizado até o próximo download completo.
      // `put` direto (e não `save`): o Firestore já está atualizado; marcar
      // needsSync faria o sync reenviar o documento e sobrescrever os increments.
      final tecnicoRepo = ref.read(tecnicoRepositoryProvider);
      final tecnicoLocal = tecnicoRepo.getByFirestoreId(tecnico.firestoreId!);
      if (tecnicoLocal != null) {
        tecnicoLocal.quantidadeProdutoresCadastrados += 1;
        tecnicoLocal.restanteLimiteProdutores -= 1;
        tecnicoRepo.box.put(tecnicoLocal);
      }

      // E-mail de boas-vindas ao produtor (senha = CPF).
      await launchUrl(Uri(
          scheme: 'mailto',
          path: entity.email!,
          query: {
            'subject': 'Bem-vindo(a) Tecmuu!',
            'body':
                'Olá, produtor! Seja muito bem-vindo à plataforma TecMuu! Para começar sua jornada conosco, baixe nosso aplicativo na Play Store ou na App Store e faça login utilizando seu e-mail e, como senha padrão, o seu CPF (apenas os números). No primeiro acesso, recomendamos que você troque a senha. Estamos ansiosos para ter você conosco! 🚀',
          }
              .entries
              .map((MapEntry<String, String> e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
              .join('&')));

      if (!mounted) return;
      Navigator.of(context).pop(); // fecha o loading
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: const Text('Conta ativada com sucesso!'),
            content: const Text(
                'A propriedade foi sincronizada e o produtor recebeu o e-mail '
                'de boas-vindas.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // fecha o loading
      final jaExiste =
          e is FirebaseAuthException && e.code == 'email-already-in-use';
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text(jaExiste
                ? 'E-mail já cadastrado'
                : 'Não foi possível ativar a conta'),
            content: Text(jaExiste
                ? 'Já existe uma conta com este e-mail. Vamos abrir a edição '
                    'para você corrigir o e-mail e ativar novamente.'
                : 'Ocorreu um erro ao ativar a conta. Verifique sua conexão e tente novamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );

      // E-mail duplicado: leva à edição da propriedade PENDENTE para corrigir o
      // e-mail antes de reativar.
      if (jaExiste && mounted) {
        _abrirEdicaoPendente(context, entity, tecnico);
      }
    }
  }

  /// Card de uma propriedade já ativa, montado a partir da entidade do
  /// ObjectBox (antes vinha de um StreamBuilder do Firestore).
  Widget _propriedadeCard(
      BuildContext context, PropriedadeEntity entity, TecnicoEntity tecnico) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 10.0),
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
                entity.displayName,
                ParamType.String,
              ),
              'uidPropriedade': serializeParam(
                entity.docRef,
                ParamType.DocumentReference,
              ),
              'uidTecnico': serializeParam(
                tecnico.docRef,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                entity.email,
                ParamType.String,
              ),
              'visitaPresencial': serializeParam(
                widget.visitaPresencial,
                ParamType.bool,
              ),
              'diasDg': serializeParam(
                entity.diasParaDg,
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
                content: Text('Atualize as informações segurando pressionado.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
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
                entity.docRef,
                ParamType.DocumentReference,
              ),
              'nomePropriedade': serializeParam(
                entity.displayName,
                ParamType.String,
              ),
              'uidTecnico': serializeParam(
                tecnico.docRef,
                ParamType.DocumentReference,
              ),
              'emailPropriedade': serializeParam(
                entity.email,
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
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 4.0),
                          child: Text(
                            entity.displayName ?? '',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                          ),
                        ),
                        Text(
                          entity.cidade ?? '',
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
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
  }

  @override
  Widget build(BuildContext context) {
    // Técnico lido do ObjectBox (offline-first). Antes esta tela inteira ficava
    // dentro de um StreamBuilder do Firestore, o que a prendia à rede.
    final tecnicoAsync = ref.watch(tecnicoLogadoProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
              decoration: const BoxDecoration(
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
                      cabecalhoPropriedades(context),
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
          child: tecnicoAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                _mensagem(context, 'Não foi possível carregar seus dados.'),
            data: (tecnico) {
              if (tecnico?.firestoreId == null) {
                return _mensagem(
                  context,
                  'Seus dados ainda não foram sincronizados. Conecte-se à '
                  'internet uma vez para carregar suas propriedades.',
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  barraPesquisar(context),
                  // Os botões FLUTUAM sobre a lista em vez de ocuparem uma
                  // faixa própria no Column. Como faixa, eles reservavam 95px
                  // de altura onde aparecia o fundo cinza do Scaffold
                  // (primaryBackground, #F1F4F8) — e contra os cards brancos
                  // aquilo lia como uma barra cinza cobrindo a última
                  // propriedade. Flutuando, a lista ocupa a tela inteira e o
                  // padding inferior dela deixa o último card rolar até o fim.
                  Expanded(
                    child: Stack(
                      children: [
                        // Único scrollable da tela: a lista virtualiza de
                        // verdade.
                        _listaPropriedades(context, tecnico!),
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          bottom: 0.0,
                          child: barraBotoes(context, tecnico),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
