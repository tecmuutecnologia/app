# [CONCLUÍDO] Colocar a estruturas dos arquivos no formato Flutter pois atualrmente estao com os diretorios no formato do flutterFlow
#   -> 100% das telas migradas p/ lib/features/<f>/presentation/; lib/pages e index.dart removidos.
#      Resíduo restante: lib/app_state.dart (FFAppState god object) = plano à parte (risco de perda de dados offline).
# Ajustar o tamanho dos arquivos que estão com muitas linhas
#   -> build()s dos monstros já quebrados em sub-métodos _pN (Fase 4). Separar em arquivos
#      widgets/ = refactor de alto risco/baixo retorno sem validação em device. Não feito de propósito.
# [EM ANDAMENTO] Reestruturar o layout com base em layout_inspirations
#   -> fundação criada: lib/core/ui/app_card.dart (AppTokens + AppCard, sombra suave/raio 16),
#      cores mantidas. Aplicado no dashboard. Rolar p/ demais telas exige validação visual em device.
# [CONCLUÍDO-código] Adicionar o objectbox admin para debug
#   -> objectbox_debug_service.dart pronto + dep no pubspec. Rodar `flutter pub get` p/ ativar
#      (o sandbox não alcançou o pub.dev). Botão no menu de debug (kDebugMode) sobe UI em :8090.
# Testar o APP  (sua ação — inclui validar: dashboard reskinado + resgate offline legado das prefs)