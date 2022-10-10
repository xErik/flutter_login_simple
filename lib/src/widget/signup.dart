import 'package:flutter/material.dart';
import 'package:flutter_login_simple/src/widget/widgethelper.dart';

class Signup extends WidgetHelper {
  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    super.children.clear();
    super.children.addAll([
      logo,
      spacerLargeLarge,
      feedbackError,
      feedbackHint,
      signupHeader,
      spacerLarge,
      email,
      spacer,
      password,
      spacer,
      password2,
      // spacerLarge,
      spacerLarge,
      tocAndPrivacyHint,
      spacerLarge,
      buttonSignup,
      spacerLarge,
      loginHint,
    ]);
    return super.build(context);
  }
}
