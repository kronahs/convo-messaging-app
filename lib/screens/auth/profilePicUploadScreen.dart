import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/user/profilePictureService.dart';

class ProfilePicUploadPage extends StatefulWidget {
  const ProfilePicUploadPage({Key? key});

  @override
  State<ProfilePicUploadPage> createState() => _ProfilePicUploadPageState();
}

class _ProfilePicUploadPageState extends State<ProfilePicUploadPage> {
  late String _profilePicUrl;
  final ProfilePictureService _profilePictureService = ProfilePictureService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadProfilePicUrl();
  }

  Future<void> _loadProfilePicUrl() async {
    String? picUrl = await _profilePictureService.getProfilePictureUrl(_firebaseAuth.currentUser!.uid);
    setState(() {
      _profilePicUrl = picUrl ?? '';
    });
  }

  Future<void> _uploadImage() async {
    String? downloadURL = await _profilePictureService.uploadProfilePicture(_firebaseAuth.currentUser!.uid);

    if (downloadURL != null) {
      setState(() {
        _profilePicUrl = downloadURL;
      });
      // TODO: Save the `_profilePicUrl` to your user document in Firestore or wherever you store user data.
    } else {
      // Handle the case when the upload fails
      // Show an error message or retry the upload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Profile Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _uploadImage,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: _profilePicUrl.isNotEmpty
                    ? Image.network(
                  _profilePicUrl,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.add_a_photo,
                  size: 50,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
