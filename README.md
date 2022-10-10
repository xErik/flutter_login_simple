# flutter_login_simple

A basic login for Firebase Authentication by email.

Handles the UI and Firebase Authentication in the background. It has to be initialized with:

- Image logo
- Callback function on succesful login
- Privacy HTML
- Terms of Service HTML

The callback receives user data (`uid`, `email`, ...). It also allows for calls like `user.logout()` and `user.delete()`.

A live demo can be found here: [https://xerik.github.io/flutter_login_simple/](https://xerik.github.io/flutter_login_simple/).

## Outlook

Add more login options and potentially theming.

## Installation

`flutter pub get flutter_login_simple`

## Basic usage

Please refer to the complete (example)[example/example.md].

```dart
Image logo = Image.network(
    'https://storage.googleapis.com/cms-storage-bucket/c823e53b3a1a7b0d36a9.png');

onLoginSuccess(UserSessionData user) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginSuccessPage(user)),
    );
}

String htmlToc = '<h1>Terms of Service</h1>';

String htmlPrivacy = '<h1>Privacy Policy</h1>';

return LoginStarter(logo, onLoginSuccess, htmlToc, htmlPrivacy);
```

## Bugs and Requests

If you encounter any problems feel free to open an issue. Pull request are also welcome.

https://github.com/xErik/flutter_login_simple/issues

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details