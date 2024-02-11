import 'package:flutter/material.dart';

import '../../../domain/entities/date.dart';

class MonthChanger extends StatefulWidget {
  const MonthChanger({
    super.key,
    required this.onMonthChange,
    required this.initialMonthAndYear,
  });

  final void Function(int, int) onMonthChange;
  final Date initialMonthAndYear;

  @override
  State<MonthChanger> createState() => _MonthChangerState();
}

class _MonthChangerState extends State<MonthChanger>
    with TickerProviderStateMixin {
  late final AnimationController slideController;
  late final Animation<Offset> slideAnimation;

  late final AnimationController fadeController;

  Date date = Date.today().copyWith(day: 1);

  @override
  void initState() {
    super.initState();
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      value: 0.5,
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(1, 0))
            .animate(slideController);

    fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500), value: 1.0);
  }

  Future<void> toNextMonth() async {
    await Future.wait([
      slideController.forward(),
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
            if (!slideController.isAnimating) toPreviousMonth();
          },
        ),
        FadeTransition(
          opacity: fadeController,
          child: SlideTransition(
            position: slideAnimation,
            child: Text(
              '${date.monthName} ${date.year}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
            if (!slideController.isAnimating) toNextMonth();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    super.dispose();
  }
}
