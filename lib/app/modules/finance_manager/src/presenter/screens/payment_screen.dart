import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/income_model.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/account_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/balance_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/credit_card_store.dart';
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
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/texts/medium_text.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/models/paiyable_model.dart';
import '../../domain/states/state.dart' as s;
import '../../errors/api_errors.dart';
import '../controllers/paiyable_store.dart';
import '../widgets/layout/spaced.dart';

class PaymentScreen<E extends Paiyable, T extends PaiyableModel<E>>
    extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.model,
    required this.store,
    required this.accountStore,
    required this.balanceStore,
    required this.cardStore,
  });

  final T model;
  final PaiyableStore<T, E> store;
  final AccountStore accountStore;
  final BalanceStore balanceStore;
  final CreditCardStore cardStore;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState<E>();
}

class _PaymentScreenState<E extends Paiyable> extends State<PaymentScreen> {
  late final GlobalKey<AnimatedListState> _listKey;

  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey();
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
              Observer(
                builder: (_) => _buildTextValue(
                  'Atualmente Pagando: ',
                  widget.store.totalPaying,
                ),
              ),
              const SizedBox(height: 40.0),
              Observer(
                builder: (_) => Visibility(
                  visible: widget.store.paymentsToDo.isNotEmpty,
                  child: const BigText.bold(
                    'Seções de Pagamento',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Observer(builder: (_) {
                return AnimatedList(
                  key: _listKey,
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  shrinkWrap: true,
                  initialItemCount: widget.store.paymentsToDo.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index, animation) {
                    var payment = widget.store.paymentsToDo[index];
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
                            removePaymentSection(payment.paymentMethod);
                          },
                          child: ScaleTransition(
                            alignment: Alignment.topCenter,
                            scale: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                            child: buildCard(payment.paymentMethod),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
              UnconstrainedBox(
                child: UmbrellaIconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 35.0,
                  ),
                  isPrimary: false,
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

  @override
  void dispose() {
    widget.store.restartPayments();
    super.dispose();
  }

  void pay() {
    String? errorMsg = validatePayments();

    if (errorMsg != null) {
      UmbrellaDialogs.showError(context, errorMsg);
      return;
    }

    widget.store.pay().then((fail) async {
      if (fail == null && mounted) {
        String name = resolvePaiyableTypeName(widget.model);

        await UmbrellaDialogs.showSuccess(context,
            title: '$name paga com sucesso',
            message:
                'Sua $name foi paga com sucesso, iremos redirecionar você de volta');

        if (mounted) {
          Navigator.pop(context);
        }
        return;
      } else {
        if (mounted) {
          UmbrellaDialogs.showError(
            context,
            fail!.message,
            onRetry: fail is NetworkFail ? pay : null,
          );
        }
      }
    });
  }

  String? validatePayments() {
    var payments = widget.store.paymentsToDo;
    return switch (payments) {
      _ when payments.isEmpty =>
        'Adicione pelo menos uma seção para fazer o pagamento.',
      _ when widget.store.totalPaying <= 0.00 =>
        'O valor a pagar deve ser maior que 0.',
      _ when widget.store.totalPaying > widget.model.remainingValue =>
        'O valor a pagar é maior do que o valor restante da ${resolvePaiyableTypeName(widget.model)}.',
      _ => null,
    };
  }

  void resetPayments() {
    for (var payment in widget.store.paymentsToDo) {
      _listKey.currentState!.removeItem(
        0,
        (ctx, animation) => ScaleTransition(
          alignment: Alignment.topCenter,
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: buildCard(payment.paymentMethod),
        ),
        duration: const Duration(milliseconds: 700),
      );
    }

    widget.store.restartPayments();
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
    if (widget.store.remainingMethods.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => PaymentMethodSelectorDialog(
        onSelected: addPaymentSection,
        paymentMethods: widget.store.remainingMethods,
      ),
    );
  }

  void addPaymentSection(PaymentMethod method) {
    widget.store.addPayment(method: method, account: widget.model.account);

    _listKey.currentState!.insertItem(widget.store.paymentsToDo.length - 1);
  }

  void removePaymentSection(PaymentMethod method) {
    var index = widget.store.paymentsToDo
        .indexWhere((rec) => rec.paymentMethod == method);

    widget.store.removePayment(method);

    _listKey.currentState!.removeItem(
      index,
      (ctx, animation) => const SizedBox.shrink(),
    );
  }

  Widget buildCard(PaymentMethod method) {
    var (:onValueChanged, :onAccountChanged, :onCardChanged) =
        resolveFunctions(method);

    if (method.isCredit) {
      var isSuccess = widget.cardStore.state is s.SuccessState;
      return PaymentCreditCard(
        accounts: widget.accountStore.state,
        creditCards: isSuccess
            ? (widget.cardStore.state as s.SuccessState<List<CreditCard>>).state
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
      widget.store.setPaymentAccount(method: method, account: acc);
    };
    onValueChanged = (value) {
      widget.store.setPaymentValue(method: method, value: value);
    };

    if (method == const PaymentMethod.credit()) {
      onCardChanged = (c) {
        widget.store.setPaymentCreditCard(c);
      };
    }
    return (
      onValueChanged: onValueChanged,
      onAccountChanged: onAccountChanged,
      onCardChanged: onCardChanged,
    );
  }
}
