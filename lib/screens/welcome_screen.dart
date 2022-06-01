import 'package:flutter/material.dart';
import 'package:messenger/components/rounded_button.dart';
import 'package:messenger/screens/login_screen.dart';
import 'package:messenger/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller!);
    controller!.forward();
    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                    child: AnimatedTextKit(
                      animatedTexts: [TyperAnimatedText('Flash Chat')],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48,
            ),
            RoundedButton(
                colour: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                title: 'Log In'),
            RoundedButton(
                colour: Colors.blueAccent,
                title: "Register",
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                })
          ],
        ),
      ),
    );
  }
}
