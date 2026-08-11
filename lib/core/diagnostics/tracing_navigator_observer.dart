import 'package:flutter/material.dart';

import 'query_tracer.dart';

/// Observer TEMPORÁRIO de diagnóstico: publica a rota atual no [QueryTracer]
/// para que cada linha de query no log diga em qual tela ela aconteceu.
class TracingNavigatorObserver extends NavigatorObserver {
  String _nome(Route<dynamic>? route) =>
      route?.settings.name ?? route?.settings.arguments?.toString() ?? '?';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    QueryTracer.setRota(_nome(route));
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    QueryTracer.setRota(_nome(previousRoute));
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    QueryTracer.setRota(_nome(newRoute));
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
