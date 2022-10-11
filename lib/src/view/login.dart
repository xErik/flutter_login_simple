import 'package:flutter/material.dart';
import 'package:flutter_login_simple/src/view/widget/widgethelper.dart';

class Login extends WidgetHelper {
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    super.children.clear();
    super.children.addAll([
      logo,
      spacerLargeLarge,
      feedbackError,
      feedbackHint,
      buttonResend,
      loginHeader,
      spacerLarge,
      email,
      spacer,
      password,
      spacer,
      passwordHint,
      spacer,
      buttonLogin,
      spacerLarge,
      signupHint,
    ]);
    return super.build(context);
  }
}
