import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // const Color(0xff190c3aff),
      body: SafeArea(
        child: Stack(
          children:[
            // Image.asset('assets/img_1.png'),
            Column(
            children: [
               Container(
                  color: Colors.white,
                  height: 50,
                  width: double.infinity,
                  child: ListTile(
                    title: const Text('Flutter Chat', style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w500),),
                    trailing: DropdownButton(
                      underline: Container( ),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'logout',
                          child: Row(
                            children: const [
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Logout'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (iteIdentifier) {
                        if (iteIdentifier == 'logout') {
                          FirebaseAuth.instance.signOut();
                        }
                      },
                    ),
                  ),
                ),
              Expanded(child: Messages()),
              NewMessage(),
            ],
          ),],
        ),
      ),
    );
  }
}
