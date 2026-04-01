/// ObjectBox - Banco de dados offline local
///
/// Este módulo fornece funcionalidades de cache local e sincronização
/// com o Firestore para funcionamento offline do aplicativo.
///
/// ## Arquitetura
///
/// - **ObjectBoxService**: Gerencia a conexão com o banco ObjectBox
/// - **SyncService**: Sincroniza dados entre ObjectBox e Firestore
/// - **Repositories**: Camada de abstração para acesso aos dados
/// - **Entities**: Modelos de dados para o ObjectBox
///
/// ## Uso
///
/// ```dart
/// // Inicialização (no main.dart)
/// await ObjectBoxService.initialize();
/// await SyncService.initialize();
///
/// // Uso dos repositórios
/// final animalRepo = AnimalRepository();
/// final animais = animalRepo.getAnimaisByPropriedade('path/to/propriedade');
/// ```

export 'objectbox_service.dart';
export 'sync_service.dart';
export 'entities/index.dart';
export 'repositories/index.dart';
export 'widgets/index.dart';
