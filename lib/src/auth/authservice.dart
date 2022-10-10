import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_simple/authmodelpublic.dart';
import 'package:flutter_login_simple/src/auth/authmodel.dart';
import 'package:flutter_login_simple/src/screenservice.dart';
import 'package:get/get.dart';

/// Service talking to Firebase Authentication.
class AuthService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late StreamSubscription<User?> stream;

  @override
  void onInit() {
    // Calls [ScreenService if login is already existing.]
    stream = _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        log('Login exists or is successul, routing the user ...');
        Get.find<ScreenService>().autoLogin(_userFromFirebase(user));
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    stream.cancel();
    super.onClose();
  }

  // ---------------------------------------------------------------
  //
  // ---------------------------------------------------------------

  UserSessionData _userFromFirebase(User? user) {
    if (user == null) {
      throw 'User from firebase is NULL';
    }

    return UserSessionData(user.uid, user.email, user.displayName,
        user.emailVerified, user.isAnonymous, user.phoneNumber, user.photoURL);
    // return UserSessionData(user);
  }

  _sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
    log('Email verification sent', name: runtimeType.toString());
  }

  /// Returns [UserSessionData].
  /// Call `isLoggedIn()` first.
  UserSessionData currentUser() {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  /// Returns whether a user is logged in or not.
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  User? firebaseUser() {
    return _firebaseAuth.currentUser;
  }

  // ---------------------------------------------------------------
  //
  // ---------------------------------------------------------------

  /// Returns [UserSessionData] or [UserSessionException]
  Future<UserSession> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user!.emailVerified == false) {
        log('User login in failed: email is not verified ${credential.user!.emailVerified}',
            name: runtimeType.toString());
        await _sendEmailVerification();
        return UserSessionException('email-not-verified',
            'Please confirm your email address by clicking the link in the verification email you received. Check your spam folder, too.');
      }

      log('User login success', name: runtimeType.toString());

      return _userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      log(e.toString(), name: runtimeType.toString());
      return UserSessionException(e.code, e.message ?? 'no-message');
    } catch (e) {
      log(e.toString(), name: runtimeType.toString());
      return UserSessionException('unknown-error-code', e.toString());
    }
  }

  /// Returns [UserSessionData] or [UserSessionException]
  Future<UserSession> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _sendEmailVerification();
      log('Create user', name: runtimeType.toString());
      return _userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      return UserSessionException(e.code, e.message ?? 'no-message');
    } catch (e) {
      log(e.toString(), name: runtimeType.toString());
    }
    throw 'Neither firebase USER nor EXCEPTION have been returned';
  }

  /// Returns `NULL` or [UserSessionException].
  /// `NULL` indicates success.
  Future<UserSession?> sendPasswordResetEmail(String emailX) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailX);
      log('Password reset email sent', name: runtimeType.toString());
      return null;
    } on FirebaseAuthException catch (e) {
      return UserSessionException(e.code, e.message ?? 'no-message');
    } catch (e) {
      log(e.toString(), name: runtimeType.toString());
    }
    throw 'Neither firebase USER nor EXCEPTION have been returned';
  }

  /// Logs user out, returns nothing.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    log('User signed out', name: runtimeType.toString());
  }

  /// Returns [UserSessionSuccess] or [UserSessionException]
  Future<UserSession> deleteUser() async {
    final email = _firebaseAuth.currentUser?.email ?? 'no-email';
    log('Deleting: $email', name: runtimeType.toString());

    try {
      await _firebaseAuth.currentUser?.delete();
      return UserSessionSuccess();
    } on FirebaseAuthException catch (e) {
      return UserSessionException(e.code, e.message ?? 'no-message');
    } catch (e) {
      log(e.toString(), name: runtimeType.toString());
    }
    throw 'Error deleting firebase user.';
  }

  /// Returns [UserSessionCredentials] or [UserSessionException]
  Future<UserSession> reauthenticateWithCredential(
      String email, String password) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);

    try {
      var auth = await _firebaseAuth.currentUser
          ?.reauthenticateWithCredential(credential);

      return UserSessionCredentials(auth!);
    } on FirebaseAuthException catch (e) {
      return UserSessionException(e.code, e.message ?? 'no-message');
    } catch (e) {
      log(e.toString(), name: runtimeType.toString());
    }
    throw 'Error reauthenticating.';
  }

  /// Returns `NULL` or [UserSessionException].
  /// `NULL` indicates success.
  Future<UserSession?> checkActionCode(String code) async {
    try {
      await _firebaseAuth.checkActionCode(code);
      return null;
    } on FirebaseAuthException catch (e) {
      return UserSessionException(e.code, e.message ?? 'no-message');
    } catch (e) {
      log(e.toString(), name: runtimeType.toString());
    }
    throw 'Error checking action code.';
  }
}
