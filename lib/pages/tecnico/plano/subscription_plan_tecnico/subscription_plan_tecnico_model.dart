import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'subscription_plan_tecnico_widget.dart'
    show SubscriptionPlanTecnicoWidget;
import 'package:flutter/material.dart';

class SubscriptionPlanTecnicoModel
    extends FlutterFlowModel<SubscriptionPlanTecnicoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  int? dropDownValue1;
  FormFieldController<int>? dropDownValueController1;
  // State field(s) for DropDown widget.
  double? dropDownValue2;
  FormFieldController<double>? dropDownValueController2;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  AssinaturaTecnicoRecord? outUidAssinaturaTecnico;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  AssinaturaAtivaTecnicoRecord? outUidAssinaturaAtiva;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PlanosTecnicosRecord? outUidPlanoFree;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AssinaturaTecnicoRecord? outUidNovoPlano;
  // Stores action output result for [Stripe Payment] action in Button widget.
  String? outUidPayment;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PlanosTecnicosRecord? outUidPlanoEscolhido;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  AssinaturaTecnicoRecord? outUidAssinaturaPlanoStripe;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  AssinaturaAtivaTecnicoRecord? outUidAssinaturaAtivaStripe;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AssinaturaTecnicoRecord? outUidNovoPlanoPago;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
