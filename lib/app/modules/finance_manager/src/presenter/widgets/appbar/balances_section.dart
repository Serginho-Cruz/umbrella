import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/month_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/segmented_state_widget.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/date.dart';
import '../../../domain/states/state.dart' as s;
import '../../controllers/account_store.dart';
import '../../controllers/balance_store.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';
import '../layout/spaced.dart';
import '../texts/medium_text.dart';
import '../texts/price.dart';
import '../texts/small_text.dart';

enum _Balances { initial, expected, last }

class BalancesSection extends StatefulWidget {
  const BalancesSection({
    super.key,
    required this.accountStore,
    required this.balanceStore,
  });

  final AccountStore accountStore;
  final BalanceStore balanceStore;

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

  @override
  void initState() {
    super.initState();
    _resolveBalancesToShow();
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
                isMedium: true,
              ),
            const SizedBox(height: 8.0),
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

  Widget _buildActualBalanceRow() {
    return Spaced(
      first: const MediumText.bold('Saldo Atual'),
      second: Observer(builder: (_) {
        return SegmentedStateWidget(
          state: widget.accountStore.state,
          onState: (context, accs) {
            var actualBalance = _resolveActualBalance(accs);

            return Price.medium(
              actualBalance,
              fontWeight: FontWeight.bold,
              color: _resolveBalanceColor(actualBalance),
            );
          },
          onLoading: (ctx) => const MediumText.bold('Obtendo...'),
          onFail: (ctx, fail) => const MediumText.bold('Erro ao Obter'),
        );
      }),
    );
  }

  Widget _buildBalanceRow({
    required String leading,
    required _Balances balanceVariable,
    String loadingText = 'Obtendo...',
    String errorText = 'Erro ao Obter',
    bool isBold = false,
    bool isMedium = false,
  }) {
    Widget Function(String) constructor = switch (isMedium) {
      true when isBold == true => MediumText.bold,
      true => MediumText.new,
      false when isBold == true => SmallText.bold,
      false => SmallText.new,
    };

    return Spaced(
      first: constructor(leading),
      second: Observer(builder: (_) {
        return SegmentedStateWidget(
          state: _resolve(balanceVariable),
          onLoading: (_) => constructor(loadingText),
          onFail: (_, __) => constructor(errorText),
          onState: (_, balance) => Price(
            balance,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isMedium ? UmbrellaSizes.medium : UmbrellaSizes.small,
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
    if (widget.accountStore.selectedAccount == null) {
      double balance = 0.00;

      for (var acc in accs) {
        balance = (balance + acc.actualBalance).roundToDecimal();
      }
      return balance;
    }

    return widget.accountStore.selectedAccount!.actualBalance;
  }

  Color _resolveBalanceColor(double balance) {
    return balance.isNegative
        ? UmbrellaPalette.negativeBalanceColor
        : Colors.black;
  }
}
