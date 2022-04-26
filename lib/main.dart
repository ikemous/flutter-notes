import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/common/url_strategy.dart';
import 'package:mynotes/pages/home_page.dart';
import 'package:mynotes/views/login_View.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'firebase_options.dart';
import "package:mynotes/common/routes.dart";
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   if (user == null) {
  //     print(user);
  //   } else {
  //     print("user not logged in");
  //   }
  // });

  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      LOGIN_ROUTE: (context) => const LoginView(),
      REGISTER_ROUTE: (context) => const RegisterView(),
      NOTES_ROUTE: (context) => const NotesView(),
      VERIFY_EMAIL_ROUTE: (context) => const VerifyEmailView(),
    },
  ));
}
