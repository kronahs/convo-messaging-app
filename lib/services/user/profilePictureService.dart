import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> uploadProfilePicture(String userId) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        Reference storageReference = _storage.ref().child('profilePictures/$userId');
        UploadTask uploadTask = storageReference.putFile(file);

        await uploadTask.whenComplete(() => null);

        String downloadURL = await storageReference.getDownloadURL();
        return downloadURL;
      } else {
        return null;
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  Future<String?> getProfilePictureUrl(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['profilePic'];
      }
      return null;
    } catch (e) {
      print('Error fetching profile picture: $e');
      return null;
    }
  }
}
