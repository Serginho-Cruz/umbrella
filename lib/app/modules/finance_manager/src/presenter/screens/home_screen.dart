import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user_state.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';
import '../../../../bind_service_provider.dart';
import '../stores/credit_card_store.dart';
import '../stores/expense_store.dart';
import '../stores/income_store.dart';
import '../utils/umbrella_palette.dart';
import '../stores/account_store.dart';
import '../widgets/cards/credit_card_widget.dart';
import '../widgets/cards/expense_card.dart';
import '../widgets/dialogs/umbrella_dialogs.dart';
import '../widgets/layout/horizontal_listview.dart';
import '../widgets/layout/horizontal_infinity_container.dart';
import '../widgets/cards/income_card.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/others/list_segmented_state_widget.dart';
import '../widgets/selectors/account_selector.dart';
import '../widgets/shimmer/shimmer_container.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/layout/horizontal_animated_list.dart';
import '../widgets/tappable/credit_card_tappable_options.dart';
import '../widgets/tappable/expense_tappable_options.dart';
import '../widgets/tappable/income_tappable_options.dart';
import '../widgets/tappable/tappable.dart';
import '../widgets/texts/big_text.dart';
import '../widgets/texts/medium_text.dart';
import '../widgets/texts/title_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required IncomeStore incomeStore,
    required ExpenseStore expenseStore,
    required CreditCardStore creditCardStore,
    required AccountStore accountStore,
  })  : _accountStore = accountStore,
        _incomeStore = incomeStore,
        _expenseStore = expenseStore,
        _creditCardStore = creditCardStore;

  final AccountStore _accountStore;
  final IncomeStore _incomeStore;
  final ExpenseStore _expenseStore;
  final CreditCardStore _creditCardStore;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appBarKey = const ValueKey(2);

  @override
  void initState() {
    super.initState();
    widget._creditCardStore.getAll();
    widget._accountStore.get();
  }

  @override
  Widget build(BuildContext screenContext) {
    return Observer(
      builder: (_) => ListSegmentedStateWidget(
        state: widget._accountStore.state,
        onInitial: (_) {
          return UmbrellaScaffold(
            appBar: CustomAppBar(
              title: 'Home',
              showMonthChanger: true,
            ),
            child: const SizedBox(),
          );
        },
        onLoading: (_) => UmbrellaScaffold(
          appBar: CustomAppBar(title: 'Home', showBalances: false),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: MediaQuery.sizeOf(screenContext).width - 100.0,
                  child: const CircularProgressIndicator(),
                ),
                const SizedBox(height: 20.0),
                const BigText.bold('Carregando Contas...')
              ],
            ),
          ),
        ),
        onFail: (ctx, fail) {
          UmbrellaDialogs.showError(
            context,
            fail.message,
            onRetry: widget._accountStore.get,
            onConfirmPressed: widget._accountStore.get,
          );

          return const SizedBox.shrink();
        },
        onEmpty: (_) {
          UmbrellaDialogs.showError(
            context,
            'Um Erro inesperado aconteceu. Por favor, tente novamente',
            onRetry: widget._accountStore.get,
            onConfirmPressed: widget._accountStore.get,
          );

          return const SizedBox.shrink();
        },
        onState: (ctx, accounts) => UmbrellaScaffold(
          appBar: CustomAppBar(
            key: appBarKey,
            title: 'Home',
            showMonthChanger: true,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              widget._accountStore.get(force: true);
              widget._creditCardStore.getAll();
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
                    child: Observer(
                      builder: (_) => AccountSelector(
                        label: 'Conta Atual',
                        accounts: accounts,
                        selectedAccount: widget._accountStore.selectedAccount,
                        onSelected: widget._accountStore.changeSelectedAccount,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 20.0),
                    child: BigText('Olá $_getUserName!'),
                  ),
                  makeSection(
                    title: 'Receitas',
                    child: Observer(
                      builder: (_) => ListSegmentedStateWidget(
                        state: widget._incomeStore.state,
                        onLoading: (_) => makeShimmerList(),
                        onFail: (ctx, f) => SizedBox(
                          height: 240,
                          width: 300,
                          child: Center(child: MediumText(f.message)),
                        ),
                        onState: (ctx, state) => HorizontalAnimatedList(
                          height: 240,
                          length: state.length,
                          itemBuilderFunction: (context, index) =>
                              UnconstrainedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Tappable(
                                options: IncomeTappableOptions.get(
                                  context: screenContext,
                                  model: state[index],
                                  store: widget._incomeStore,
                                  accountStore: widget._accountStore,
                                ),
                                child: IncomeCard(model: state[index]),
                              ),
                            ),
                          ),
                        ),
                        onEmpty: (_) => const SizedBox(height: 300),
                      ),
                    ),
                  ),
                  makeSection(
                    title: 'Despesas',
                    child: Observer(
                      builder: (_) => ListSegmentedStateWidget(
                        state: widget._expenseStore.state,
                        onLoading: (_) => makeShimmerList(),
                        onFail: (ctx, f) => SizedBox(
                          height: 240,
                          width: 300,
                          child: Center(child: MediumText(f.message)),
                        ),
                        onState: (ctx, state) => HorizontalAnimatedList(
                          height: 240,
                          length: state.length,
                          itemBuilderFunction: (context, index) {
                            return UnconstrainedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Tappable(
                                  options: ExpenseTappableOptions.get(
                                    context: screenContext,
                                    model: state[index],
                                    store: widget._expenseStore,
                                    accountStore: widget._accountStore,
                                  ),
                                  child: ExpenseCard(model: state[index]),
                                ),
                              ),
                            );
                          },
                        ),
                        onEmpty: (_) => const SizedBox(height: 300),
                      ),
                    ),
                  ),
                  makeSection(
                    title: 'Cartões de Crédito',
                    child: Observer(
                      builder: (_) => ListSegmentedStateWidget(
                        state: widget._creditCardStore.state,
                        onLoading: (ctx) => makeShimmerList(
                          height: 180,
                          shimmerWidth: 240,
                          shimmerHeight: 140,
                        ),
                        onFail: (ctx, f) => Text(f.message),
                        onState: (ctx, state) => HorizontalAnimatedList(
                          height: 180,
                          length: state.length,
                          itemBuilderFunction: (context, index) =>
                              UnconstrainedBox(
                            child: Tappable(
                              options: CreditCardTappableOptions.get(
                                context: screenContext,
                                card: state[index],
                              ),
                              child: CreditCardWidget(
                                creditCard: state[index],
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onEmpty: (ctx) => const SizedBox(height: 220),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _getUserName =>
      (BindServiceProvider.get<AuthStore>().state as SuccessState).user.name;

  Widget makeSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: HorizontallyInfinityContainer(
        color: UmbrellaPalette.gray,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 12.0),
              child: TitleText(title),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget makeShimmerList({
    double height = 240,
    double shimmerWidth = 230,
    double shimmerHeight = 180,
  }) {
    return SizedBox(
      height: height,
      child: HorizontalListView(
        itemCount: 4,
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        itemCallback: (i) => ShimmerContainer(
          height: shimmerHeight,
          width: shimmerWidth,
        ),
      ),
    );
  }
}
