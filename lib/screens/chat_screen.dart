import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/screens/welcome_screen.dart';
import 'package:time_formatter/time_formatter.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        // ignore: avoid_print
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
            icon: const Icon(Icons.close),
          ),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser?.email,
                          'time': FieldValue.serverTimestamp(),
                        }).then((value) => print('${value.id}added'));
                      },
                      child: const Icon(Icons.send_rounded))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 101, 167, 197),
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = (message.data() as Map<String, dynamic>)['text'];
          final messageSender =
              (message.data() as Map<String, dynamic>)['sender'];
          final messageTime =
              (message.data() as Map<String, dynamic>)['time'] as Timestamp;

          final currentUser = loggedInUser?.email;

          final messageBubble = MessageBubble(
            sender: messageSender ?? '',
            text: messageText ?? '',
            isMe: currentUser == messageSender,
            time: messageTime,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  const MessageBubble(
      {Key? key,
      required this.sender,
      required this.text,
      required this.isMe,
      required this.time})
      : super(key: key);

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  // Widget handleerr() {
  //   return Text(formatTime(widget.time.millisecondsSinceEpoch),
  //       style: const TextStyle(
  //         fontSize: 11.0,
  //         color: Colors.black54,
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            ' ${widget.sender}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            borderRadius: widget.isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30)),
            elevation: 5,
            color: widget.isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 15,
                  color: widget.isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
          Text(formatTime(widget.time.millisecondsSinceEpoch),
              style: const TextStyle(
                fontSize: 11.0,
                color: Colors.black54,
              )),
          // handleerr(),
        ],
      ),
    );
  }
}
