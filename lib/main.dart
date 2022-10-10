import 'package:flutter/material.dart';
import 'package:flutter_login_simple/src/auth/authservice.dart';
import 'package:flutter_login_simple/src/screenservice.dart';
import 'package:flutter_login_simple/src/widget/login.dart';
import 'package:flutter_login_simple/src/widget/passwordCode.dart';
import 'package:flutter_login_simple/src/widget/passwordForgotten.dart';
import 'package:flutter_login_simple/src/widget/signup.dart';
import 'package:get/get.dart';

class LoginStarter extends StatelessWidget {
  final String htmlToc;
  final String htmlPrivacy;
  final Function onLoginSuccess;
  final Image logo;
  const LoginStarter(
      this.logo, this.onLoginSuccess, this.htmlToc, this.htmlPrivacy,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthService());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(logo, onLoginSuccess, htmlToc, htmlPrivacy),
    );
  }
}

class MainPage extends StatelessWidget {
  late final ScreenService c;

  MainPage(
      Image logo, Function onLoginSuccess, String htmlToc, String htmlPrivacy,
      {super.key}) {
    c = Get.put(ScreenService(logo, onLoginSuccess, htmlToc, htmlPrivacy));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(body: _switch(c.screenState.value)));
  }

  _switch(ScreenState state) {
    switch (state) {
      case ScreenState.login:
        return Login();
      case ScreenState.signup:
        return Signup();
      case ScreenState.passwordForgotten:
        return PasswordForgotten();
      // case ScreenState.termsAndConditions:
      //   return const Toc();
      // case ScreenState.privacy:
      //   return const Privacy();
      case ScreenState.passwordCode:
        return PasswordCode();
      default:
        throw 'Cannot route to screen: $state';
    }
  }
}
