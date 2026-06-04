/// ObjectBox - Banco de dados offline local
///
/// Este módulo fornece funcionalidades de cache local e sincronização
/// com o Firestore para funcionamento offline-first do aplicativo.
///
/// ## Arquitetura Offline-First
///
/// 1. Ao fazer login, todos os dados são baixados do Firestore para ObjectBox
/// 2. O app trabalha localmente com ObjectBox (rápido e offline)
/// 3. Alterações são marcadas com needsSync = true
/// 4. Quando online, alterações são enviadas ao Firestore
/// 5. Ao trocar de dispositivo, dados são baixados novamente
///
/// ## Componentes
///
/// - **ObjectBoxService**: Gerencia a conexão com o banco ObjectBox
/// - **OfflineFirstSyncService**: Sincroniza dados (novo serviço recomendado)
/// - **SyncService**: Serviço de sincronização legado
/// - **ObjectBoxAuthHelper**: Helper para integração com autenticação
/// - **Repositories**: Camada de abstração para acesso aos dados
/// - **Entities**: Modelos de dados para o ObjectBox
///
/// ## Uso
///
/// ```dart
/// // Inicialização no main.dart
/// await ObjectBoxAuthHelper.initializeOfflineFirst();
///
/// // Após login do usuário
/// await ObjectBoxAuthHelper.onUserLogin(user);
///
/// // Uso dos dados locais
/// final animais = ObjectBoxService.instance.animalBox.getAll();
///
/// // Sincronização manual
/// await ObjectBoxAuthHelper.syncPendingChanges();
/// ```

// Entidades
export 'entities/index.dart';

// Serviços
export 'objectbox_service.dart';
export 'offline_first_sync_service.dart';
export 'sync_debugger_service.dart';
export 'remote_sync_listeners_service.dart';

// Helpers
export 'objectbox_auth_helper.dart';

// Repositórios
export 'repositories/index.dart';

// Widgets
export 'widgets/index.dart';
