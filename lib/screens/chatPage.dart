import 'dart:async';

import 'package:chat_app/screens/userDetailPage.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/utils/utility_functions.dart';
import 'package:chat_app/widgets/messageCard.dart';
import 'package:chat_app/widgets/loadingSkeletons/messageListSkeleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String chatUserName;
  final String chatUserImg;
  final String isOnline;
  final String lastActive;
  final String receiverId;

  const ChatPage({Key? key, required this.chatUserName, required this.chatUserImg, required this.isOnline, required this.receiverId, required this.lastActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UtilityFunctions _util = UtilityFunctions();

    return Scaffold(
        appBar: AppBar(
            title: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => UserDetailPage(
                  profilePicUrl: chatUserImg,
                  bio: 'Hello There', // Pass the actual bio here
                  username: chatUserName,
                ),        settings: RouteSettings(
                      arguments: chatUserImg, // Pass the hero tag as an argument
                    ),
                ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(chatUserImg),
                  ),
                  SizedBox(width: 16,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chatUserName, style: Theme.of(context).textTheme.titleMedium),
                      Text( isOnline == 'true' ? 'Online' : 'Last Seen ${_util.formatLastActive(lastActive)}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            )
        ),
        body: ChatList(receiverId: receiverId,)
    );
  }
}



class ChatList extends StatefulWidget {
  final String receiverId;

  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollControllerStream = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _scrollControllerStream.stream.listen((scrollToEnd) {
      if (scrollToEnd) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverId, _messageController.text);
      _messageController.clear();
      _scrollControllerStream.add(true); // Scroll to the end after adding a new message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatService.getMessages(widget.receiverId, _firebaseAuth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return MessageListSkeleton();
                }

                return ListView(
                  controller: _scrollController,
                  children: snapshot.data!.docs.map<Widget>((doc) => _buildMessageItem(doc)).toList(),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.background,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: TextField(
                      maxLines: 2,
                      minLines: 1,
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final UtilityFunctions _utilityFunctions = UtilityFunctions();

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid ? 'Sender' : data['senderEmail']);

    return Column(
      children: [
        MessageCard(chatUserName: alignment, message: data['message'], date: _utilityFunctions.timestampToHourMinute(data['timestamp'])),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _scrollControllerStream.close();
    super.dispose();
  }
}
