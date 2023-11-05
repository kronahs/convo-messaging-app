import 'package:chat_app/services/user/profilePictureService.dart';
import 'package:chat_app/utils/utility_functions.dart';
import 'package:chat_app/widgets/loadingSkeletons/profilePageSkeleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ProfilePictureService _profilePictureService = ProfilePictureService();


  @override
  Widget build(BuildContext context) {
    final String userId = _firebaseAuth.currentUser!.uid;

    Widget _buildInfoRow(String label, String value, VoidCallback? onPress) {

      return InkWell(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label ',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 10),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildInfoRowTextField(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: value,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }


    UtilityFunctions _util = UtilityFunctions();
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProfilePageSkeleton();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('User not found'));
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var username = userData['username'] ?? '';
          var fullName = userData['fullname'] ?? '';
          var bio = userData['bio'] ?? 'Hello there!';

          ImagePicker _imagePicker = ImagePicker();

          Future<void> _handleImageDoubleClick(BuildContext context) async {
            try {
              // Show image selection from the phone
              final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);

              if (pickedFile != null) {
                // Set loading state while uploading image
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploading profile picture...')));

                String? imageUrl = await _profilePictureService.uploadProfilePicture(userId);

                if (imageUrl != null) {
                  // Update the user's profile picture URL in Firestore with imageUrl
                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'profilePic': imageUrl,
                  });
                  // Update the UI to display the new profile picture
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile picture updated!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile picture.')));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected.')));
              }
            } catch (e) {
              print('Error updating profile picture: $e');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile picture.')));
            }
          }


          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      InkWell(
                        onDoubleTap: (){
                          _handleImageDoubleClick(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            userData['profilePic'] ?? '',
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
                                fullName,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit button click here
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onInverseSurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRowTextField('Username', '@$username'),
                              _buildInfoRowTextField('Bio', bio),
                              // Add more UI elements as needed
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),

                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Settings', style: Theme.of(context).textTheme.titleMedium),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onInverseSurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Theme', 'Dark Mode', null),
                              _buildInfoRow('Account', 'Change account settings', null),
                              _buildInfoRow('Account', 'Logout', () {
                                // Implement sign out logic here
                              }),
                              // Add more UI elements for settings as needed
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
