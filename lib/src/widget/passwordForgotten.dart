import 'package:flutter/material.dart';
import 'package:flutter_login_simple/src/widget/widgethelper.dart';

class PasswordForgotten extends WidgetHelper {
  PasswordForgotten({super.key});

  @override
  Widget build(BuildContext context) {
    super.children.clear();
    super.children.addAll([
      logo,
      spacerLargeLarge,
      feedbackError,
      feedbackHint,
      passwordForgottenHeader,
      spacerLarge,
      email,
      spacerLarge,
      // password,
      // spacer,
      // password2,
      // // spacerLarge,
      // spacerLarge,
      // tocAndPrivacy,
      // spacerLarge,
      buttonPassword,
      spacerLarge,
      loginHint,
      spacer,
      signupHint,
    ]);
    return super.build(context);
  }
}
