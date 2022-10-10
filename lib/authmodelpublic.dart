import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_simple/src/auth/authmodel.dart';
import 'package:flutter_login_simple/src/auth/authservice.dart';
import 'package:get/get.dart';

/// Holds Firebase Authentication user data to display. Offers [deleteUser]
/// and [logoutUser]. Offers [firebaseUser] for advanced operations.
class UserSessionData extends UserSession {
  /// User uid
  final String uid;

  /// Email
  final String? email;

  /// Display name
  final String? displayName;

  /// Is the email verified?
  final bool emailVerified;

  /// Is the user anonymous?
  final bool isAnonymous;

  /// Phone number
  final String? phoneNumber;

  /// Photo url
  final String? photoURL;

  /// Deletes the user in Firebase Authentication.
  /// Returns [true] in case of success.
  Future<bool> deleteUser() async {
    return (await Get.find<AuthService>().deleteUser()) is UserSessionSuccess;
  }

  /// Signs out the user from Firebase Authentication.
  Future<void> logoutUser() async {
    return Get.find<AuthService>().signOut();
  }

  /// Returns the Firebase User for advanced operations.
  /// Be careful.
  User? firebaseUser() {
    return Get.find<AuthService>().firebaseUser();
  }

  /// Constructor.
  UserSessionData(
    this.uid,
    this.email,
    this.displayName,
    this.emailVerified,
    this.isAnonymous,
    this.phoneNumber,
    this.photoURL,
  );
}
