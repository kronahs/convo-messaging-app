

import 'package:chat_app/screens/ProfilePage.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/services/user/user_service.dart';
import 'package:chat_app/widgets/chatListCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../services/user/userSearchDelegate.dart';
import '../widgets/loadingSkeletons/chatListSkeleton.dart';
import 'chatPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final UserServiceProvider userServiceProvider = UserServiceProvider();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/applogo.png', width: 40, height: 40),
        centerTitle: true,
        leading: InkWell(
          onTap: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation(selectedTabIndex: 2)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
            child: CircleAvatar(
              foregroundImage: NetworkImage('https://sb.kaleidousercontent.com/67418/1920x1545/c5f15ac173/samuel-raita-ridxdghg7pw-unsplash.jpg'),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                String? selectedUser = await showSearch(
                  context: context,
                  delegate: UserSearchDelete(userServiceProvider: UserServiceProvider(),appBarColor: Theme.of(context).colorScheme.primary),
                );
                if (selectedUser != null) {
                  // Handle the selected user
                  print('Selected user: $selectedUser');
                }
              },
              icon: Icon(Icons.search)
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Text('Error');
            }

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
                children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList()
            );
          }
      )
    );
  }




  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    ChatService _chatService = ChatService();

    if (_firebaseAuth.currentUser!.email != data['email']) {
      return StreamBuilder(
        stream: _chatService.getLatestChatStream(_firebaseAuth.currentUser!.uid, data['uid']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return UserListItemSkeleton();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Check if there are any messages in the latest chat
          Map<String, dynamic> latestChatData = snapshot.data ?? {'message': 'No messages yet', 'timestamp': ''};
          String latestChat = latestChatData['message'];

          // If there are no messages, skip this user
          if (latestChat.isEmpty) {
            return Container();
          }

          String latestChatTime = latestChatData['timestamp'];

          return ChatListCard(
            chatUserName: data['fullname'],
            chatUserImg: data['profilePic'],
            latestChat: latestChat,
            latestChatTime: latestChatTime,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    chatUserName: data['fullname'],
                    chatUserImg: data['profilePic'],
                    isOnline: data['is_online'] ?? '',
                    receiverId: data['uid'],
                    lastActive: data['last_active'] ?? '',
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Container();
    }
  }

}