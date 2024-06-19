import 'package:flutter/material.dart';

import 'shimmer_container.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerContainer(
      height: 275,
      width: 150,
      borderRadius: 15.0,
    );
  }
}
