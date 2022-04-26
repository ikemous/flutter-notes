import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/common/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  void sendEmailVerification() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.sendEmailVerification();
  }

  void handleRestart() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      REGISTER_ROUTE,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(children: [
        const Text(
            "We've sent you an email verification. Please verify your account"),
        const Text("Haven't recieved it yet?"),
        TextButton(
          child: const Text("Re-Send Verification Email"),
          onPressed: sendEmailVerification,
        ),
        TextButton(
          onPressed: handleRestart,
          child: const Text("Restart"),
        ),
      ]),
    );
  }
}
