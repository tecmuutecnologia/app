import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/ui/flutter_flow_drop_down.dart';
import 'package:tecmuu/core/ui/form_field_controller.dart';

/// Um dropdown condicional (touro) que aparece NA POSIÇÃO de outro (status):
/// o Flutter reaproveita o estado do primeiro para o segundo.
class _Form extends StatefulWidget {
  const _Form({required this.mostrarTouro, required this.touros});
  final bool mostrarTouro;
  final List<String?> touros;
  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final touroCtrl = FormFieldController<String>(null);
  final statusCtrl = FormFieldController<String>('Vazia');

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Column(children: [
            if (widget.mostrarTouro)
              FlutterFlowDropDown<String>(
                controller: touroCtrl,
                options: const ['Esquire'],
                onChanged: (v) => widget.touros.add(v),
                hidesUnderline: true,
                isSearchable: false,
                isMultiSelect: false,
                textStyle: const TextStyle(),
                elevation: 0,
                borderWidth: 0,
                borderRadius: 0,
                borderColor: Colors.transparent,
                margin: EdgeInsets.zero,
              ),
            FlutterFlowDropDown<String>(
              controller: statusCtrl,
              options: const ['Vazia', 'Inseminada'],
              onChanged: (_) {},
              hidesUnderline: true,
              isSearchable: false,
              isMultiSelect: false,
              textStyle: const TextStyle(),
              elevation: 0,
              borderWidth: 0,
              borderRadius: 0,
              borderColor: Colors.transparent,
              margin: EdgeInsets.zero,
            ),
          ]),
        ),
      );
}

void main() {
  testWidgets('dropdown que aparece no lugar de outro ainda avisa a escolha',
      (tester) async {
    final touros = <String?>[];
    await tester.pumpWidget(_Form(mostrarTouro: false, touros: touros));
    await tester.pumpWidget(_Form(mostrarTouro: true, touros: touros));

    final state = tester.state<_FormState>(find.byType(_Form));
    state.touroCtrl.value = 'Esquire';
    await tester.pump();

    expect(touros, ['Esquire']);
  });
}
