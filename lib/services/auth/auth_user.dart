import 'package:firebase_auth/firebase_auth.dart' as auth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(auth.User user) => AuthUser(user.emailVerified);
}
