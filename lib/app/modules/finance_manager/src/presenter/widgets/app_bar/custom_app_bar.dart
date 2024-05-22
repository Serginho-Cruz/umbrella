import 'package:flutter/material.dart';
import '../../../utils/umbrella_palette.dart';
import '../../../utils/umbrella_sizes.dart';
import '../common/price.dart';
import '../common/spaced_widgets.dart';

import '../../../domain/entities/date.dart';
import 'month_changer.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    this.title,
    required this.onMonthChange,
    required this.initialMonthAndYear,
    this.showBalances = true,
    this.showMonthChanger = true,
  });

  final String? title;
  final Date initialMonthAndYear;
  final void Function(int, int) onMonthChange;
  final bool showBalances;
  final bool showMonthChanger;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            UmbrellaPalette.secondaryColor,
            UmbrellaPalette.primaryColor,
          ],
        ),
        border: Border.all(width: 1.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/finance_manager/', (_) => false);
                },
                icon: const Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 35.0,
                ),
              ),
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              IconButton(
                onPressed: () {
                  Scaffold.maybeOf(context)?.openDrawer();
                },
                icon: const Icon(
                  Icons.menu_rounded,
                  color: Colors.black,
                  size: 35.0,
                ),
              ),
            ],
          ),
          if (widget.showMonthChanger)
            MonthChanger(
              onMonthChange: widget.onMonthChange,
              initialMonthAndYear: widget.initialMonthAndYear,
            ),
          if (widget.showBalances)
            Padding(
              padding: EdgeInsets.only(
                top: 15.0,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              child: const SpacedWidgets(
                first: Text(
                  'Saldo Atual',
                  style: TextStyle(
                    fontSize: UmbrellaSizes.big,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                second: Price(
                  value: 200.85,
                  style: TextStyle(
                    fontSize: UmbrellaSizes.big,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (widget.showBalances)
            Padding(
              padding: EdgeInsets.only(
                top: 12.0,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              child: const SpacedWidgets(
                first: Text(
                  'Saldo Esperado',
                  style: TextStyle(
                    fontSize: UmbrellaSizes.medium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                second: Price(
                  value: 200.85,
                  style: TextStyle(
                    fontSize: UmbrellaSizes.medium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
