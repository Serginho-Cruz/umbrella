import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/account_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/balance_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/paiyable_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/umbrella_icon_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/payment_method_selector_dialog.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/umbrella_scaffold.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_scoped_builder.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/paiyable_information_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/payment_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/models/paiyable_model.dart';

class PaymentScreen<E extends Paiyable, T extends PaiyableModel<E>>
    extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.model,
    required this.store,
    this.isCreditAllowed = true,
    this.unallowedCard,
    required this.accountStore,
    required this.balanceStore,
  });

  final T model;
  final PaiyableStore<E, T> store;
  final bool isCreditAllowed;
  final CreditCard? unallowedCard;
  final AccountStore accountStore;
  final BalanceStore balanceStore;
  final CreditCardStore cardStore;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentMethod> methods = [];
  List<Widget> paymentCards = [];

  @override
  void initState() {
    super.initState();
    methods.addAll(PaymentMethod.normals);

    if (!widget.isCreditAllowed) {
      methods.removeWhere((method) => method == const PaymentMethod.credit());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListScopedBuilder<AccountStore, List<Account>>(
      store: widget.accountStore,
      loadingWidget: UmbrellaScaffold(
        appBar: const CustomAppBar(title: 'Pagamento', showBalances: false),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: MediaQuery.sizeOf(context).width - 100.0,
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(height: 20.0),
              const BigText.bold('Carregando Contas...')
            ],
          ),
        ),
      ),
      //Implements Something when an error occurs on account store
      onError: (ctx, fail) {
        return const SizedBox.shrink();
      },
      //Same here, users cannot have 0 accounts
      onEmptyState: () {
        return const SizedBox.shrink();
      },
      onState: (ctx, accounts) {
        return UmbrellaScaffold(
          appBar: CustomAppBar(
            title: 'Pagamento',
            showMonthChanger: true,
            onMonthChange: (_, __) {},
            accountStore: widget.accountStore,
            balanceStore: widget.balanceStore,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PaiyableInformationCard(model: widget.model),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                UmbrellaIconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 28.0,
                  ),
                  onPressed: showRemainingPaymentMethods,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showRemainingPaymentMethods() {
    if (methods.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => PaymentMethodSelectorDialog(
        onSelected: addPaymentSection,
        paymentMethods: methods,
      ),
    );
  }

  void onPaymentMethodSelected(PaymentMethod method) {
    addPaymentSection(method);
    methods.remove(method);
  }

  void addPaymentSection(PaymentMethod method) {
    paymentCards.add(
      PaymentCard(
        paymentMethod: method,
        accounts: accounts,
        initiallySelectedAccount: initiallySelectedAccount,
        onAccountChanged: onAccountChanged,
        onValueChanged: onValueChanged,
      ),
    );
  }
}
