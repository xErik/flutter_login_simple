import 'package:firebase_auth/firebase_auth.dart';

class UserSession {}

// class UserSessionData extends UserSession {
//   final String uid;
//   final String? email;
//   final String? displayName;
//   final bool emailVerified;
//   final bool isAnonymous;
//   final String? phoneNumber;
//   final String? photoURL;

//   UserSessionData(
//     this.uid,
//     this.email,
//     this.displayName,
//     this.emailVerified,
//     this.isAnonymous,
//     this.phoneNumber,
//     this.photoURL,
//   );
// }

class UserSessionException extends UserSession {
  String errorCode;
  String errorMessage;

  UserSessionException([this.errorCode = '', this.errorMessage = '']);
}

class UserSessionSuccess extends UserSession {}

class UserSessionCredentials extends UserSession {
  final UserCredential credentials;

  UserSessionCredentials(
    this.credentials,
  );
}
