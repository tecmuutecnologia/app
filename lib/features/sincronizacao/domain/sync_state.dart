import '../../../core/sync/sync_etapa.dart';

/// Quem esta entrando. Vem por parametro de rota, nao e deduzido da existencia
/// do TecnicoRecord: deduzir confundiria "produtor" com "tecnico sem perfil
/// completo", que sao destinos diferentes.
enum SyncPapel { tecnico, produtor }

enum SyncErroTipo {
  /// Uma etapa quebrou. Ha dados parciais gravados.
  falhaDownload,

  /// Offline e sem nada baixado ainda. Nao ha dado parcial com que continuar.
  semConexao,

  /// A cota do Firestore foi atingida. Os dados baixados ate aqui sao validos e
  /// o restante desce na proxima tentativa, a partir da etapa que faltou.
  cotaExcedida,
}

/// Para onde ir quando a sincronizacao terminar.
sealed class SyncDestino {
  const SyncDestino();
}

class DestinoDashboardTecnico extends SyncDestino {
  const DestinoDashboardTecnico();
}

class DestinoInicioPropriedadeProdutor extends SyncDestino {
  const DestinoInicioPropriedadeProdutor(this.propriedade);

  /// `PropriedadesRecord?`. Tipado como Object? para o dominio nao depender do
  /// schema do Firestore, o que quebraria os testes puros.
  final Object? propriedade;
}

class DestinoCompletarPerfil extends SyncDestino {
  const DestinoCompletarPerfil();
}

sealed class SyncState {
  const SyncState();
}

class SyncPreparando extends SyncState {
  const SyncPreparando();
}

class SyncBaixando extends SyncState {
  const SyncBaixando({
    required this.etapa,
    required this.rotulo,
    required this.progresso,
    this.atual,
    this.total,
    this.ritmo,
    this.eta,
  });

  final SyncEtapa etapa;
  final String rotulo;
  final double progresso;
  final int? atual;
  final int? total;

  /// Registros por segundo. Nulo enquanto nao ha amostras suficientes.
  final double? ritmo;
  final Duration? eta;

  /// Etapas curtas (um documento) nao tem contador — mostrar numero nelas so
  /// produziria um valor piscando.
  bool get temContador => atual != null && total != null && total! > 0;
}

class SyncErro extends SyncState {
  const SyncErro({
    required this.tipo,
    required this.mensagem,
    this.etapa,
  });

  final SyncErroTipo tipo;
  final SyncEtapa? etapa;
  final String mensagem;

  bool get podeContinuarAssimMesmo =>
      tipo == SyncErroTipo.falhaDownload ||
      tipo == SyncErroTipo.cotaExcedida;
}

class SyncConcluido extends SyncState {
  const SyncConcluido(this.destino);
  final SyncDestino destino;
}
