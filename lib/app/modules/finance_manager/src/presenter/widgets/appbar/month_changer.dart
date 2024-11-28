import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';

import '../../../domain/entities/date.dart';
import '../../stores/month_store.dart';
import '../texts/medium_text.dart';

class MonthChanger extends StatefulWidget {
  final MonthStore _monthStore = BindServiceProvider.get<MonthStore>();

  MonthChanger({super.key, required this.onMonthChange, Date? monthAndYear}) {
    if (monthAndYear != null) {
      _monthStore.set(monthAndYear);
    }
  }

  final void Function(int, int) onMonthChange;

  @override
  State<MonthChanger> createState() => _MonthChangerState();
}

class _MonthChangerState extends State<MonthChanger>
    with TickerProviderStateMixin {
  late final AnimationController slideController;
  late final Animation<Offset> slideAnimation;

  late final AnimationController fadeController;

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

    widget._monthStore.moveToNext();

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

    widget._monthStore.moveToPrevious();

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 20.0,
          ),
          onPressed: () {
            if (!slideController.isAnimating) {
              toPreviousMonth();
              timer.cancel();
              timer = Timer(const Duration(milliseconds: 2000), () {
                var (:month, :year) = widget._monthStore.month;
                widget.onMonthChange(month, year);
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Observer(builder: (_) {
            var (:month, :year) = widget._monthStore.month;

            String name = Date(day: 1, month: month, year: year).monthName;
            return FadeTransition(
              opacity: fadeController,
              child: SlideTransition(
                position: slideAnimation,
                child: MediumText.bold('$name $year'),
              ),
            );
          }),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 20.0,
          ),
          onPressed: () {
            if (!slideController.isAnimating) {
              toNextMonth();
              timer.cancel();
              timer = Timer(const Duration(seconds: 2), () {
                var (:month, :year) = widget._monthStore.month;
                widget.onMonthChange(month, year);
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
    var (:month, :year) = widget._monthStore.month;
    widget.onMonthChange(month, year);
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    super.dispose();
  }
}
