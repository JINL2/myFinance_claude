import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'radio_button_widget.dart' show RadioButtonWidget;
import 'package:flutter/material.dart';

class RadioButtonModel extends FlutterFlowModel<RadioButtonWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Additional helper methods.
  String? get radioButtonValue => radioButtonValueController?.value;
}
