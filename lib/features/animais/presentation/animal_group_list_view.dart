import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../application/animais_providers.dart';
import '../application/ordenacao_animais.dart';
import '/domain/animais/classificacao_animal.dart';
import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';

/// Lista de animais de UMA aba (grupo) de uma propriedade, lida do
/// `AnimalRepository` (ObjectBox) via Riverpod — fonte ÚNICA, funciona online e
/// offline, e reage a edições locais (ex.: o `editar_animal` agora grava no
/// ObjectBox).
///
/// Piloto para substituir a leitura de uma aba da `lista_animais` (ex.: Vacas),
/// eliminando a dualidade StreamBuilder(Firestore)+FFAppState daquela aba.
///
/// [onTapAnimal] recebe o `firestoreId` do animal tocado, para a tela
/// reconstruir a navegação/ações existentes (ex.: abrir prontuário).
class AnimalGroupListView extends ConsumerWidget {
  const AnimalGroupListView({
    super.key,
    required this.propriedadePath,
    required this.grupo,
    this.onTapAnimal,
    this.onEditAnimal,
    this.ordem = OrdemAnimais.nome,
    this.crescente = true,
    this.busca = '',
    this.permiteDescarte = false,
    this.onDescartar,
  });

  /// Path do documento da propriedade (parentPath dos animais).
  final String propriedadePath;

  /// Nome do grupo da aba (ex.: 'Vacas', 'Novilhas', 'Touros').
  final String grupo;

  /// Callback opcional ao tocar num animal (recebe o firestoreId).
  final void Function(String firestoreId)? onTapAnimal;

  /// Callback opcional para editar um animal (recebe o firestoreId). A tela
  /// monta a navegação para EditarAnimal com seus próprios parâmetros e a
  /// referência reconstruída a partir do firestoreId. Funciona offline.
  final void Function(String firestoreId)? onEditAnimal;

  /// Ordem da lista. Vem da tela porque o botao de ordenacao vale para as 6
  /// abas de uma vez — o estado e de la, nao de cada aba.
  final OrdemAnimais ordem;

  /// `true` = A-Z / menor brinco primeiro. Como a [ordem], e estado da tela.
  final bool crescente;

  /// Termo digitado no campo de busca da tela. Filtra por nome OU brinco.
  final String busca;

  /// Libera o arrasto que pede o descarte. Padrao `false`: so a navegacao do
  /// tecnico liga isso, entao uma rota nova que esqueca o parametro nao
  /// entrega o descarte ao produtor por acidente.
  final bool permiteDescarte;

  /// Pedido de descarte de um animal (recebe o firestoreId). A tela abre o
  /// formulario de motivo/data; esta view nao decide nada sobre o descarte.
  final void Function(String firestoreId)? onDescartar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animaisAsync = ref.watch(
      animaisByGrupoProvider(
        (propriedadePath: propriedadePath, grupo: grupo),
      ),
    );

    return animaisAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Erro ao carregar animais')),
      data: (animais) {
        if (animais.isEmpty) {
          return Center(child: Text('Nenhum animal no grupo $grupo'));
        }

        final visiveis = aplicarBuscaEOrdem(animais,
            ordem: ordem, crescente: crescente, busca: busca);

        // Mensagem diferente de propsito: "grupo vazio" e "a busca nao achou"
        // sao situacoes distintas, e dizer a primeira no lugar da segunda faz
        // o usuario achar que perdeu os animais da categoria.
        if (visiveis.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Nenhum animal encontrado para "${busca.trim()}" em $grupo',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: visiveis.length,
          itemBuilder: (context, index) {
            final animal = visiveis[index];
            // Mesmo titulo que a ordenacao e a busca usam — se divergirem, a
            // lista volta a parecer desordenada.
            final titulo = tituloAnimal(animal);
            final tituloExibido = titulo.isEmpty ? 'Animal sem nome' : titulo;
            final firestoreId = animal.firestoreId;
            final card = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0x1AF75E38),
                    // Era Icons.pets — produtores e técnicos liam como pata
                    // de cão ou gato.
                    child: FaIcon(
                      FontAwesomeIcons.cow,
                      size: 18,
                      color: Color(0xFFF75E38),
                    ),
                  ),
                  title: Text(
                    tituloExibido,
                    style: FlutterFlowTheme.of(context)
                        .bodyLarge
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    [
                      'Brinco ${animal.brincoAnimal}',
                      if ((animal.status ?? '').isNotEmpty) animal.status!,
                      if ((animal.racaAnimal ?? '').isNotEmpty)
                        animal.racaAnimal!,
                    ].join(' • '),
                  ),
                  trailing: (firestoreId != null && onEditAnimal != null)
                      ? IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppTokens.secondary),
                          tooltip: 'Editar animal',
                          onPressed: () => onEditAnimal!(firestoreId),
                        )
                      : null,
                  onTap: (firestoreId == null || onTapAnimal == null)
                      ? null
                      : () => onTapAnimal!(firestoreId),
                ),
              ),
            );

            // Animal ja descartado nao se descarta de novo — era a mesma
            // guarda do card antigo (`status != 'Descarte'`).
            final podeDescartar = permiteDescarte &&
                onDescartar != null &&
                firestoreId != null &&
                !ehDescarte(animal.status);

            if (!podeDescartar) return card;

            return Dismissible(
              key: ValueKey('descarte-$firestoreId'),
              direction: DismissDirection.endToStart,
              background: _faixaDescartar(context),
              // Devolve `false` SEMPRE: o arrasto apenas PEDE o descarte. Quem
              // tira o animal da lista e a gravacao do status no ObjectBox, que
              // esta view observa. Se o card sumisse no arrasto, ele voltaria
              // piscando quando o tecnico cancelasse o formulario.
              confirmDismiss: (_) async {
                onDescartar!(firestoreId);
                return false;
              },
              child: card,
            );
          },
        );
      },
    );
  }

  /// Faixa revelada pelo arrasto. Diz "Descartar", e nao "Excluir": o animal
  /// continua na propriedade, muda de status e vai para a aba Descarte.
  Widget _faixaDescartar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).error,
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Descartar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
