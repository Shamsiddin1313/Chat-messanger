// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger/screens/chat_screen.dart';
import 'package:messenger/screens/login_screen.dart';
import 'package:messenger/screens/registration_screen.dart';
import 'package:messenger/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlashChat());
}

class FlashChat extends StatefulWidget {
  const FlashChat({key}) : super(key: key);

  @override
  State<FlashChat> createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen()
      },
      home: const Scaffold(),
    );
  }
}
