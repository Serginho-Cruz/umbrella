import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/month_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/segmented_state_widget.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/states/state.dart' as s;
import '../../controllers/account_store.dart';
import '../../controllers/new_balance_store.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';

enum _Balances { initial, expected, last }

class BalancesSection extends StatefulWidget {
  const BalancesSection({
    super.key,
    required this.accountStore,
    required this.balanceStore,
  });

  final AccountStore accountStore;
  final NewBalanceStore balanceStore;

  @override
  State<BalancesSection> createState() => _BalancesSectionState();
}

class _BalancesSectionState extends State<BalancesSection> {
  late bool showInitialBalance;
  late bool showActualBalance;
  late bool showExpectedBalance;
  late bool showFinalBalance;

  late String expectedBalanceLoadingLeading;
  late String expectedBalanceErrorLeading;

  Account? selectedAccount;

  @override
  void initState() {
    super.initState();
    widget.accountStore.addSelectedAccountListener(_onAccountChanged);
    selectedAccount = widget.accountStore.selectedAccount;
    _resolveBalancesToShow();
  }

  @override
  void dispose() {
    widget.accountStore.removeSelectedAccountListener(_onAccountChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.05,
      ),
      child: Observer(builder: (_) {
        _resolveBalancesToShow();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showActualBalance) _buildActualBalanceRow(),
            if (showInitialBalance)
              _buildBalanceRow(
                leading: 'Saldo Inicial',
                balanceVariable: _Balances.initial,
                isBold: true,
                isBig: true,
              ),
            const SizedBox(height: 12.0),
            if (showExpectedBalance)
              _buildBalanceRow(
                leading: 'Saldo Esperado',
                balanceVariable: _Balances.expected,
                loadingText: expectedBalanceLoadingLeading,
                errorText: expectedBalanceErrorLeading,
              ),
            if (showFinalBalance)
              _buildBalanceRow(
                leading: 'Saldo Final',
                balanceVariable: _Balances.last,
              ),
          ],
        );
      }),
    );
  }

  void _onAccountChanged(Account? newSelected) {
    setState(() {
      selectedAccount = newSelected;
    });
  }

  Widget _buildActualBalanceRow() {
    return Spaced(
      first: const BigText.bold('Saldo Atual'),
      second: ScopedBuilder<AccountStore, List<Account>>(
        store: widget.accountStore,
        onState: (context, accs) {
          var actualBalance = _resolveActualBalance(accs);

          return Price.big(
            actualBalance,
            fontWeight: FontWeight.bold,
            color: _resolveBalanceColor(actualBalance),
          );
        },
        onLoading: (ctx) => const BigText.bold('Obtendo...'),
        onError: (ctx, fail) => const BigText.bold('Erro ao Obter'),
      ),
    );
  }

  Widget _buildBalanceRow({
    required String leading,
    required _Balances balanceVariable,
    String loadingText = 'Obtendo...',
    String errorText = 'Erro ao Obter',
    bool isBold = false,
    bool isBig = false,
  }) {
    return Spaced(
      first: Text(
        leading,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: isBig ? UmbrellaSizes.big : UmbrellaSizes.medium,
        ),
      ),
      second: Observer(builder: (_) {
        return SegmentedStateWidget(
          state: _resolve(balanceVariable),
          onLoading: (_) => MediumText(loadingText),
          onFail: (_, __) => MediumText(errorText),
          onState: (_, balance) => Price(
            balance,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBig ? UmbrellaSizes.big : UmbrellaSizes.medium,
            color: _resolveBalanceColor(balance),
          ),
        );
      }),
    );
  }

  s.State<double> _resolve(_Balances variable) => switch (variable) {
        _Balances.initial => widget.balanceStore.initial,
        _Balances.expected => widget.balanceStore.expected,
        _Balances.last => widget.balanceStore.last,
      };

  void _resolveBalancesToShow() {
    showActualBalance = false;
    showInitialBalance = false;
    showExpectedBalance = false;
    showFinalBalance = false;

    var (:month, :year) = BindServiceProvider.get<MonthStore>().month;

    var date = Date.fromMonth(month, year);
    var isActualMonth = date.isOfActualMonth;

    if (isActualMonth) {
      showActualBalance = true;
    } else {
      showInitialBalance = true;
    }

    if (date.isMonthBefore(Date.today())) {
      showFinalBalance = true;
    } else {
      showExpectedBalance = true;
      expectedBalanceLoadingLeading =
          isActualMonth ? 'Obtendo...' : 'Calculando...';
      expectedBalanceErrorLeading =
          isActualMonth ? 'Erro ao Obter' : 'Erro ao Calcular';
    }
  }

  double _resolveActualBalance(List<Account> accs) {
    if (selectedAccount == null) {
      double balance = 0.00;

      for (var acc in accs) {
        balance = (balance + acc.actualBalance).roundToDecimal();
      }
      return balance;
    }

    return selectedAccount!.actualBalance;
  }

  Color _resolveBalanceColor(double balance) {
    return balance.isNegative
        ? UmbrellaPalette.negativeBalanceColor
        : Colors.black;
  }
}
