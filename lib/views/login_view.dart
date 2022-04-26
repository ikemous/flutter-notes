import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/common/routes.dart';
import 'package:mynotes/utlities/show_error_dialogue.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  void handleLogin() async {
    final email = _email.text;
    final password = _password.text;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushNamedAndRemoveUntil(context, NOTES_ROUTE, (route) => false);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
        case "wrong-password":
        case "invalid-email":
          await showErrorDialogue(context, "Username/Password Invalid");
          break;
        default:
          await showErrorDialogue(context, "Unexpected Authentication Error");
          break;
      }
    } catch (e) {
      await showErrorDialogue(context, "Unknown Error");
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
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            obscureText: true,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          TextButton(
            onPressed: handleLogin,
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/register",
                (route) => false,
              );
            },
            child: const Text("Not Registered Yet? Register Here"),
          ),
        ],
      ),
    );
  }
}
