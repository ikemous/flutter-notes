import 'package:flutter/material.dart';
import 'package:mynotes/common/url_strategy.dart';
import 'package:mynotes/pages/home_page.dart';
import 'package:mynotes/views/login_View.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import "package:mynotes/common/routes.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

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
    debugShowCheckedModeBanner: false,
  ));
}
