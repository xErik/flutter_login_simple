import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_simple/src/screenservice.dart';
import 'package:flutter_login_simple/src/widget/resendbutton.dart';
import 'package:get/get.dart';

class WidgetHelper extends StatelessWidget {
  final service = Get.find<ScreenService>();

  final List<Widget> children = <Widget>[];

  WidgetHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints box) {
      return ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                      minWidth: 250, // @todo is not respected
                    ),
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                                key: service.formKey,
                                child: Column(children: children))))))
          ]);
    });
  }

  // -------------------------------------------------------------
  // LOGO
  // -------------------------------------------------------------

  get logo => Center(child: SizedBox(height: 50, child: service.logo));

  // -------------------------------------------------------------
  // SPACERS
  // -------------------------------------------------------------

  get spacer => const SizedBox(height: 8);
  get spacerLarge => const SizedBox(height: 16);
  get spacerLargeLarge => const SizedBox(height: 32);

  // -------------------------------------------------------------
  // HINTS
  // -------------------------------------------------------------

  get loginHint => TextButton(
      onPressed: () => service.goLogin(),
      child: const Text('Already have an account? Login!'));
  get signupHint => TextButton(
      onPressed: () => service.goSignup(),
      child: const Text('Don\'t have an account? Signup!'));
  get passwordHint => TextButton(
      onPressed: () => service.goPasswordForgotten(),
      child: const Text('Password forgotten?'));

  get tocAndPrivacyHint {
    TextStyle defaultStyle = const TextStyle(color: Colors.grey);
    TextStyle linkStyle = const TextStyle(fontWeight: FontWeight.bold);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          const TextSpan(text: 'By creating an account you accept the '),
          TextSpan(
              text: 'Terms of Service',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () => service.goToc()),
          const TextSpan(text: ' and the '),
          TextSpan(
              text: 'Privacy Policy',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () => service.goPrivacy()),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // USER FEEDBACK
  // -------------------------------------------------------------

  get feedbackError {
    final color = Theme.of(Get.context!).colorScheme.error;
    return Obx(() => service.feedbackError.isEmpty
        ? const SizedBox.shrink()
        : _feedback(
            color, Icons.error_outline, 'Error', service.feedbackError.value));
  }

  get feedbackHint {
    final color = Theme.of(Get.context!).colorScheme.tertiary;
    return Obx(() => service.feedbackHint.isEmpty
        ? const SizedBox.shrink()
        : _feedback(
            color, Icons.info_outline, 'Info', service.feedbackHint.value));
  }

  Widget _feedback(Color color, IconData icon, String title, String text) {
    return Column(
      children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: color),
                        const SizedBox(width: 8),
                        Text(title,
                            style: TextStyle(
                                color: color, fontWeight: FontWeight.bold))
                      ],
                    ),
                    spacer,
                    Text(text, style: TextStyle(color: color)),
                  ],
                ))),
        spacerLarge
      ],
    );
  }

  // -------------------------------------------------------------
  // HEADERS
  // -------------------------------------------------------------

  get loginHeader => const Align(
      alignment: Alignment.centerLeft,
      child: Text('Login', style: TextStyle(fontSize: 32)));
  get signupHeader => const Align(
      alignment: Alignment.centerLeft,
      child: Text('Sign Up', style: TextStyle(fontSize: 32)));
  get passwordForgottenHeader => const Align(
      alignment: Alignment.centerLeft,
      child: Text('Reset Password', style: TextStyle(fontSize: 32)));
  get passwordCodeHeader => const Align(
      alignment: Alignment.centerLeft,
      child: Text('Confirm Code', style: TextStyle(fontSize: 32)));

  // -------------------------------------------------------------
  // BUTTONS
  // -------------------------------------------------------------

  /// Returns a button, showing a self adjusting progress indicator.
  Widget _loadingButton(String label, Function func) {
    final loading =
        LayoutBuilder(builder: (BuildContext ctx, BoxConstraints con) {
      return SizedBox(
          width: con.maxHeight * 0.5,
          height: con.maxHeight * 0.5,
          child: CircularProgressIndicator(
              color: Theme.of(Get.context!).colorScheme.onPrimary));
    });

    return Obx(
      () => SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () => func.call(),
            child: service.isAsyncTaskButton.isTrue ? loading : Text(label),
          )),
    );
  }

  get buttonLogin => _loadingButton('Login', service.onLogin);
  get buttonSignup => _loadingButton('Sign Up', service.onSignup);
  get buttonPassword =>
      _loadingButton('Reset Password', service.onPasswordForgotten);
  get buttonCode => _loadingButton('Confirm Code', service.onPasswordCode);

  get buttonResend {
    return Obx(
      () => service.isShowResendButton.isFalse
          ? const SizedBox.shrink()
          : Column(
              children: [
                ResendButton(),
                spacerLarge,
              ],
            ),
    );
  }

  // -------------------------------------------------------------
  // TEXTS
  // -------------------------------------------------------------

  get email => TextFormField(
        onFieldSubmitted: (_) => service.submitCurrentForm(),
        controller: service.emailController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: 'Email',
        ),
        validator: (value) {
          if (value == null || value.isEmpty || value.isEmail == false) {
            return 'Please enter an email address.';
          }
          return null;
        },
      );

  get password => Obx(() => TextFormField(
        onFieldSubmitted: (_) => service.submitCurrentForm(),
        controller: service.passwordController,
        obscureText: service.isPasswordObscure1.value,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_open),
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            icon: Icon(
              service.isPasswordObscure1.isFalse
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () => service.doTogglePasswordObscurity1(),
          ),
          hintText: 'Password',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          } else if (value.length < 6) {
            return 'Please enter at least 6 characters';
          }
          return null;
        },
      ));

  get password2 => Obx(() => TextFormField(
        onFieldSubmitted: (_) => service.submitCurrentForm(),
        controller: service.passwordConfirmController,
        obscureText: service.isPasswordObscure2.value,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_open),
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            icon: Icon(
              service.isPasswordObscure2.isFalse
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () => service.doTogglePasswordObscurity2(),
          ),
          hintText: 'Password',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          } else if (value.length < 6) {
            return 'Please enter at least 6 characters';
          } else if (service.passwordsMismatch()) {
            return 'The passwords do not match';
          }
          return null;
        },
      ));

  get passwordCode => Obx(() => TextFormField(
        onFieldSubmitted: (_) => service.submitCurrentForm(),
        controller: service.codeController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.numbers),
          hintText: 'Code',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the code';
          }
          return null;
        },
      ));
}
