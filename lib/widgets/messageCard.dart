import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String chatUserName;
  final String message;
  final String date;

  const MessageCard({
    Key? key,
    required this.chatUserName,
    required this.message,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Align(
        alignment: chatUserName == 'Sender' ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: chatUserName == 'Sender' ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.tertiary,
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
