import 'package:flutter/material.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';
import '../layout/spaced.dart';

import '../../../domain/entities/date.dart';
import '../texts/title_text.dart';
import 'month_changer.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    this.title,
    this.onMonthChange,
    this.monthAndYear,
    this.showBalances = true,
    this.showMonthChanger = false,
  }) {
    assert((showMonthChanger && onMonthChange != null) || !showMonthChanger,
        'onMonthChange must be provided if showMonthChanger is true');
  }

  final Date? monthAndYear;
  final String? title;
  final void Function(int, int)? onMonthChange;
  final bool showBalances;
  final bool showMonthChanger;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    double height = 99.0; //Minimal

    if (showBalances) height += 79.0;

    if (showMonthChanger) height += 48.0;

    return Size.fromHeight(height - 20.0); //Margin
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: UmbrellaPalette.appBarGradientColors,
        ),
        border: Border.all(width: 1.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
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
                icon: const Icon(Icons.home, color: Colors.black, size: 35.0),
              ),
              if (widget.title != null) TitleText.bold(widget.title!),
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
              onMonthChange: widget.onMonthChange!,
              monthAndYear: widget.monthAndYear,
            ),
          if (widget.showBalances)
            Padding(
              padding: EdgeInsets.only(
                top: 15.0,
                left: MediaQuery.sizeOf(context).width * 0.05,
                right: MediaQuery.sizeOf(context).width * 0.05,
              ),
              child: const Spaced(
                first: BigText.bold('Saldo Atual'),
                second: Price.big(200.85, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.showBalances)
            Padding(
              padding: EdgeInsets.only(
                top: 12.0,
                left: MediaQuery.sizeOf(context).width * 0.05,
                right: MediaQuery.sizeOf(context).width * 0.05,
              ),
              child: const Spaced(
                first: MediumText('Saldo Esperado'),
                second: Price(
                  200.85,
                  fontSize: UmbrellaSizes.medium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
