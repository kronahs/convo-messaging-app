import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user/user_service.dart';

class AuthServiceProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      await UserServiceProvider().updateActiveStatus(true);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    await UserServiceProvider().updateActiveStatus(false);
    return await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signUpWithEmailAndPassword(String fullname, String email, String username, String password, String confirmPassword, String proPicImg) async {
    try {
      // Check if the username already exists in the users collection
      QuerySnapshot query = await _firestore.collection('users').where('username', isEqualTo: username).get();
      if (query.docs.isNotEmpty) {
        // Username already exists, throw an error or handle it accordingly
        throw Exception("Username already exists. Please choose a different one.");
      }

      // If the username is unique, proceed with user registration
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      // Store user information in the users collection
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': username,
        'email': email,
        'fullname': fullname,
        'profilePic': proPicImg,
        'is_online': 'Online',
        'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

}
