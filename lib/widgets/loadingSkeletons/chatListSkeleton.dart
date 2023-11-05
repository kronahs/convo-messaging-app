import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserListItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color baseColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[800]!;
    Color highlightColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey[100]!
        : Colors.grey[700]!;

    return ListTile(
      leading: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
        ),
      ),
      title: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: double.infinity,
          height: 16,
          color: Colors.white,
        ),
      ),
      subtitle: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: double.infinity,
          height: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
