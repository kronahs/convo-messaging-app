import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/utility_functions.dart';

class UserServiceProvider extends ChangeNotifier{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String uid; // Declare uid as a nullable late variable

  Future<void> initialize() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      uid = user.uid;
    }
  }

  Future<void> updateActiveStatus(bool isOnline) async {
    await initialize(); // Call initialize method to set uid
    _firestore.collection('users').doc(uid).update({
      'is_online': isOnline.toString(),
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    notifyListeners();
  }

  Stream<Map<String, String>> getOnlineStatusAndLastSeenStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((
        snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      final isOnline = data['is_online'] == 'true';
      final lastSeenTimestamp = data['last_active'] as String;
      final lastSeen = UtilityFunctions().formatLastActive(
          int.parse(lastSeenTimestamp));

      return {'isOnline': isOnline.toString(), 'lastSeen': lastSeen};
    });
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    QuerySnapshot querySnapshot;
    if (query.isEmpty) {
      // If the query is empty, return all users
      querySnapshot = await _firestore.collection('users').get();
    } else {
      // If the query is not empty, search users by username
      querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .get();
    }

    List<Map<String, dynamic>> users = [];
    querySnapshot.docs.forEach((doc) {
      users.add(doc.data() as Map<String, dynamic>);
    });
    print(users);
    return users;
  }


  Future<Map<String, dynamic>> getUserData() async {
    Map<String, dynamic> userData = {};

    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
        userData['uid'] = user.uid;
        userData['email'] = user.email;
        userData['fullname'] = user.displayName ?? '';
        userData['profilePic'] = user.photoURL ?? '';
      }
    }

    return userData;
  }


}
