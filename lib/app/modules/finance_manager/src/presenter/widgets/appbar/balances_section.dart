import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/date.dart';
import '../../controllers/account_store.dart';
import '../../controllers/balance_store.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';

class BalancesSection extends StatefulWidget {
  const BalancesSection({
    super.key,
    required this.accountStore,
    required this.balanceStore,
    required this.visualisationDate,
  });

  final AccountStore accountStore;
  final BalanceStore balanceStore;
  final Date visualisationDate;

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
  void didUpdateWidget(covariant BalancesSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.visualisationDate
        .isAtTheSameMonthAs(widget.visualisationDate)) {
      _resolveBalancesToShow();
    }
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showActualBalance) _buildActualBalanceRow(),
          if (showInitialBalance)
            _buildBalanceRow(
              leading: 'Saldo Inicial',
              resolveBalanceValue: (balances) => balances.$1,
              isBold: true,
              isBig: true,
            ),
          const SizedBox(height: 12.0),
          if (showExpectedBalance)
            _buildBalanceRow(
              leading: 'Saldo Esperado',
              resolveBalanceValue: (balances) => balances.$2,
              loadingText: expectedBalanceLoadingLeading,
              errorText: expectedBalanceErrorLeading,
            ),
          if (showFinalBalance)
            _buildBalanceRow(
              leading: 'Saldo Final',
              resolveBalanceValue: (balances) => balances.$3,
            ),
        ],
      ),
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
    required double Function((double, double, double)) resolveBalanceValue,
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
      second: ScopedBuilder<BalanceStore, (double, double, double)>(
        store: widget.balanceStore,
        onState: (ctx, balances) {
          double balance = resolveBalanceValue(balances);

          return Price(
            balance,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBig ? UmbrellaSizes.big : UmbrellaSizes.medium,
            color: _resolveBalanceColor(balance),
          );
        },
        onLoading: (ctx) => MediumText(loadingText),
        onError: (ctx, _) => MediumText(errorText),
      ),
    );
  }

  void _resolveBalancesToShow() {
    showActualBalance = false;
    showInitialBalance = false;
    showExpectedBalance = false;
    showFinalBalance = false;

    var date = widget.visualisationDate.copyWith();
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
