import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/relatorios/application/categorias_do_relatorio.dart';

/// Sem categoria marcada, o botão "Gerar relatório" não fazia nada: a condição
/// `length >= 1` barrava o clique e nada avisava. Nenhuma marcada passa a
/// significar TODAS — que é o relatório completo que o filtro vazio sugere.
void main() {
  const disponiveis = ['Vacas', 'Novilhas', 'Bezerras'];

  test('seleção vazia traz todas', () {
    expect(categoriasDoRelatorio(const [], disponiveis), disponiveis);
  });

  test('seleção nula traz todas', () {
    expect(categoriasDoRelatorio(null, disponiveis), disponiveis);
  });

  test('seleção respeitada quando existe', () {
    expect(categoriasDoRelatorio(const ['Vacas'], disponiveis), ['Vacas']);
  });

  test('sem categorias disponíveis devolve vazio', () {
    expect(categoriasDoRelatorio(const [], const []), isEmpty);
  });
}
