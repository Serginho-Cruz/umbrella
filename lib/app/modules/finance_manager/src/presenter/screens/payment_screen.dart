import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/date.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/income_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/account_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/balance_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/paiyable_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/currency_format.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/resolve_paiyable_name.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/umbrella_palette.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/umbrella_sizes.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/primary_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/reset_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/umbrella_icon_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/payment_method_selector_dialog.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/umbrella_dialogs.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/umbrella_scaffold.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_scoped_builder.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/paiyable_information_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/payment_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment/payment_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/big_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/extrabig_text.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/payment_record.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/models/paiyable_model.dart';
import '../../domain/states/state.dart' as S;
import '../../errors/api_errors.dart';
import '../widgets/layout/spaced.dart';

class PaymentScreen<E extends Paiyable, T extends PaiyableModel<E>>
    extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.model,
    required this.store,
    this.isCreditAllowed = true,
    this.isBoletoAllowed = true,
    this.unallowedCard,
    required this.accountStore,
    required this.balanceStore,
    required this.cardStore,
  });

  final T model;
  final PaiyableStore<E, T> store;
  final bool isCreditAllowed;
  final bool isBoletoAllowed;
  final CreditCard? unallowedCard;
  final AccountStore accountStore;
  final BalanceStore balanceStore;
  final CreditCardStore cardStore;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState<E>();
}

class _PaymentScreenState<E extends Paiyable> extends State<PaymentScreen> {
  List<PaymentMethod> remainingMethods = [];
  List<PaymentMethod> sortedMethods = [];
  List<Widget> paymentCards = [];

  Map<PaymentMethod, PaymentRecord<E>> payments = {};
  double goingToPay = 0.00;
  CreditCard? selectedCard;

  late final GlobalKey<AnimatedListState> _listKey;

  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey();

    remainingMethods
      ..clear()
      ..addAll(PaymentMethod.all);

    if (!widget.isCreditAllowed) {
      remainingMethods.remove(const PaymentMethod.credit());
    }

    if (!widget.isBoletoAllowed) {
      remainingMethods.remove(const PaymentMethod.boleto());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListScopedBuilder<AccountStore, List<Account>>(
      store: widget.accountStore,
      loadingWidget: UmbrellaScaffold(
        appBar: CustomAppBar(
          title: widget.model is IncomeModel ? 'Recebimento' : 'Pagamento',
          showBalances: false,
        ),
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
            title: widget.model is IncomeModel ? 'Recebimento' : 'Pagamento',
            showMonthChanger: true,
            onMonthChange: (_, __) {},
          ),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05,
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
              const ExtrabigText.bold(
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
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Dismissible(
                        key: ValueKey(index),
                        background: Container(
                          color: UmbrellaPalette.errorColor,
                          child: const Icon(Icons.delete, size: 40.0),
                        ),
                        onDismissed: (_) {
                          removePaymentSection(sortedMethods[index]);
                        },
                        child: ScaleTransition(
                          alignment: Alignment.topCenter,
                          scale: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                          child: paymentCards[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
              UnconstrainedBox(
                child: UmbrellaIconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 35.0,
                  ),
                  onPressed: showRemainingPaymentMethods,
                ),
              ),
              Spaced(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                first: ResetButton(
                  reset: resetPayments,
                  label: const MediumText.bold('Limpar'),
                ),
                second: PrimaryButton(
                  label: MediumText.bold(
                      widget.model is IncomeModel ? 'Receber' : 'Pagar'),
                  onPressed: pay,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void pay() {
    String? errorMsg = validatePayments();

    if (errorMsg != null) {
      UmbrellaDialogs.showError(context, errorMsg);
      return;
    }

    widget.store
        .pay(payments: payments.values.toList(), card: selectedCard)
        .then((result) {
      result.fold((_) async {
        String name = resolvePaiyableTypeName(widget.model);
        await UmbrellaDialogs.showSuccess(context,
            title: '$name paga com sucesso',
            message:
                'Sua $name foi paga com sucesso, iremos redirecionar você de volta');

        if (mounted) {
          Navigator.pop(context);
        }
      }, (fail) {
        UmbrellaDialogs.showError(context, fail.message,
            onRetry: fail is NetworkFail ? pay : null);
      });
    });
  }

  String? validatePayments() {
    return switch (payments) {
      _ when payments.isEmpty =>
        'Adicione pelo menos uma seção para fazer o pagamento.',
      _ when goingToPay <= 0.00 => 'O valor a pagar deve ser maior que 0.',
      _ when goingToPay > widget.model.remainingValue =>
        'O valor a pagar é maior do que o valor restante da ${resolvePaiyableTypeName(widget.model)}.',
      _
          when payments.containsKey(const PaymentMethod.credit()) &&
              !widget.isCreditAllowed =>
        'Você não pode pagar esta despesa no Crédito.',
      _
          when payments.containsKey(const PaymentMethod.credit()) &&
              selectedCard == null =>
        'Selecione um Cartão na seção de Crédito.',
      _ => null,
    };
  }

  void resetPayments() {
    for (var method in sortedMethods) {
      _listKey.currentState!.removeItem(
        0,
        (ctx, animation) => ScaleTransition(
          alignment: Alignment.topCenter,
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: buildCard(method),
        ),
        duration: const Duration(milliseconds: 700),
      );
    }

    remainingMethods
      ..clear()
      ..addAll(PaymentMethod.all);

    sortedMethods.clear();

    if (!widget.isCreditAllowed) {
      remainingMethods.remove(const PaymentMethod.credit());
    }

    paymentCards.clear();
    payments.clear();
    selectedCard = null;
    goingToPay = 0.00;

    setState(() {});
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
    payments[method] = PaymentRecord<E>(
      id: '',
      usedAccount: widget.model.account,
      paiyable: widget.model.toEntity() as E,
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
      (ctx, animation) => const SizedBox.shrink(),
    );

    setState(() {
      goingToPay -= payments[method]!.value;
    });

    payments.remove(method);
    remainingMethods.add(method);

    sortedMethods.remove(method);
  }

  Widget buildCard(PaymentMethod method) {
    var (:onValueChanged, :onAccountChanged, :onCardChanged) =
        resolveFunctions(method);

    if (method.isCredit) {
      var isSuccess = widget.cardStore.state is S.SuccessState;
      return PaymentCreditCard(
        accounts: widget.accountStore.state,
        creditCards: isSuccess
            ? (widget.cardStore.state as S.SuccessState<List<CreditCard>>).state
            : [],
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
  }) resolveFunctions(PaymentMethod method) {
    void Function(double) onValueChanged;
    void Function(Account) onAccountChanged;
    void Function(CreditCard?) onCardChanged = (_) {};

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

    if (method == const PaymentMethod.credit()) {
      onCardChanged = (c) {
        setState(() {
          selectedCard = c?.copyWith();
        });
      };
    }
    return (
      onValueChanged: onValueChanged,
      onAccountChanged: onAccountChanged,
      onCardChanged: onCardChanged,
    );
  }
}
