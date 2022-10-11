import 'package:flutter/material.dart';
import 'package:flutter_login_simple/src/auth/authservice.dart';
import 'package:flutter_login_simple/src/screenservice.dart';
import 'package:flutter_login_simple/src/view/login.dart';
import 'package:flutter_login_simple/src/view/passwordCode.dart';
import 'package:flutter_login_simple/src/view/passwordForgotten.dart';
import 'package:flutter_login_simple/src/view/signup.dart';
import 'package:get/get.dart';

class LoginStarterConfiguration {
  Image logo;
  Function onLoginSuccess;
  String htmlToc;
  String htmlPrivacy;
  bool disableLogin;
  bool disableSignUp;
  bool disablePasswordReset;

  LoginStarterConfiguration(
      this.logo, this.onLoginSuccess, this.htmlToc, this.htmlPrivacy,
      {this.disableLogin = false,
      this.disableSignUp = false,
      this.disablePasswordReset = false});
}

class LoginStarter extends StatelessWidget {
  final LoginStarterConfiguration config;
  const LoginStarter(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthService());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(config),
    );
  }
}

class MainPage extends StatelessWidget {
  late final ScreenService c;

  MainPage(LoginStarterConfiguration config, {super.key}) {
    c = Get.put(ScreenService(config));
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
