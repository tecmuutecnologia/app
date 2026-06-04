/// Tipo de retorno para operações que podem falhar, sem propagar exceptions
/// soltas pela aplicação.
///
/// Antes da refatoração, erros eram tratados de forma inconsistente — `try/catch`
/// espalhados na UI, `debugPrint` engolindo falhas, ou exceptions vazando até o
/// topo. `Result<T>` torna o sucesso/falha explícito no tipo de retorno, forçando
/// quem chama a lidar com ambos os casos.
///
/// Uso:
/// ```dart
/// final result = await repo.create(...);
/// switch (result) {
///   case Success(:final value):
///     // usa value
///   case Failure(:final message):
///     // mostra mensagem
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// `true` se a operação foi bem-sucedida.
  bool get isSuccess => this is Success<T>;

  /// `true` se a operação falhou.
  bool get isFailure => this is Failure<T>;

  /// Valor em caso de sucesso; `null` em caso de falha.
  T? get valueOrNull => switch (this) {
        Success(:final value) => value,
        Failure() => null,
      };

  /// Reduz o `Result` a um único valor, tratando os dois casos.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure<T> failure) onFailure,
  }) =>
      switch (this) {
        Success(:final value) => onSuccess(value),
        final Failure<T> f => onFailure(f),
      };
}

/// Resultado bem-sucedido, carregando o [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  String toString() => 'Success($value)';
}

/// Resultado de falha, com [message] legível e, opcionalmente, o [error]
/// original e seu [stackTrace] para diagnóstico/log.
final class Failure<T> extends Result<T> {
  const Failure(this.message, {this.error, this.stackTrace});

  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Failure($message)';
}
