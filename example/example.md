```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_simple/main.dart';
import 'package:flutter_login_simple/usersessiondata.dart';
import 'package:flutter_login_simple_demo/firebase_options.dart';

void main() async {
  // ----------------------------------------
  // Initialize Firebase Core.
  //
  // The flutter_login_simple/ will use it to authenticate.
  // ----------------------------------------
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------
    // Use this method to navigate on login-success.
    // For example:
    //
    // onLoginSuccess() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginSuccessPage()),
    //   ModalRoute.withName('/')
    // );
    // }
    //
    // ----------------------------------------
    // Or, when using Get:
    //
    // onLoginSuccess() => Get.toName('loginSuccessRoute');
    // ----------------------------------------

    // Logo for the login screen.
    Image logo = Image.network(
        'https://storage.googleapis.com/cms-storage-bucket/c823e53b3a1a7b0d36a9.png');

    // Gets triggered on succesful login
    onLoginSuccess(UserSessionData user) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => LoginSuccessPage(user)),
          ModalRoute.withName('/')
          // (Route<dynamic> route) => false
          );
    }

    // The Terms of Service (as HTML) shown in a fullscreen dialog.
    String htmlToc = '<h1>Terms of Service</h1>';

    // The Privacy Policy (as HTML) shown in a fullscreen dialog.
    String htmlPrivacy = '<h1>Privacy Policy</h1>';

    var config =
        FlutterLoginConfiguration(logo, onLoginSuccess, htmlToc, htmlPrivacy);

    return FlutterLoginSimple(config);
  }
}

/// Displaying the returned data
class LoginSuccessPage extends StatelessWidget {
  final UserSessionData user;
  const LoginSuccessPage(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Login successful!'),
        const SizedBox(height: 16),
        //
        // SHOW USER DATA
        //
        Text('uid - ${user.uid}'),
        Text('email -  ${user.email ?? 'not given'}'),
        Text('displayName - ${user.displayName ?? 'not given'}'),
        Text('emailVerified - ${user.emailVerified}'),
        Text('isAnonymous - ${user.isAnonymous}'),
        Text('phoneNumber - ${user.phoneNumber ?? 'not given'}'),
        Text('photoURL - ${user.photoURL ?? 'not given'}'),
        const SizedBox(height: 16),
        //
        // DELETE USER AND LOGOUT USER
        //
        ElevatedButton(
            onPressed: () async {
              await user.logoutUser();
              // ignore: use_build_context_synchronously
              await _showDialog('User Logged Out', context);
              // ignore: use_build_context_synchronously
              _goHome(context);
            },
            child: const Text('Logout')),
        const SizedBox(height: 16),
        ElevatedButton(
            onPressed: () async {
              if (await user.deleteUser()) {
                // ignore: use_build_context_synchronously
                await _showDialog('User Deleted', context);
                // ignore: use_build_context_synchronously
                _goHome(context);
              }
            },
            child: const Text('Delete')),
      ],
    )));
  }

  // Helper method.
  Future<void> _showDialog(String title, BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text(title));
      },
    );
  }

  // Helper method
  _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const StartPage()),
        // (Route<dynamic> route) => false
        ModalRoute.withName('/'));
  }
}
```