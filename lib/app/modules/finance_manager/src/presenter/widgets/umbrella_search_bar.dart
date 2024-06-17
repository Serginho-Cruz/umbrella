import 'package:flutter/material.dart';

import '../../utils/umbrella_palette.dart';

class UmbrellaSearchBar extends StatelessWidget {
  const UmbrellaSearchBar({
    super.key,
    required this.searchFunction,
    this.width,
    this.height,
  });

  final void Function(String) searchFunction;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      constraints: BoxConstraints(
        maxWidth: width ?? MediaQuery.sizeOf(context).width * 0.9,
        minHeight: height ?? 60.0,
      ),
      backgroundColor: const WidgetStatePropertyAll(UmbrellaPalette.gray),
      onSubmitted: searchFunction,
      hintText: 'Pesquisar por Nome',
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      textInputAction: TextInputAction.search,
      trailing: const [Icon(Icons.search_rounded)],
    );
  }
}
