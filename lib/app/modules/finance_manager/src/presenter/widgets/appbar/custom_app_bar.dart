import 'package:flutter/material.dart';
import '../../../domain/entities/account.dart';
import '../../controllers/account_store.dart';
import '../../controllers/balance_store.dart';
import '../../utils/umbrella_palette.dart';
import '../../../domain/entities/date.dart';
import '../icons/drawer_icon.dart';
import '../icons/home_icon.dart';
import '../texts/title_text.dart';
import 'balances_section.dart';
import 'month_changer.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.onMonthChange,
    this.monthAndYear,
    this.showBalances = true,
    this.showMonthChanger = false,
    this.balanceStore,
    this.accountStore,
  })  : assert(
          (showMonthChanger && onMonthChange != null) || !showMonthChanger,
          'onMonthChange must be provided if showMonthChanger is true',
        ),
        assert(
          (showBalances && balanceStore != null && accountStore != null) ||
              !showBalances,
          'balance and account store must be provided if the balances will be shown',
        );

  final Date? monthAndYear;
  final String? title;

  ///A function to be run when user changes the month usign the [MonthChanger] widget.
  ///There's no need to wrap the function in a Future, because the function will be called inside one.
  final void Function(int, int)? onMonthChange;
  final bool showBalances;
  final bool showMonthChanger;

  final BalanceStore? balanceStore;
  final AccountStore? accountStore;

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
  late Date balanceVisualisationDate;

  @override
  void initState() {
    super.initState();
    widget.accountStore?.addSelectedAccountListener(_onSelectedAccountChanged);
    balanceVisualisationDate = MonthChanger.currentMonthAndYear;
  }

  @override
  void dispose() {
    widget.accountStore
        ?.removeSelectedAccountListener(_onSelectedAccountChanged);
    super.dispose();
  }

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
              const HomeIcon(),
              if (widget.title != null) TitleText.bold(widget.title!),
              const DrawerIcon(),
            ],
          ),
          if (widget.showMonthChanger)
            MonthChanger(
              onMonthChange: _onMonthChange,
              monthAndYear: widget.monthAndYear,
            ),
          if (widget.showBalances)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: BalancesSection(
                accountStore: widget.accountStore!,
                balanceStore: widget.balanceStore!,
                visualisationDate: balanceVisualisationDate,
              ),
            ),
        ],
      ),
    );
  }

  void _onSelectedAccountChanged(Account? selected) {
    _fetchBalance();
  }

  void _onMonthChange(int month, int year) {
    Future(() {
      widget.onMonthChange!.call(month, year);
      _fetchBalance();

      setState(() {
        balanceVisualisationDate = Date(day: 1, month: month, year: year);
      });
    });
  }

  void _fetchBalance() {
    if (widget.accountStore == null) return;

    var date = MonthChanger.currentMonthAndYear;

    int month = date.month, year = date.year;

    var selected = widget.accountStore?.selectedAccount;

    if (selected != null) {
      widget.balanceStore?.get(
        month: month,
        year: year,
        account: selected,
      );

      return;
    }

    widget.balanceStore?.getForAll(
      month: month,
      year: year,
      accounts: widget.accountStore!.state,
    );
  }
}
