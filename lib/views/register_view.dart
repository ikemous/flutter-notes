import 'package:flutter/material.dart';
import 'package:mynotes/common/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utlities/show_error_dialogue.dart';

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
      await AuthService.firebase().createUser(
        email: email,
        password: password,
      );
      AuthService.firebase().sendEmailVerification();
      Navigator.pushNamed(context, VERIFY_EMAIL_ROUTE);
    } on InvalidEmailAuthException {
      await showErrorDialogue(context, "Inavlid Email Address");
    } on WeakPasswordAuthException {
      await showErrorDialogue(context, "Weak Password");
    } on EmailInUseAuthException {
      await showErrorDialogue(context, "Email Already In Use");
    } on GenericAuthException {
      await showErrorDialogue(context, "Registration Failure");
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
