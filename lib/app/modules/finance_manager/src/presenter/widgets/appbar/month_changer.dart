import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';
import '../texts/big_text.dart';

class MonthChanger extends StatefulWidget {
  MonthChanger({super.key, required this.onMonthChange, Date? monthAndYear}) {
    if (monthAndYear != null) {
      MonthChanger.currentMonthAndYear = monthAndYear;
    }
  }

  static Date currentMonthAndYear = Date.today();

  final void Function(int, int) onMonthChange;

  @override
  State<MonthChanger> createState() => _MonthChangerState();
}

class _MonthChangerState extends State<MonthChanger>
    with TickerProviderStateMixin {
  late final AnimationController slideController;
  late final Animation<Offset> slideAnimation;

  late final AnimationController fadeController;

  Date date = MonthChanger.currentMonthAndYear;

  Timer timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 0.5,
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(1, 0))
            .animate(slideController);

    fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250), value: 1.0);
  }

  Future<void> toNextMonth() async {
    await Future.wait([
      slideController.forward(from: 0.5),
      fadeController.reverse(),
    ]);

    setState(() {
      date = date.copyWith(month: date.month + 1);
    });

    slideController
      ..reset()
      ..animateTo(0.5);

    fadeController
      ..reset()
      ..forward();
  }

  Future<void> toPreviousMonth() async {
    await Future.wait([
      slideController.reverse(),
      fadeController.reverse(),
    ]);

    setState(() {
      date = date.copyWith(month: date.month - 1);
    });

    slideController
      ..value = 1.0
      ..animateTo(0.5);

    fadeController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
            if (!slideController.isAnimating) {
              toPreviousMonth();
              timer.cancel();
              timer = Timer(const Duration(milliseconds: 2000), () {
                widget.onMonthChange(date.month, date.year);
              });
            }
          },
        ),
        FadeTransition(
          opacity: fadeController,
          child: SlideTransition(
            position: slideAnimation,
            child: BigText.bold('${date.monthName} ${date.year}'),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
            if (!slideController.isAnimating) {
              toNextMonth();
              timer.cancel();
              timer = Timer(const Duration(seconds: 2), () {
                widget.onMonthChange(date.month, date.year);
              });
            }
          },
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onMonthChange(date.month, date.year);
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    super.dispose();
  }
}
