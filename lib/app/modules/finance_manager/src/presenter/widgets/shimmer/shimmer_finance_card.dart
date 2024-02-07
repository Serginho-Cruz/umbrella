import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFinanceCard extends StatelessWidget {
  const ShimmerFinanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade200,
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
