import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_simple/authmodelpublic.dart';
import 'package:flutter_login_simple/src/auth/authmodel.dart';
import 'package:flutter_login_simple/src/auth/authservice.dart';
import 'package:flutter_login_simple/src/widget/modaldialog.dart';
import 'package:get/get.dart';

enum ScreenState {
  login,
  signup,
  passwordForgotten,
  passwordCode,
  termsAndConditions,
  privacy,
}

class ScreenService extends GetxService {
  final sAuth = Get.find<AuthService>();
  late final Image logo;
  late final Function onLoginSuccess;
  late final Worker worker;
  final formKey = GlobalKey<FormState>();
  final screenState = ScreenState.login.obs;
  var isPasswordObscure1 = true.obs;
  var isPasswordObscure2 = true.obs;
  var feedbackHint = ''.obs;
  var feedbackError = ''.obs;
  var htmlToc = '<h1>ToC</h1><h2> headline 2</h2><b>lal la la</b>';
  var htmlPrivacy = '<h1>Privacy</h1><h2> headline 2</h2><b>lal la la</b>';

  var isAsyncTaskButton = false.obs;

  late StreamSubscription<User?> sub;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController codeController = TextEditingController();

  @override
  onReady() {
    super.onReady();
    worker = ever(screenState, (_) => resetInfoAndError());
  }

  @override
  onClose() {
    sub.cancel();
    worker.dispose();
    super.onClose();
  }

  ScreenService(Image logoInit, Function onLoginSuccessInit, String htmlTocInit,
      String htmlPrivacyInit) {
    logo = logoInit;
    onLoginSuccess = onLoginSuccessInit;
    htmlToc = htmlTocInit;
    htmlPrivacy = htmlPrivacyInit;
  }

  /// Gets called from [AuthService] if login is already existing.
  autoLogin(UserSessionData user) {
    resetInfoAndError();
    onLoginSuccess.call(user);
  }

  // -------------------------------------------------------------
  // ROUTING
  // -------------------------------------------------------------

  void goLogin() => screenState.value = ScreenState.login;
  void goSignup() => screenState.value = ScreenState.signup;
  void goPasswordForgotten() =>
      screenState.value = ScreenState.passwordForgotten;
  void goPasswordCode() => screenState.value = ScreenState.passwordCode;
  void goToc() => ModalDialog.open(htmlToc);
  void goPrivacy() => ModalDialog.open(htmlPrivacy);

  // -------------------------------------------------------------
  // FORM SUBMITS
  // -------------------------------------------------------------

  _warningFirebaseNotReady(UserSessionException ex) {
    if (ex.errorCode == 'internal-error') {
      log('=== DID YOU SETUP EMAIL AUTHENTICATION IN FIREBASE CONSOLE?');
      log('=== DID YOU RUN "flutterfire config"?');
      log('=== DID YOU RUN "firebase init"?');
    }
  }

  /// Clears Errors and Infos on screen navigation.
  resetInfoAndError() {
    feedbackHint.value = '';
    feedbackError.value = '';
    passwordController.text = '';
    passwordConfirmController.text = '';
    codeController.text = '';
  }

  Future<void> onSignup() async {
    if (formKey.currentState!.validate()) {
      log('FORM SIGNUP OK');

      isAsyncTaskButton.value = true;
      var data = await sAuth.createUserWithEmailAndPassword(
          emailController.text, passwordController.text);
      isAsyncTaskButton.value = false;

      if (data is UserSessionData) {
        // Done by AuthService
        // onLoginSuccess.call(data);
      } else {
        data = (data as UserSessionException);
        feedbackError.value = '${data.errorMessage} (${data.errorCode})';
        _warningFirebaseNotReady(data);
      }
    } else {
      log('FORM SIGNUP NOT OK');
    }
  }

  Future<void> onLogin() async {
    if (formKey.currentState!.validate()) {
      log('FORM LOGIN OK');

      isAsyncTaskButton.value = true;
      var data = await sAuth.signInWithEmailAndPassword(
          emailController.text, passwordController.text);

      if (data is UserSessionData) {
        // Done by AuthService
        // onLoginSuccess.call(data);
      } else {
        data = (data as UserSessionException);
        feedbackError.value = '${data.errorMessage} (${data.errorCode})';
        _warningFirebaseNotReady(data);
      }
    } else {
      log('FORM LOGIN NOT OK');
    }
    isAsyncTaskButton.value = false;
  }

  Future<void> onPasswordForgotten() async {
    if (formKey.currentState!.validate()) {
      log('FORM PASSWORD FORGOTTEN OK');

      isAsyncTaskButton.value = true;
      var data = await sAuth.sendPasswordResetEmail(emailController.text);

      if (data == null) {
        feedbackHint.value =
            'A password reset email has been sent to: ${emailController.text}';
        emailController.text = '';
      } else {
        data = (data as UserSessionException);
        feedbackError.value = '${data.errorMessage} (${data.errorCode})';
        _warningFirebaseNotReady(data);
      }
      // goPasswordCode();
    } else {
      log('FORM PASSWORD FORGOTTEN NOT OK');
    }
    isAsyncTaskButton.value = false;
  }

  /// @todo For phone
  Future<void> onPasswordCode() async {
    if (formKey.currentState!.validate()) {
      log('CODE CONFIRM OK');

      isAsyncTaskButton.value = true;
      var data = await sAuth.checkActionCode(codeController.text);

      if (data is UserSessionData) {
        feedbackHint.value = 'Code confirmed, please login.';
      } else {
        data = (data as UserSessionException);
        feedbackError.value = '${data.errorMessage} (${data.errorCode})';
        _warningFirebaseNotReady(data);
      }
    } else {
      log('CODE CONFIRM NOT OK');
    }
    isAsyncTaskButton.value = false;
  }

  /// Called by Enter-key in TextFormField.
  submitCurrentForm() {
    switch (screenState.value) {
      case ScreenState.login:
        onLogin();
        break;
      case ScreenState.signup:
        onSignup();
        break;
      case ScreenState.passwordForgotten:
        onPasswordForgotten();
        break;
      case ScreenState.termsAndConditions:
        goToc();
        break;
      case ScreenState.privacy:
        goPrivacy();
        break;
      case ScreenState.passwordCode:
        onPasswordCode();
        break;
    }
  }

  // -------------------------------------------------------------
  // FORM HELPERS
  // -------------------------------------------------------------

  doTogglePasswordObscurity1() =>
      isPasswordObscure1.value = !isPasswordObscure1.value;

  doTogglePasswordObscurity2() =>
      isPasswordObscure2.value = !isPasswordObscure2.value;

  bool passwordsMismatch() =>
      passwordConfirmController.text != passwordController.text;
}
