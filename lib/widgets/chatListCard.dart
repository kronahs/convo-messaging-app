import 'package:chat_app/screens/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListCard extends StatelessWidget {
  final String chatUserName;
  final String chatUserImg;
  final String latestChat;
  final String latestChatTime;
  final VoidCallback onTap;

  const ChatListCard({
    super.key,
    required this.chatUserName,
    required this.chatUserImg,
    required this.latestChat,
    required this.latestChatTime,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    String limitedLatestChat = latestChat.length > 30 ? latestChat.substring(0, 30) + '...' : latestChat;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          foregroundImage: NetworkImage(this.chatUserImg),
        ),
        title: Text(this.chatUserName, style: Theme.of(context).textTheme.titleMedium,),
        subtitle: Text(limitedLatestChat),
        trailing: Text(this.latestChatTime),

      ),
    );
  }
}
