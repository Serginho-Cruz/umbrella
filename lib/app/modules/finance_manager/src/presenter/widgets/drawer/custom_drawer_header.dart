import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../texts/small_text.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
    required this.username,
    required this.userEmail,
  });

  final String username;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        color: UmbrellaPalette.secondaryColor,
        border: Border(bottom: BorderSide()),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(),
              color: Colors.white,
            ),
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: BigText(username.substring(0, 1)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            child: MediumText.bold(username),
          ),
          SmallText.light(userEmail),
        ],
      ),
    );
  }
}
