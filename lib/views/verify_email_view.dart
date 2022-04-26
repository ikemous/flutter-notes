import 'package:flutter/material.dart';
import 'package:mynotes/common/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  void sendEmailVerification() async {
    AuthService.firebase().sendEmailVerification();
  }

  void handleRestart() async {
    AuthService.firebase().logOut();
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
