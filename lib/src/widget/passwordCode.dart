import 'package:flutter/material.dart';
import 'package:flutter_login_simple/src/widget/widgethelper.dart';

class PasswordCode extends WidgetHelper {
  PasswordCode({super.key});

  @override
  Widget build(BuildContext context) {
    super.children.clear();
    super.children.addAll([
      logo,
      spacerLargeLarge,
      feedbackError,
      feedbackHint,
      passwordCodeHeader,
      spacerLarge,
      passwordCode,
      spacerLarge,
      buttonCode,
      spacerLarge,
      loginHint,
      spacer,
      signupHint,
    ]);
    return super.build(context);
  }
}
