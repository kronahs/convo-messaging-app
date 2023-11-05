import 'package:cloud_firestore/cloud_firestore.dart';

class UtilityFunctions{


  String timestampToHourMinute(Timestamp timestamp) {
    if (timestamp == null) {
      return '';
    }
    DateTime dateTime = timestamp.toDate();
    String hour = (dateTime.hour % 12).toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute$period';
  }

  String formatLastActive(lastActive) {
    if (lastActive.isNotEmpty) {
      // You can format the lastActive string here if it's not empty
      // For example, you can convert the timestamp to a human-readable format
      // Using the UtilityFunctions.timestampToHourMinute method
      return UtilityFunctions().timestampToHourMinute(Timestamp.fromMillisecondsSinceEpoch(int.parse(lastActive)));
    }
    return 'long time'; // Return 'N/A' if lastActive is empty
  }
}