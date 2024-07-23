import 'package:flutter/material.dart';

class TappableOption {
  final String name;
  final VoidCallback onPressed;

  const TappableOption(this.name, this.onPressed);
}
