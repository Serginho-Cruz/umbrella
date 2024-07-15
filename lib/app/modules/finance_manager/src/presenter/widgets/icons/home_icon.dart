import 'package:flutter/material.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/finance_manager/', (_) => false);
      },
      icon: const Icon(Icons.home, color: Colors.black, size: 35.0),
    );
  }
}
