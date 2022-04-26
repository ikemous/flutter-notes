import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/common/routes.dart';
import 'package:mynotes/utlities/show_error_dialogue.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  void handleRegistration() async {
    final email = _email.text;
    final password = _password.text;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      Navigator.pushNamed(context, VERIFY_EMAIL_ROUTE);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          await showErrorDialogue(context, "Inavlid Email Address");
          break;
        case "weak-password":
          await showErrorDialogue(context, "Weak Password");
          break;
        case "email-already-in-use":
          await showErrorDialogue(context, "Email Already In Use");
          break;
        default:
          await showErrorDialogue(context, "Error: ${e.code}");
          break;
      }
    } catch (e) {
      await showErrorDialogue(context, "Error: $e");
    }
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter Email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter Password"),
          ),
          TextButton(
            onPressed: handleRegistration,
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
            child: const Text("Already Registered? Login Here"),
          ),
        ],
      ),
    );
  }
}
