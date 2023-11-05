import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService{
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();

    print('Token: $token');
  }
}