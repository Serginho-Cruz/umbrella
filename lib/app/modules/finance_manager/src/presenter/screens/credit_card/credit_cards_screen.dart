import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/tappable/credit_card_tappable_options.dart';

import '../../controllers/credit_card_store.dart';
import '../../widgets/buttons/navigation_icon_button.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/cards/credit_card_widget.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/filters/umbrella_search_bar.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/others/list_segmented_state_widget.dart';
import '../../widgets/shimmer/shimmer_card.dart';
import '../../widgets/tappable/tappable.dart';
import '../../widgets/texts/medium_text.dart';

class CreditCardsScreen extends StatefulWidget {
  final CreditCardStore _cardStore;

  const CreditCardsScreen({
    super.key,
    required CreditCardStore cardStore,
  }) : _cardStore = cardStore;

  @override
  State<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  late final TextEditingController searchController;

  late final ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(
      text: widget._cardStore.searchString,
    );
    disposer = reaction((_) => widget._cardStore.searchString, (_) {
      widget._cardStore.filterByName();
    });
    _fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Meus Cartões',
        showMonthChanger: true,
        onMonthChange: (_, __) {
          Future(_fetchCards);
        },
      ),
      floatingActionButton: NavigationIconButton(
        route: '/finance_manager/card/add',
        onPop: _fetchCards,
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
              UmbrellaSearchBar(
                onChanged: (text) => widget._cardStore.setSearchString(text),
              ),
              const SizedBox(height: 20.0),
              Observer(builder: (_) {
                return ListSegmentedStateWidget(
                  state: widget._cardStore.state,
                  onLoading: (ctx) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (_) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: ShimmerCard(),
                      ),
                    ),
                  ),
                  onFail: (ctx, fail) {
                    UmbrellaDialogs.showError(
                      context,
                      fail.message,
                    );
                    return const Center(
                      child: MediumText(
                        'Erro ao obter os seus cartões de crédito',
                      ),
                    );
                  },
                  onEmpty: (ctx) => SizedBox(
                    height: 200.0,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.credit_card, size: 60.0),
                        SizedBox(height: 20.0),
                        MediumText.bold(
                          'Nenhum Cartão encontrado. Que tal cadastrar um agora mesmo?',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  onState: (ctx, _) => Observer(
                    builder: (_) {
                      var filtered = widget._cardStore.filteredCards;
                      return widget._cardStore.filteredCards.isEmpty
                          ? _mountEmptyCase(
                              'Nenhum Cartão encontrado com o nome filtrado')
                          : _mountStateCase(filtered);
                    },
                  ),
                );
              }),
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

  @override
  void dispose() {
    searchController.dispose();
    widget._cardStore.setSearchString('');
    disposer();
    super.dispose();
  }

  Widget _mountEmptyCase(String text) {
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
  }

  Widget _mountStateCase(List<CreditCard> cards) {
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
  }

  void _fetchCards() => widget._cardStore.getAll();
}
