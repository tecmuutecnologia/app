import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'sincronizar_bkp_model.dart';
export 'sincronizar_bkp_model.dart';

class SincronizarBkpWidget extends StatefulWidget {
  const SincronizarBkpWidget({
    super.key,
    this.uidTecnico,
    this.uidPropriedade,
  });

  final DocumentReference? uidTecnico;
  final DocumentReference? uidPropriedade;

  @override
  State<SincronizarBkpWidget> createState() => _SincronizarBkpWidgetState();
}

class _SincronizarBkpWidgetState extends State<SincronizarBkpWidget> {
  late SincronizarBkpModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SincronizarBkpModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 2000,
        ),
      );
      // Loop para criar animais cadastrados de forma offline
      while (FFAppState().animaisProdutoresOffline.length != 0) {
        var animaisProdutoresRecordReference =
            AnimaisProdutoresRecord.createDoc(
          widget.uidTecnico!,
          id: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)!
              .uidAnimalOffline,
        );
        await animaisProdutoresRecordReference
            .set(createAnimaisProdutoresRecordData(
          uidTecnicoPropriedade: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.uidTecnicoPropriedade,
          nomeAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.nomeAnimal,
          racaAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.racaAnimal,
          pesoAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.pesoAnimal,
          dtNascimento: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtNascimento,
          touro:
              FFAppState().animaisProdutoresOffline.elementAtOrNull(0)?.touro,
          vaca: FFAppState().animaisProdutoresOffline.elementAtOrNull(0)?.vaca,
          status:
              FFAppState().animaisProdutoresOffline.elementAtOrNull(0)?.status,
          grupoAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.grupoAnimal,
          dtUltimaInseminacao: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtUltimaInseminacao,
          dtUltimoParto: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtUltimoParto,
          liberaInseminacao: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.liberaInseminacao,
          dtPartoPrevisto: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtPartoPrevisto,
          dtSecPrevista: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtSecPrevista,
          dtPrePartoPrevista: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtPrePartoPrevista,
          dtPP: FFAppState().animaisProdutoresOffline.elementAtOrNull(0)?.dtPP,
          dtDgMais: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtDgMais,
          dtDgMenos: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtDgMenos,
          dtAborto: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtAborto,
          dtSecagem: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtSecagem,
          dtUltimoPP: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtUltimoPP,
          nomeTouroUltimaInseminacao: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.nomeTouroUltimaInseminacao,
          totalInseminacoes: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.totalInseminacoes,
          totalPartos: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.totalPartos,
          dtPreParto: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtPreParto,
          motivoDescarteAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.motivoDescarteAnimal,
          dtDescarteAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtDescarteAnimal,
          dtUltimaAcao: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtUltimaAcao,
          compararDtUltimaInseminacao: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.compararDtUltimaInseminacao,
          nomeBrincoConcat: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.nomeBrincoConcat,
          idGrupoAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.idGrupoAnimal,
          dtUltimoPartoContingencia: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtUltimoPartoContingencia,
          idStatusAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.idStatusAnimal,
          dtInducaoLactacao: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtInducaoLactacao,
          dtDesmame: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.dtDesmame,
          brincoAnimal: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.brincoAnimal,
          brincoAnimalOrder: FFAppState()
              .animaisProdutoresOffline
              .elementAtOrNull(0)
              ?.brincoAnimalOrder,
        ));
        _model.outUidAnimalOfflineCadastrado =
            AnimaisProdutoresRecord.getDocumentFromData(
                createAnimaisProdutoresRecordData(
                  uidTecnicoPropriedade: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.uidTecnicoPropriedade,
                  nomeAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.nomeAnimal,
                  racaAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.racaAnimal,
                  pesoAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.pesoAnimal,
                  dtNascimento: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtNascimento,
                  touro: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.touro,
                  vaca: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.vaca,
                  status: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.status,
                  grupoAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.grupoAnimal,
                  dtUltimaInseminacao: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtUltimaInseminacao,
                  dtUltimoParto: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtUltimoParto,
                  liberaInseminacao: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.liberaInseminacao,
                  dtPartoPrevisto: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtPartoPrevisto,
                  dtSecPrevista: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtSecPrevista,
                  dtPrePartoPrevista: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtPrePartoPrevista,
                  dtPP: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtPP,
                  dtDgMais: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtDgMais,
                  dtDgMenos: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtDgMenos,
                  dtAborto: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtAborto,
                  dtSecagem: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtSecagem,
                  dtUltimoPP: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtUltimoPP,
                  nomeTouroUltimaInseminacao: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.nomeTouroUltimaInseminacao,
                  totalInseminacoes: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.totalInseminacoes,
                  totalPartos: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.totalPartos,
                  dtPreParto: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtPreParto,
                  motivoDescarteAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.motivoDescarteAnimal,
                  dtDescarteAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtDescarteAnimal,
                  dtUltimaAcao: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtUltimaAcao,
                  compararDtUltimaInseminacao: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.compararDtUltimaInseminacao,
                  nomeBrincoConcat: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.nomeBrincoConcat,
                  idGrupoAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.idGrupoAnimal,
                  dtUltimoPartoContingencia: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtUltimoPartoContingencia,
                  idStatusAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.idStatusAnimal,
                  dtInducaoLactacao: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtInducaoLactacao,
                  dtDesmame: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.dtDesmame,
                  brincoAnimal: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.brincoAnimal,
                  brincoAnimalOrder: FFAppState()
                      .animaisProdutoresOffline
                      .elementAtOrNull(0)
                      ?.brincoAnimalOrder,
                ),
                animaisProdutoresRecordReference);
        while ((FFAppState().acoesOffline.length != 0) &&
            (FFAppState()
                    .animaisProdutoresOffline
                    .elementAtOrNull(0)
                    ?.uidAnimalOffline ==
                FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.uidAnimalOffline)) {
          var acoesRecordReference1 =
              AcoesRecord.createDoc(widget.uidTecnico!);
          await acoesRecordReference1.set(createAcoesRecordData(
            uidAnimalAnimaisProdutores:
                _model.outUidAnimalOfflineCadastrado?.reference,
            nomeAnimal:
                FFAppState().acoesOffline.elementAtOrNull(0)?.nomeAnimal,
            acao: FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
            obsVisita: FFAppState().acoesOffline.elementAtOrNull(0)?.obsVisita,
            dataVisita:
                FFAppState().acoesOffline.elementAtOrNull(0)?.dataVisita,
            uidPropriedade:
                FFAppState().acoesOffline.elementAtOrNull(0)?.uidPropriedade,
            dataDaAcao:
                FFAppState().acoesOffline.elementAtOrNull(0)?.dataDaAcao,
            touroInseminacao:
                FFAppState().acoesOffline.elementAtOrNull(0)?.touroInseminacao,
            dataPartoPrevisto:
                FFAppState().acoesOffline.elementAtOrNull(0)?.dataPartoPrevisto,
            dataSecPrevista:
                FFAppState().acoesOffline.elementAtOrNull(0)?.dataSecPrevista,
            dataPrePartoPrevista: FFAppState()
                .acoesOffline
                .elementAtOrNull(0)
                ?.dataPrePartoPrevista,
            dtPP: FFAppState().acoesOffline.elementAtOrNull(0)?.dtPP,
            dtDgMais: FFAppState().acoesOffline.elementAtOrNull(0)?.dtDgMais,
            dtDgMenos: FFAppState().acoesOffline.elementAtOrNull(0)?.dtDgMenos,
            dtAborto: FFAppState().acoesOffline.elementAtOrNull(0)?.dtAborto,
          ));
          _model.uidAcaoLancada = AcoesRecord.getDocumentFromData(
              createAcoesRecordData(
                uidAnimalAnimaisProdutores:
                    _model.outUidAnimalOfflineCadastrado?.reference,
                nomeAnimal:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.nomeAnimal,
                acao: FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                obsVisita:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.obsVisita,
                dataVisita:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dataVisita,
                uidPropriedade: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.uidPropriedade,
                dataDaAcao:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dataDaAcao,
                touroInseminacao: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.touroInseminacao,
                dataPartoPrevisto: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.dataPartoPrevisto,
                dataSecPrevista: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.dataSecPrevista,
                dataPrePartoPrevista: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.dataPrePartoPrevista,
                dtPP: FFAppState().acoesOffline.elementAtOrNull(0)?.dtPP,
                dtDgMais:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dtDgMais,
                dtDgMenos:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dtDgMenos,
                dtAborto:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dtAborto,
              ),
              acoesRecordReference1);

          await _model.outUidAnimalOfflineCadastrado!.reference
              .update(createAnimaisProdutoresRecordData(
            dtUltimaAcao: dateTimeFormat(
              "dd/MM/yyyy",
              getCurrentTimestamp,
              locale: FFLocalizations.of(context).languageCode,
            ),
          ));
          if ((FFAppState().acoesOffline.elementAtOrNull(0)?.acao != 'DG+') &&
              (FFAppState().acoesOffline.elementAtOrNull(0)?.acao != 'DG-') &&
              (FFAppState().acoesOffline.elementAtOrNull(0)?.acao != 'PP')) {
            _model.outUidResumoDaVisitaOff =
                await queryResumoDaVisitaRecordOnce(
              queryBuilder: (resumoDaVisitaRecord) => resumoDaVisitaRecord
                  .where(
                    'uidPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'uidTecnico',
                    isEqualTo: widget.uidTecnico,
                  )
                  .where(
                    'dtVisitaFormatado',
                    isEqualTo: dateTimeFormat(
                      "dd/MM/yyyy",
                      getCurrentTimestamp,
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                  ),
              singleRecord: true,
            ).then((s) => s.firstOrNull);
            if (_model.outUidResumoDaVisitaOff != null) {
              if ((FFAppState()
                          .acoesOffline
                          .elementAtOrNull(0)
                          ?.acao !=
                      'DG +') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'DG -') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'PP') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'Inseminada')) {
                await TratamentosRecord.createDoc(
                        _model.outUidResumoDaVisitaOff!.reference)
                    .set(createTratamentosRecordData(
                  uidAnimal: _model.outUidAnimalOfflineCadastrado?.reference,
                  tipoAcao: FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                  uidResumoDaVisita: _model.outUidResumoDaVisitaOff?.reference,
                  observacaoAcao:
                      FFAppState().acoesOffline.elementAtOrNull(0)?.obsVisita,
                  brincoAnimal: _model
                      .outUidAnimalOfflineCadastrado?.brincoAnimal
                      .toString(),
                  nomeAnimal: _model.outUidAnimalOfflineCadastrado?.nomeAnimal,
                  grupoAnimal:
                      _model.outUidAnimalOfflineCadastrado?.grupoAnimal,
                  uidAcaoLancada: _model.uidAcaoLancada?.reference,
                  brincoAnimalOrder: functions.converterStringToInt(_model
                      .outUidAnimalOfflineCadastrado!.brincoAnimal
                      .toString()),
                ));
                _model.outUidRecomendacoesOff =
                    await queryRecomendacoesRecordOnce(
                  parent: _model.outUidResumoDaVisitaOff?.reference,
                  queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                      .where(
                        'uidResumoDaVisita',
                        isEqualTo: _model.outUidResumoDaVisitaOff?.reference,
                      )
                      .where(
                        'tituloRecomendacao',
                        isEqualTo:
                            FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                      ),
                  singleRecord: true,
                ).then((s) => s.firstOrNull);
                if (_model.outUidRecomendacoesOff?.reference == null) {
                  await RecomendacoesRecord.createDoc(
                          _model.outUidResumoDaVisitaOff!.reference)
                      .set(createRecomendacoesRecordData(
                    tituloRecomendacao:
                        FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                    uidResumoDaVisita:
                        _model.outUidResumoDaVisitaOff?.reference,
                  ));
                }
              }
            } else {
              if ((FFAppState()
                          .acoesOffline
                          .elementAtOrNull(0)
                          ?.acao !=
                      'DG +') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'DG -') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'PP') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'Inseminada')) {
                var resumoDaVisitaRecordReference1 =
                    ResumoDaVisitaRecord.collection.doc();
                await resumoDaVisitaRecordReference1
                    .set(createResumoDaVisitaRecordData(
                  uidPropriedade: widget.uidPropriedade,
                  uidTecnico: widget.uidTecnico,
                  dtVisita: getCurrentTimestamp,
                  dtVisitaFormatado: dateTimeFormat(
                    "dd/MM/yyyy",
                    getCurrentTimestamp,
                    locale: FFLocalizations.of(context).languageCode,
                  ),
                ));
                _model.outNewUidResumoDaVisitaOff =
                    ResumoDaVisitaRecord.getDocumentFromData(
                        createResumoDaVisitaRecordData(
                          uidPropriedade: widget.uidPropriedade,
                          uidTecnico: widget.uidTecnico,
                          dtVisita: getCurrentTimestamp,
                          dtVisitaFormatado: dateTimeFormat(
                            "dd/MM/yyyy",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                        ),
                        resumoDaVisitaRecordReference1);

                await _model.outNewUidResumoDaVisitaOff!.reference
                    .update(createResumoDaVisitaRecordData(
                  uidResumoDaVisita:
                      _model.outNewUidResumoDaVisitaOff?.reference,
                ));

                await TratamentosRecord.createDoc(
                        _model.outNewUidResumoDaVisitaOff!.reference)
                    .set(createTratamentosRecordData(
                  uidAnimal: _model.outUidAnimalOfflineCadastrado?.reference,
                  tipoAcao: FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                  uidResumoDaVisita:
                      _model.outNewUidResumoDaVisitaOff?.reference,
                  observacaoAcao:
                      FFAppState().acoesOffline.elementAtOrNull(0)?.obsVisita,
                  brincoAnimal: _model
                      .outUidAnimalOfflineCadastrado?.brincoAnimal
                      .toString(),
                  nomeAnimal: _model.outUidAnimalOfflineCadastrado?.nomeAnimal,
                  grupoAnimal:
                      _model.outUidAnimalOfflineCadastrado?.grupoAnimal,
                  uidAcaoLancada: _model.uidAcaoLancada?.reference,
                  brincoAnimalOrder: functions.converterStringToInt(_model
                      .outUidAnimalOfflineCadastrado!.brincoAnimal
                      .toString()),
                ));
                _model.outUidRecomendacoes2Off =
                    await queryRecomendacoesRecordOnce(
                  parent: _model.outNewUidResumoDaVisitaOff?.reference,
                  queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                      .where(
                        'uidResumoDaVisita',
                        isEqualTo: _model.outNewUidResumoDaVisitaOff?.reference,
                      )
                      .where(
                        'tituloRecomendacao',
                        isEqualTo:
                            FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                      ),
                  singleRecord: true,
                ).then((s) => s.firstOrNull);
                if (_model.outUidRecomendacoes2Off?.reference == null) {
                  await RecomendacoesRecord.createDoc(
                          _model.outNewUidResumoDaVisitaOff!.reference)
                      .set(createRecomendacoesRecordData(
                    tituloRecomendacao:
                        FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                    uidResumoDaVisita:
                        _model.outNewUidResumoDaVisitaOff?.reference,
                  ));
                }
              }
            }

            FFAppState().removeAtIndexFromAcoesOffline(0);
            safeSetState(() {});
          } else {
            FFAppState().removeAtIndexFromAcoesOffline(0);
            safeSetState(() {});
          }
        }
        FFAppState().removeAtIndexFromAnimaisProdutoresOffline(0);
        safeSetState(() {});
      }
      // Atualizar animais que já estavam cadastrados mas que receberam alguma nova atualização devido a mudança de status.
      while (FFAppState().animaisProdutoresEditados.length != 0) {
        await FFAppState()
            .animaisProdutoresEditados
            .elementAtOrNull(0)!
            .uidAnimal!
            .update(createAnimaisProdutoresRecordData(
              uidTecnicoPropriedade: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.uidTecnicoPropriedade,
              nomeAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.nomeAnimal,
              racaAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.racaAnimal,
              pesoAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.pesoAnimal,
              dtNascimento: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtNascimento,
              touro: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.touro,
              vaca: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.vaca,
              status: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.status,
              grupoAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.grupoAnimal,
              dtUltimaInseminacao: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtUltimaInseminacao,
              dtUltimoParto: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtUltimoParto,
              liberaInseminacao: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.liberaInseminacao,
              dtPartoPrevisto: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtPartoPrevisto,
              dtSecPrevista: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtSecPrevista,
              dtPrePartoPrevista: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtPrePartoPrevista,
              dtPP: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtPP,
              dtDgMais: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtDgMais,
              dtDgMenos: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtDgMenos,
              dtAborto: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtAborto,
              dtSecagem: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtSecagem,
              dtUltimoPP: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtUltimoPP,
              nomeTouroUltimaInseminacao: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.nomeTouroUltimaInseminacao,
              totalInseminacoes: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.totalInseminacoes,
              totalPartos: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.totalPartos,
              dtPreParto: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtPreParto,
              motivoDescarteAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.motivoDescarteAnimal,
              dtDescarteAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtDescarteAnimal,
              dtUltimaAcao: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtUltimaAcao,
              compararDtUltimaInseminacao: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.compararDtUltimaInseminacao,
              nomeBrincoConcat: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.nomeBrincoConcat,
              idGrupoAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.idGrupoAnimal,
              dtUltimoPartoContingencia: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtUltimoPartoContingencia,
              idStatusAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.idStatusAnimal,
              dtInducaoLactacao: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtInducaoLactacao,
              dtDesmame: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.dtDesmame,
              brincoAnimal: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.brincoAnimal,
              brincoAnimalOrder: FFAppState()
                  .animaisProdutoresEditados
                  .elementAtOrNull(0)
                  ?.brincoAnimalOrder,
            ));
        while ((FFAppState().acoesOffline.length != 0) &&
            (FFAppState()
                    .animaisProdutoresEditados
                    .elementAtOrNull(0)
                    ?.uidAnimal ==
                FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.uidAnimalAnimaisProdutores)) {
          var acoesRecordReference2 =
              AcoesRecord.createDoc(widget.uidTecnico!);
          await acoesRecordReference2.set(createAcoesRecordData(
            uidAnimalAnimaisProdutores: FFAppState()
                .animaisProdutoresEditados
                .elementAtOrNull(0)
                ?.uidAnimal,
            nomeAnimal:
                FFAppState().acoesOffline.elementAtOrNull(0)?.nomeAnimal,
            acao: FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
            obsVisita: FFAppState().acoesOffline.elementAtOrNull(0)?.obsVisita,
            dataVisita:
                FFAppState().acoesOffline.elementAtOrNull(0)?.dataVisita,
            uidPropriedade:
                FFAppState().acoesOffline.elementAtOrNull(0)?.uidPropriedade,
            dataDaAcao:
                FFAppState().acoesOffline.elementAtOrNull(0)?.dataDaAcao,
            touroInseminacao:
                FFAppState().acoesOffline.elementAtOrNull(0)?.touroInseminacao,
            dataPartoPrevisto:
                FFAppState().acoesOffline.elementAtOrNull(0)?.dataPartoPrevisto,
            dataSecPrevista:
                FFAppState().acoesOffline.elementAtOrNull(0)?.dataSecPrevista,
            dataPrePartoPrevista: FFAppState()
                .acoesOffline
                .elementAtOrNull(0)
                ?.dataPrePartoPrevista,
            dtPP: FFAppState().acoesOffline.elementAtOrNull(0)?.dtPP,
            dtDgMais: FFAppState().acoesOffline.elementAtOrNull(0)?.dtDgMais,
            dtDgMenos: FFAppState().acoesOffline.elementAtOrNull(0)?.dtDgMenos,
            dtAborto: FFAppState().acoesOffline.elementAtOrNull(0)?.dtAborto,
          ));
          _model.uidAcaoLancada1 = AcoesRecord.getDocumentFromData(
              createAcoesRecordData(
                uidAnimalAnimaisProdutores: FFAppState()
                    .animaisProdutoresEditados
                    .elementAtOrNull(0)
                    ?.uidAnimal,
                nomeAnimal:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.nomeAnimal,
                acao: FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                obsVisita:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.obsVisita,
                dataVisita:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dataVisita,
                uidPropriedade: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.uidPropriedade,
                dataDaAcao:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dataDaAcao,
                touroInseminacao: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.touroInseminacao,
                dataPartoPrevisto: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.dataPartoPrevisto,
                dataSecPrevista: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.dataSecPrevista,
                dataPrePartoPrevista: FFAppState()
                    .acoesOffline
                    .elementAtOrNull(0)
                    ?.dataPrePartoPrevista,
                dtPP: FFAppState().acoesOffline.elementAtOrNull(0)?.dtPP,
                dtDgMais:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dtDgMais,
                dtDgMenos:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dtDgMenos,
                dtAborto:
                    FFAppState().acoesOffline.elementAtOrNull(0)?.dtAborto,
              ),
              acoesRecordReference2);

          await FFAppState()
              .animaisProdutoresEditados
              .elementAtOrNull(0)!
              .uidAnimal!
              .update(createAnimaisProdutoresRecordData(
                dtUltimaAcao: dateTimeFormat(
                  "dd/MM/yyyy",
                  getCurrentTimestamp,
                  locale: FFLocalizations.of(context).languageCode,
                ),
              ));
          if ((FFAppState().acoesOffline.elementAtOrNull(0)?.acao != 'DG+') &&
              (FFAppState().acoesOffline.elementAtOrNull(0)?.acao != 'DG-') &&
              (FFAppState().acoesOffline.elementAtOrNull(0)?.acao != 'PP')) {
            _model.outUidResumoDaVisita = await queryResumoDaVisitaRecordOnce(
              queryBuilder: (resumoDaVisitaRecord) => resumoDaVisitaRecord
                  .where(
                    'uidPropriedade',
                    isEqualTo: widget.uidPropriedade,
                  )
                  .where(
                    'uidTecnico',
                    isEqualTo: widget.uidTecnico,
                  )
                  .where(
                    'dtVisitaFormatado',
                    isEqualTo: dateTimeFormat(
                      "dd/MM/yyyy",
                      getCurrentTimestamp,
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                  ),
              singleRecord: true,
            ).then((s) => s.firstOrNull);
            if (_model.outUidResumoDaVisita != null) {
              if ((FFAppState()
                          .acoesOffline
                          .elementAtOrNull(0)
                          ?.acao !=
                      'DG +') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'DG -') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'PP') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'Inseminada')) {
                await TratamentosRecord.createDoc(
                        _model.outUidResumoDaVisita!.reference)
                    .set(createTratamentosRecordData(
                  uidAnimal: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.uidAnimal,
                  tipoAcao: FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                  uidResumoDaVisita: _model.outUidResumoDaVisita?.reference,
                  observacaoAcao:
                      FFAppState().acoesOffline.elementAtOrNull(0)?.obsVisita,
                  brincoAnimal: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.brincoAnimal
                      .toString(),
                  nomeAnimal: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.nomeAnimal,
                  grupoAnimal: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.grupoAnimal,
                  uidAcaoLancada: _model.uidAcaoLancada1?.reference,
                  brincoAnimalOrder: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.brincoAnimal,
                ));
                _model.outUidRecomendacoes = await queryRecomendacoesRecordOnce(
                  parent: _model.outUidResumoDaVisita?.reference,
                  queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                      .where(
                        'uidResumoDaVisita',
                        isEqualTo: _model.outUidResumoDaVisita?.reference,
                      )
                      .where(
                        'tituloRecomendacao',
                        isEqualTo:
                            FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                      ),
                  singleRecord: true,
                ).then((s) => s.firstOrNull);
                if (_model.outUidRecomendacoes?.reference == null) {
                  await RecomendacoesRecord.createDoc(
                          _model.outUidResumoDaVisita!.reference)
                      .set(createRecomendacoesRecordData(
                    tituloRecomendacao:
                        FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                    uidResumoDaVisita: _model.outUidResumoDaVisita?.reference,
                  ));
                }
              }
            } else {
              if ((FFAppState()
                          .acoesOffline
                          .elementAtOrNull(0)
                          ?.acao !=
                      'DG +') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'DG -') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'PP') &&
                  (FFAppState().acoesOffline.elementAtOrNull(0)?.acao !=
                      'Inseminada')) {
                var resumoDaVisitaRecordReference2 =
                    ResumoDaVisitaRecord.collection.doc();
                await resumoDaVisitaRecordReference2
                    .set(createResumoDaVisitaRecordData(
                  uidPropriedade: widget.uidPropriedade,
                  uidTecnico: widget.uidTecnico,
                  dtVisita: getCurrentTimestamp,
                  dtVisitaFormatado: dateTimeFormat(
                    "dd/MM/yyyy",
                    getCurrentTimestamp,
                    locale: FFLocalizations.of(context).languageCode,
                  ),
                ));
                _model.outNewUidResumoDaVisita =
                    ResumoDaVisitaRecord.getDocumentFromData(
                        createResumoDaVisitaRecordData(
                          uidPropriedade: widget.uidPropriedade,
                          uidTecnico: widget.uidTecnico,
                          dtVisita: getCurrentTimestamp,
                          dtVisitaFormatado: dateTimeFormat(
                            "dd/MM/yyyy",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                        ),
                        resumoDaVisitaRecordReference2);

                await _model.outNewUidResumoDaVisita!.reference
                    .update(createResumoDaVisitaRecordData(
                  uidResumoDaVisita: _model.outNewUidResumoDaVisita?.reference,
                ));

                await TratamentosRecord.createDoc(
                        _model.outNewUidResumoDaVisita!.reference)
                    .set(createTratamentosRecordData(
                  uidAnimal: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.uidAnimal,
                  tipoAcao: FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                  uidResumoDaVisita: _model.outNewUidResumoDaVisita?.reference,
                  observacaoAcao:
                      FFAppState().acoesOffline.elementAtOrNull(0)?.obsVisita,
                  brincoAnimal: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.brincoAnimal
                      .toString(),
                  nomeAnimal: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.nomeAnimal,
                  grupoAnimal: FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)
                      ?.grupoAnimal,
                  uidAcaoLancada: _model.uidAcaoLancada1?.reference,
                  brincoAnimalOrder: functions.converterStringToInt(FFAppState()
                      .animaisProdutoresEditados
                      .elementAtOrNull(0)!
                      .brincoAnimal
                      .toString()),
                ));
                _model.outUidRecomendacoes2 =
                    await queryRecomendacoesRecordOnce(
                  parent: _model.outNewUidResumoDaVisita?.reference,
                  queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                      .where(
                        'uidResumoDaVisita',
                        isEqualTo: _model.outNewUidResumoDaVisita?.reference,
                      )
                      .where(
                        'tituloRecomendacao',
                        isEqualTo:
                            FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                      ),
                  singleRecord: true,
                ).then((s) => s.firstOrNull);
                if (_model.outUidRecomendacoes2?.reference == null) {
                  await RecomendacoesRecord.createDoc(
                          _model.outNewUidResumoDaVisita!.reference)
                      .set(createRecomendacoesRecordData(
                    tituloRecomendacao:
                        FFAppState().acoesOffline.elementAtOrNull(0)?.acao,
                    uidResumoDaVisita:
                        _model.outNewUidResumoDaVisita?.reference,
                  ));
                }
              }
            }

            FFAppState().removeAtIndexFromAcoesOffline(0);
            safeSetState(() {});
          } else {
            FFAppState().removeAtIndexFromAcoesOffline(0);
            safeSetState(() {});
          }
        }
        FFAppState().removeAtIndexFromAnimaisProdutoresEditados(0);
        safeSetState(() {});
      }
      while (FFAppState().animaisApagadosExistentesOffline.length != 0) {
        await FFAppState()
            .animaisApagadosExistentesOffline
            .elementAtOrNull(0)!
            .uidAnimal!
            .update(createAnimaisProdutoresRecordData(
              status: 'Apagado',
            ));
        FFAppState().removeAtIndexFromAnimaisApagadosExistentesOffline(0);
        safeSetState(() {});
      }
      if ((FFAppState().animaisProdutoresOffline.length == 0) &&
          (FFAppState().animaisProdutoresEditados.length == 0) &&
          (FFAppState().acoesOffline.length == 0)) {
        FFAppState().verificaInternet = -1;
        FFAppState().contador = -1;
        safeSetState(() {});
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sincronização concluída.',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
        return;
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Falha na sincronização!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
        Navigator.pop(context);

        context.goNamed(
          AcoesFalhadasWidget.routeName,
          queryParameters: {
            'uidPropriedade': serializeParam(
              widget.uidPropriedade,
              ParamType.DocumentReference,
            ),
            'uidTecnico': serializeParam(
              widget.uidTecnico,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
        );

        return;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.8,
        height: 250.0,
        decoration: BoxDecoration(
          color: Color(0xFEFFFFFF),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: Lottie.asset(
                'assets/jsons/Animation_-_1722396730254.json',
                width: 150.0,
                height: 150.0,
                fit: BoxFit.contain,
                animate: true,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
              child: Text(
                'Não feche esta tela até concluir a sincronização de dados.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: Color(0xFF2C2C2C),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
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
