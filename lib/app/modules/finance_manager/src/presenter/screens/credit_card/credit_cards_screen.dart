import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/balance_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/tappable/credit_card_tappable_options.dart';

import '../../controllers/account_store.dart';
import '../../widgets/buttons/navigation_icon_button.dart';
import '../../controllers/credit_card_store.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/cards/credit_card_widget.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/filters/umbrella_search_bar.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/others/list_scoped_builder.dart';
import '../../widgets/shimmer/shimmer_card.dart';
import '../../widgets/tappable/tappable.dart';
import '../../widgets/texts/medium_text.dart';

class CreditCardsScreen extends StatefulWidget {
  const CreditCardsScreen({
    super.key,
    required AccountStore accountStore,
    required BalanceStore balanceStore,
    required CreditCardStore cardStore,
  })  : _cardStore = cardStore,
        _balanceStore = balanceStore,
        _accountStore = accountStore;

  final CreditCardStore _cardStore;
  final AccountStore _accountStore;
  final BalanceStore _balanceStore;

  @override
  State<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  String? filteredName;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Meus Cartões',
        accountStore: widget._accountStore,
        balanceStore: widget._balanceStore,
        showMonthChanger: true,
        onMonthChange: (_, __) {
          Future(_fetchCards);
        },
      ),
      floatingActionButton: const NavigationIconButton(
        route: '/finance_manager/card/add',
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30.0),
              UmbrellaSearchBar(searchFunction: widget._cardStore.filterByName),
              const SizedBox(height: 20.0),
              ListScopedBuilder<CreditCardStore, List<CreditCard>>(
                store: widget._cardStore,
                loadingWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (_) => const ShimmerCard()),
                ),
                onError: (ctx, fail) {
                  UmbrellaDialogs.showError(
                    context,
                    fail.message,
                  );
                  return const Center(
                    child:
                        MediumText('Erro ao obter os seus cartões de crédito'),
                  );
                },
                onEmptyState: () {
                  String text;

                  if (filteredName != null) {
                    text = 'Nenhum Cartão encontrado com o nome $filteredName';
                  } else {
                    text =
                        'Nenhuma Cartão encontrado. Que tal cadastrar um agora mesmo?';
                  }

                  return SizedBox(
                    height: 200.0,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.credit_card, size: 60.0),
                        const SizedBox(height: 20.0),
                        MediumText.bold(
                          text,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  );
                },
                onState: (ctx, cards) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(cards.length, (i) {
                      return Tappable(
                        options: CreditCardTappableOptions.get(
                          context: context,
                          card: cards[i],
                          onPop: _fetchCards,
                        ),
                        child: CreditCardWidget(
                          creditCard: cards[i],
                          margin: const EdgeInsets.symmetric(vertical: 20.0),
                        ),
                      );
                    }),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NavigationButton.toIncomes(context, height: 60.0),
                    NavigationButton.toExpenses(context, height: 60.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchCards() {
    Future(() => widget._cardStore.getAll());
  }
}
