import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/utils/utility_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UtilityFunctions _utilityFunctions = UtilityFunctions();

  //Send Message
  Future<void> sendMessage(String receiverId, String message) async{
    final String currentUserId = await _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = await _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp
    );


    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore.collection("chat_rooms").doc(chatRoomId).collection("messages").add(newMessage.toMap());
  }


  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    
    return _firestore.collection("chat_rooms").doc(chatRoomId)
        .collection("messages").orderBy("timestamp", descending: false).snapshots();
  }

  Stream<Map<String, dynamic>> getLatestChatStream(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var latestMessage = querySnapshot.docs.first;
        String message = latestMessage['message'];
        Timestamp timestamp = latestMessage['timestamp'];
        String formattedTimestamp = _utilityFunctions.timestampToHourMinute(timestamp); // You can use your existing timestampToHourMinute function to format the timestamp
        return {'message': message, 'timestamp': formattedTimestamp}; // Return a map with message content and formatted timestamp
      } else {
        return {'message': '', 'timestamp': ''}; // Return default values if no messages found
      }
    });
  }





}