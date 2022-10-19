
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;
  final Key? key;

  const MessageBubble(this.message, this.userName, this.userImage, this.isMe,
      {this.key});

  void sentData(){

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            const SizedBox(width: 40,),
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Color(0xffE5E5E5)
                    : Color(0xffE5E5E5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Color(0xff8E1DE8)
                            : Color(0xff000000)),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),

                ],
              ),
            ),
            const SizedBox(width: 40,),
          ],
        ),
        Positioned(
          bottom: 0,
          top: 22,
          left: isMe ? null : 10,
          right: isMe ? 10 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
