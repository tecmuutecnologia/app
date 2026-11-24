import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_button.dart';
import '/core/ui/app_card.dart';
import '/data/objectbox/entities/index.dart';
import '/domain/animais/baixa_animal.dart';
import '/domain/animais/classificacao_animal.dart';
import '/features/animais/application/baixa_animal_service.dart';

/// Formulário de venda de um animal: data (hoje por padrão) e valor, os dois
/// obrigatórios. Fecha com `true` quando a venda foi gravada.
class VenderAnimalWidget extends StatefulWidget {
  const VenderAnimalWidget({
    super.key,
    required this.animal,
    required this.propriedadePath,
    this.service,
  });

  final AnimalEntity animal;
  final String propriedadePath;

  /// Injetável para teste; o padrão grava no ObjectBox.
  final BaixaAnimalService? service;

  @override
  State<VenderAnimalWidget> createState() => _VenderAnimalWidgetState();
}

class _VenderAnimalWidgetState extends State<VenderAnimalWidget> {
  final _formKey = GlobalKey<FormState>();
  final String _dataInicial = DateFormat('dd/MM/yyyy').format(DateTime.now());
  late final TextEditingController _data =
      TextEditingController(text: _dataInicial);
  final _valor = TextEditingController();
  // A máscara precisa conhecer o texto inicial: sem isso ela embaralha a
  // primeira edição sobre a data pré-preenchida.
  late final _mascaraData =
      MaskTextInputFormatter(mask: '##/##/####', initialText: _dataInicial);
  bool _salvando = false;

  @override
  void dispose() {
    _data.dispose();
    _valor.dispose();
    super.dispose();
  }

  String get _titulo {
    final nome = (widget.animal.nomeAnimal ?? '').trim();
    final brinco = widget.animal.brincoAnimal;
    if (nome.isNotEmpty) return nome;
    return brinco > 0 ? 'Brinco $brinco' : 'animal';
  }

  Future<void> _escolherData() async {
    final hoje = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: parseDataBrOuHoje(_data.text, hoje),
      firstDate: DateTime(hoje.year - 5),
      lastDate: hoje,
      // Cores da marca: o padrão do Material é azul e destoa do app.
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: AppTokens.brand),
        ),
        child: child!,
      ),
    );
    if (escolhida != null) {
      // Atualiza a máscara junto, pelo mesmo motivo do `initialText`.
      _data.value = _mascaraData.updateMask(
          newValue: TextEditingValue(
              text: DateFormat('dd/MM/yyyy').format(escolhida)));
    }
  }

  Future<void> _salvar() async {
    if (_salvando) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _salvando = true);
    try {
      await (widget.service ?? BaixaAnimalService()).vender(
        animal: widget.animal,
        propriedadePath: widget.propriedadePath,
        dtVenda: _data.text.trim(),
        valor: parseValorReais(_valor.text)!,
      );
      if (mounted) Navigator.of(context).maybePop(true);
    } on StateError catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: tema.secondaryBackground,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTokens.radius)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // titleMedium do tema é branco (feito para cabeçalhos coloridos).
              Text('Vender $_titulo',
                  style: tema.titleMedium.copyWith(color: tema.primaryText)),
              const SizedBox(height: 4),
              Text(
                // Um descartado já saiu do rebanho: só muda para vendido.
                ehDescarte(widget.animal.status)
                    ? 'O animal passa para os vendidos e a receita entra no Financeiro.'
                    : 'O animal sai do rebanho e a receita entra no Financeiro.',
                style: tema.bodySmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('venda-data'),
                controller: _data,
                keyboardType: TextInputType.number,
                inputFormatters: [_mascaraData],
                decoration: InputDecoration(
                  labelText: 'Data da venda',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    tooltip: 'Escolher data',
                    onPressed: _escolherData,
                  ),
                ),
                validator: (v) =>
                    validarDataVenda(v ?? '', hoje: DateTime.now()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('venda-valor'),
                controller: _valor,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Valor da venda (R\$)',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => parseValorReais(v ?? '') == null
                    ? 'Informe o valor da venda'
                    : null,
              ),
              const SizedBox(height: 20),
              AppButton(
                text: _salvando ? 'Salvando...' : 'Salvar',
                icon: Icons.check,
                onPressed: _salvando ? null : _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data digitada, se válida e não futura; senão hoje (para o seletor).
DateTime parseDataBrOuHoje(String texto, DateTime hoje) {
  final d = validarDataVenda(texto, hoje: hoje) == null
      ? DateFormat('dd/MM/yyyy').parseStrict(texto)
      : null;
  return d ?? hoje;
}
