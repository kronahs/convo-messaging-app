import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final String profilePicUrl;
  final String bio;
  final String username;

  UserDetailPage({required this.profilePicUrl, required this.bio, required this.username});

  @override
  Widget build(BuildContext context) {
    var heroTag = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Hero(
                    tag: heroTag ?? '',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        profilePicUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            username,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Bio: $bio',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
