import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../core/connectivity/connectivity_service.dart';
import '../../core/sync/assinatura_local.dart';
import '../../objectbox.g.dart';
import '../firebase_storage/storage.dart';
import 'objectbox_service.dart';
import 'repositories/resumo_visita_repository.dart';

/// Arquivos das assinaturas do receituário e o envio deles ao Storage.
///
/// Ver [ehAssinaturaLocal] para o porquê do formato `local:<arquivo>`.
class AssinaturasLocais {
  AssinaturasLocais._();

  static Future<Directory> _pasta() async {
    final docs = await getApplicationDocumentsDirectory();
    final pasta = Directory('${docs.path}/assinaturas');
    if (!pasta.existsSync()) await pasta.create(recursive: true);
    return pasta;
  }

  /// Grava o PNG no aparelho e devolve a referência para o campo do resumo.
  static Future<String> salvar(Uint8List png) async {
    final nome = 'signature_${DateTime.now().microsecondsSinceEpoch}.png';
    await File('${(await _pasta()).path}/$nome').writeAsBytes(png, flush: true);
    return referenciaLocal(nome);
  }

  /// Arquivo da assinatura no aparelho, ou `null` se não houver.
  ///
  /// Para `local:` é o arquivo gravado ao assinar. Para URL é a cópia guardada
  /// pelo nome do objeto no Storage: a do próprio upload (o arquivo local não
  /// é apagado ao subir) ou a de um download anterior.
  static Future<File?> arquivo(String? referencia) async {
    if (referencia == null || referencia.trim().isEmpty) return null;
    final nome = ehAssinaturaLocal(referencia)
        ? nomeArquivoLocal(referencia)
        : nomeArquivoDaUrl(referencia);
    if (nome == null) return null;
    final f = File('${(await _pasta()).path}/$nome');
    return f.existsSync() ? f : null;
  }

  /// Bytes da assinatura, seja ela local ou uma URL do Storage.
  ///
  /// Usa a cópia do aparelho quando existe; senão baixa e guarda a cópia, e a
  /// próxima geração do PDF não depende mais da rede. Falha de rede vira
  /// `null`: o PDF sai sem a imagem em vez de não sair.
  static Future<Uint8List?> bytes(String? referencia) async {
    final local = await arquivo(referencia);
    if (local != null) return local.readAsBytes();
    if (referencia == null || ehAssinaturaLocal(referencia)) return null;
    try {
      final resp = await http
          .get(Uri.parse(referencia))
          .timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return null;
      final nome = nomeArquivoDaUrl(referencia);
      if (nome != null) {
        try {
          await File('${(await _pasta()).path}/$nome')
              .writeAsBytes(resp.bodyBytes, flush: true);
        } catch (_) {}
      }
      return resp.bodyBytes;
    } catch (e) {
      debugPrint('⚠️ Assinatura indisponível ($referencia): $e');
      return null;
    }
  }

  static Future<void>? _emAndamento;

  /// Sobe ao Storage as assinaturas ainda locais e troca a referência pela URL.
  ///
  /// Chamado logo após assinar e a cada ciclo de sync. Chamadas simultâneas
  /// compartilham a mesma execução para não subir o mesmo arquivo duas vezes.
  static Future<void> enviarPendentes() =>
      _emAndamento ??= _enviarPendentes().whenComplete(() {
        _emAndamento = null;
      });

  static Future<void> _enviarPendentes() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // Offline o `putData` do Storage fica retentando por minutos em vez de
    // falhar; melhor nem tentar e esperar o próximo ciclo.
    if (uid == null || !ConnectivityService.instance.isOnline) return;

    final box = ObjectBoxService.instance.resumoVisitaBox;
    final pendentes = box
        .query(ResumoVisitaEntity_.assinaturaTecnico
            .startsWith(prefixoAssinaturaLocal)
            .or(ResumoVisitaEntity_.assinaturaProdutor
                .startsWith(prefixoAssinaturaLocal)))
        .build()
        .find();

    var enviadas = 0;
    for (final resumo in pendentes) {
      final urlTecnico = await _subir(resumo.assinaturaTecnico, uid);
      final urlProdutor = await _subir(resumo.assinaturaProdutor, uid);
      if (urlTecnico == null && urlProdutor == null) continue;

      // Relê: durante o upload a tela pode ter salvo o resumo (concluir a
      // visita, observação). Gravar a cópia antiga desfaria essas mudanças.
      final atual = box.get(resumo.id);
      if (atual == null) continue;
      if (urlTecnico != null &&
          atual.assinaturaTecnico == resumo.assinaturaTecnico) {
        atual.assinaturaTecnico = urlTecnico;
      }
      if (urlProdutor != null &&
          atual.assinaturaProdutor == resumo.assinaturaProdutor) {
        atual.assinaturaProdutor = urlProdutor;
      }
      await ResumoVisitaRepository().save(atual);
      enviadas++;

      // O arquivo local fica: o upload usa o mesmo nome, então ele vira a
      // cópia da URL e o PDF não precisa baixar o que acabou de subir.
    }

    if (enviadas > 0) {
      debugPrint('✍️ $enviadas assinatura(s) enviada(s) ao Storage');
    }
  }

  /// URL de download da assinatura local [referencia], ou `null` se ela não
  /// for local, o arquivo faltar ou o upload falhar (tenta de novo no
  /// próximo ciclo).
  static Future<String?> _subir(String? referencia, String uid) async {
    if (!ehAssinaturaLocal(referencia)) return null;
    final f = await arquivo(referencia);
    if (f == null) {
      debugPrint('⚠️ Arquivo da assinatura sumiu: $referencia');
      return null;
    }
    // Nome do arquivo no caminho: repetir o envio regrava o mesmo objeto em
    // vez de criar outro.
    return uploadData(
      'users/$uid/uploads/${nomeArquivoLocal(referencia!)}',
      await f.readAsBytes(),
    );
  }
}
