import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            }

            return const LoginView();
          // final user = FirebaseAuth.instance.currentUser;
          // print(user);
          // final emailVerified = user?.emailVerified ?? false;
          // if (user == null) {
          //   print("NotLogged in");
          // }
          // if (emailVerified) {
          //   print("User Verified");
          //   // FirebaseAuth.instance.signOut();
          //   return const VerifyEmailPage();
          // } else {
          //   // Navigator.pushReplacementNamed(context, "/verify-email");
          //   return const Text("Done");
          // }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
