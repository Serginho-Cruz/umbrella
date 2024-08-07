import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/account_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/balance_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/paiyable_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/currency_format.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/umbrella_sizes.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/umbrella_icon_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/payment_method_selector_dialog.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/umbrella_scaffold.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_scoped_builder.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/paiyable_information_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/payment_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/payment_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/extrabig_text.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/payment.dart';
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
    required this.cardStore,
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
  List<PaymentMethod> remainingMethods = [];
  List<PaymentMethod> sortedMethods = [];
  List<Widget> paymentCards = [];

  Map<PaymentMethod, Payment> payments = {};
  double goingToPay = 0.00;

  late final GlobalKey<AnimatedListState> _listKey;

  @override
  void initState() {
    super.initState();
    resetPayments();
    _listKey = GlobalKey();
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
        resetPayments();
        return const SizedBox.shrink();
      },
      //Same here, users cannot have 0 accounts
      onEmptyState: () {
        resetPayments();
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
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.1,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: PaiyableInformationCard(model: widget.model),
              ),
              const SizedBox(height: 10.0),
              _buildTextValue(
                'Necessário Pagar: ',
                widget.model.remainingValue,
              ),
              const SizedBox(height: 10.0),
              _buildTextValue('Atualmente Pagando: ', goingToPay),
              const SizedBox(height: 40.0),
              const Extrabig.bold(
                'Seções de Pagamento',
                textAlign: TextAlign.center,
              ),
              AnimatedList(
                key: _listKey,
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                shrinkWrap: true,
                initialItemCount: payments.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index, animation) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ScaleTransition(
                      alignment: Alignment.topCenter,
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                      child: paymentCards[index],
                    ),
                  );
                },
              ),
              UnconstrainedBox(
                child: UmbrellaIconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 28.0,
                  ),
                  onPressed: showRemainingPaymentMethods,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void resetPayments() {
    remainingMethods.clear();
    remainingMethods.addAll(PaymentMethod.normals);

    sortedMethods.clear();

    if (!widget.isCreditAllowed) {
      remainingMethods.remove(const PaymentMethod.credit());
    }

    paymentCards.clear();
    payments.clear();
    goingToPay = 0.00;

    if (!mounted) setState(() {});
  }

  Widget _buildTextValue(String label, double value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: label),
          TextSpan(
            text: CurrencyFormat.format(value),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
        style: const TextStyle(
          fontSize: UmbrellaSizes.medium,
          color: Colors.black,
        ),
      ),
    );
  }

  void showRemainingPaymentMethods() {
    if (remainingMethods.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => PaymentMethodSelectorDialog(
        onSelected: addPaymentSection,
        paymentMethods: remainingMethods,
      ),
    );
  }

  void addPaymentSection(PaymentMethod method) {
    payments[method] = Payment(
      usedAccount: widget.model.account,
      paiyable: widget.model.toEntity(),
      paymentMethod: method,
      value: 0.00,
      date: Date.today(),
    );

    sortedMethods.add(method);
    remainingMethods.remove(method);

    paymentCards.add(buildCard(method));
    _listKey.currentState!.insertItem(sortedMethods.length - 1);
  }

  void removePaymentSection(PaymentMethod method) {
    paymentCards.removeAt(sortedMethods.indexOf(method));

    _listKey.currentState!.removeItem(
      sortedMethods.indexOf(method),
      (ctx, animation) => UnconstrainedBox(
        child: ScaleTransition(
          scale: animation,
          alignment: Alignment.center,
          child: buildCard(method, isDeleting: true),
        ),
      ),
    );

    setState(() {
      goingToPay -= payments[method]!.value;
    });

    payments.remove(method);
    remainingMethods.add(method);

    sortedMethods.remove(method);

    debugPrint(sortedMethods.toString());
  }

  Widget buildCard(
    PaymentMethod method, {
    bool isDeleting = false,
  }) {
    var (:onValueChanged, :onAccountChanged, :onCardChanged) =
        resolveFunctions(method, isDeleting);

    if (method.isCredit) {
      return PaymentCreditCard(
        accounts: widget.accountStore.state,
        creditCards: widget.cardStore.state,
        initiallySelectedAccount: widget.model.account,
        onAccountChanged: onAccountChanged,
        onValueChanged: onValueChanged,
        onCardChanged: onCardChanged,
      );
    }

    return PaymentCard(
      accounts: widget.accountStore.state,
      initiallySelectedAccount: widget.model.account,
      onAccountChanged: onAccountChanged,
      onValueChanged: onValueChanged,
      paymentMethod: method,
    );
  }

  ({
    void Function(double) onValueChanged,
    void Function(Account) onAccountChanged,
    void Function(CreditCard?) onCardChanged,
  }) resolveFunctions(
    PaymentMethod method,
    bool isBeingDeleted,
  ) {
    void Function(double) onValueChanged = (_) {};
    void Function(Account) onAccountChanged = (_) {};
    void Function(CreditCard?) onCardChanged = (_) {};

    if (!isBeingDeleted) {
      onAccountChanged = (Account acc) {
        payments.update(
          method,
          (payment) => payment.copyWith(usedAccount: acc),
        );
      };
      onValueChanged = (value) {
        setState(() {
          goingToPay = goingToPay - payments[method]!.value + value;
        });
        payments.update(
          method,
          (payment) => payment.copyWith(value: value),
        );
      };
    }

    if (method == const PaymentMethod.credit()) {
      onCardChanged = (_) {};
    }
    return (
      onValueChanged: onValueChanged,
      onAccountChanged: onAccountChanged,
      onCardChanged: onCardChanged,
    );
  }
}
