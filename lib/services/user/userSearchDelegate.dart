import 'package:chat_app/services/user/user_service.dart';
import 'package:flutter/material.dart';
import '../../screens/chatPage.dart';
import '../../widgets/chatListCard.dart';

class UserSearchDelete extends SearchDelegate<String> {
  final UserServiceProvider userServiceProvider;
  final Color appBarColor; // Color for the app bar

  UserSearchDelete({required this.userServiceProvider, required this.appBarColor});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor, // Use the provided app bar color from the constructor
      ),
      brightness: brightness, // Set brightness based on the current theme
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: brightness == Brightness.dark ? Colors.white : Colors.black), // Set hint text color based on brightness
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    String currentQuery = query;
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, currentQuery);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: userServiceProvider.searchUsers(query.toLowerCase()), // Convert query to lowercase
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        } else {
          List<Map<String, dynamic>> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> user = users[index];
              return ChatListCard(
                chatUserName: user['fullname'],
                chatUserImg: user['profilePic'],
                latestChat: user['latestChat'], // Replace 'latestChat' with the correct key from your user data
                latestChatTime: user['latestChatTime'], // Replace 'latestChatTime' with the correct key from your user data
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        chatUserName: user['fullname'],
                        chatUserImg: user['profilePic'],
                        isOnline: user['is_online'] ?? '',
                        receiverId: user['uid'],
                        lastActive: user['last_active'] ?? '',
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: userServiceProvider.searchUsers(query.toLowerCase()), // Convert query to lowercase
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        } else {
          List<Map<String, dynamic>> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> user = users[index];
              return ListTile(
                title: Text(user['fullname'].toString()), // Convert to uppercase for display
                subtitle: Text("@${user['username']}"),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['profilePic']),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        chatUserName: user['fullname'],
                        chatUserImg: user['profilePic'],
                        isOnline: user['is_online'] ?? '',
                        receiverId: user['uid'],
                        lastActive: user['last_active'] ?? '',
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
