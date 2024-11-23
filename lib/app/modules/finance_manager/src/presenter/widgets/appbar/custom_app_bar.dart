import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';
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

// ignore: must_be_immutable
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    this.title,
    this.onMonthChange,
    this.monthAndYear,
    this.showBalances = true,
    this.showMonthChanger = false,
  }) {
    _assignStores();
  }
  final Date? monthAndYear;
  final String? title;

  ///A function to be run when user changes the month usign the [MonthChanger] widget.
  ///There's no need to wrap the function in a Future, because the function will be called inside one.
  final void Function(int, int)? onMonthChange;
  final bool showBalances;
  final bool showMonthChanger;

  late BalanceStore _balanceStore;
  late AccountStore _accountStore;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    double height = 99.0; //Minimal

    if (showBalances) height += 60.0;

    if (showMonthChanger) height += 48.0;

    return Size.fromHeight(height - 20.0); //Margin
  }

  void _assignStores() {
    _balanceStore = BindServiceProvider.get();
    _accountStore = BindServiceProvider.get();
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
    widget._accountStore.addSelectedAccountListener(_onSelectedAccountChanged);
  }

  @override
  void dispose() {
    widget._accountStore
        .removeSelectedAccountListener(_onSelectedAccountChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
      decoration: BoxDecoration(
        color: UmbrellaPalette.primaryColor,
        border: Border.all(width: 1.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
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
              padding: const EdgeInsets.only(top: 12.0),
              child: BalancesSection(
                accountStore: widget._accountStore,
                balanceStore: widget._balanceStore,
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
    });
  }

  void _fetchBalance() {
    var selected = widget._accountStore.selectedAccount;

    if (selected != null) {
      widget._balanceStore.get(
        account: selected,
      );

      return;
    }

    widget._balanceStore.getForAll(
      accounts: widget._accountStore.state,
    );
  }
}
