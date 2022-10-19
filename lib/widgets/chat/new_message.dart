import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enterMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enterMessage,
      'createdAt': Timestamp.now(),
      'userId': user!.uid,
      'userName': userData['userName'],
      'userImage' : userData['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // Color(0xff15345BFF),
      height: 60,
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.black),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true ,
              decoration: const InputDecoration(
                hintText: 'Send a message...',
                hintStyle: TextStyle( color: Colors.black),

              ),
              onChanged: (value) {
                setState(() {
                  _enterMessage = value;
                });
              },
              controller: _controller,
            ),
          ),
          IconButton(
            onPressed: _enterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
