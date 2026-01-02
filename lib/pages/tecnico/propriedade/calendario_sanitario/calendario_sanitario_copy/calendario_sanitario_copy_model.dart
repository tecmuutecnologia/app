import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'calendario_sanitario_copy_widget.dart'
    show CalendarioSanitarioCopyWidget;
import 'package:flutter/material.dart';

class CalendarioSanitarioCopyModel
    extends FlutterFlowModel<CalendarioSanitarioCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
  }

  @override
  void dispose() {}
}
