import 'package:flutter/material.dart';
import 'package:messenger/components/rounded_button.dart';
import 'package:messenger/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: ktextFieldDecoration.copyWith(
                        hintText: 'Enter your email')),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: ktextFieldDecoration.copyWith(
                        hintText: 'Enter your password')),
                const SizedBox(
                  height: 24,
                ),
                RoundedButton(
                    colour: Colors.blueAccent,
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        // ignore: unused_local_variable
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email!, password: password!);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        // ignore: avoid_print
                        print(e);
                      }
                    },
                    title: 'Register'),
              ],
            ),
          ),
        ));
  }
}
