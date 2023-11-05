import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color baseColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[800]!;
    Color highlightColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey[100]!
        : Colors.grey[700]!;

    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonInfoRow(),
                    SizedBox(height: 20),
                    _buildSkeletonInfoRow(),
                    SizedBox(height: 20),
                    _buildSkeletonInfoRow(),
                    SizedBox(height: 20),
                    _buildSkeletonInfoRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonInfoRow() {
    return Container(
      height: 20,
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
    );
  }
}
