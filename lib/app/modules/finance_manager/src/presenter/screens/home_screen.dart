import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/domain/entities/user_state.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_scoped_builder.dart';
import '../../../../bind_service_provider.dart';
import '../controllers/balance_store.dart';
import '../controllers/credit_card_store.dart';
import '../controllers/expense_store.dart';
import '../controllers/income_store.dart';
import '../utils/umbrella_palette.dart';
import '../controllers/account_store.dart';
import '../widgets/cards/credit_card_widget.dart';
import '../widgets/cards/expense_card.dart';
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
    required BalanceStore balanceStore,
  })  : _accountStore = accountStore,
        _incomeStore = incomeStore,
        _expenseStore = expenseStore,
        _creditCardStore = creditCardStore,
        _balanceStore = balanceStore;

  final AccountStore _accountStore;
  final IncomeStore _incomeStore;
  final ExpenseStore _expenseStore;
  final CreditCardStore _creditCardStore;
  final BalanceStore _balanceStore;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appBarKey = const ValueKey(2);

  @override
  void initState() {
    super.initState();
    Future(() {
      widget._creditCardStore.getAll();
      widget._accountStore.getAll();
    });

    widget._accountStore.addSelectedAccountListener(_onAccountChanged);
  }

  @override
  void dispose() {
    widget._accountStore.removeSelectedAccountListener(_onAccountChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext screenContext) {
    return ListScopedBuilder<AccountStore, List<Account>>(
      store: widget._accountStore,
      loadingWidget: UmbrellaScaffold(
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
      //Implements Something when an error occurs on account store
      onError: (ctx, fail) {
        return Scaffold(
          body: Center(
            child: BigText('Erro: ${fail.message}'),
          ),
        );
      },
      //Same here, users cannot have 0 accounts
      onEmptyState: () {
        return const Scaffold(
          body: Center(
            child: BigText('Nenhuma Conta foi Criada'),
          ),
        );
      },
      onState: (ctx, accounts) {
        return UmbrellaScaffold(
          appBar: CustomAppBar(
            key: appBarKey,
            title: 'Home',
            showMonthChanger: true,
            onMonthChange: (_, __) => _fetchAll(accounts),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              widget._accountStore.getAll(force: true);
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
                    child: AccountSelector(
                      label: 'Conta Atual',
                      accounts: accounts,
                      selectedAccount: widget._accountStore.selectedAccount,
                      onSelected: widget._accountStore.changeSelectedAccount,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 20.0),
                    child: BigText('Olá $_getUserName!'),
                  ),
                  _makeSection(
                    title: 'Receitas',
                    child: Observer(builder: (_) {
                      return ListSegmentedStateWidget(
                        state: widget._incomeStore.state,
                        onLoading: (_) => _makeShimmerList(),
                        onFail: (ctx, f) => SizedBox(
                          height: 260,
                          width: 300,
                          child: Center(child: MediumText(f.message)),
                        ),
                        onState: (ctx, state) => HorizontalAnimatedList(
                          height: 260,
                          length: state.length,
                          itemBuilderFunction: (context, index) {
                            return UnconstrainedBox(
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
                                    onPop: () {
                                      widget._balanceStore.getForAll(
                                        accounts: accounts,
                                      );
                                      _fetchIncomes();
                                    },
                                  ),
                                  child: IncomeCard(model: state[index]),
                                ),
                              ),
                            );
                          },
                        ),
                        onEmpty: (_) => const SizedBox(height: 300),
                      );
                    }),
                  ),
                  _makeSection(
                    title: 'Despesas',
                    child: Observer(builder: (_) {
                      return ListSegmentedStateWidget(
                        state: widget._expenseStore.state,
                        onLoading: (_) => _makeShimmerList(),
                        onFail: (ctx, f) => SizedBox(
                          height: 260,
                          width: 300,
                          child: Center(child: MediumText(f.message)),
                        ),
                        onState: (ctx, state) => HorizontalAnimatedList(
                          height: 260,
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
                                    onPop: () {
                                      widget._balanceStore.getForAll(
                                        accounts: accounts,
                                      );
                                      _fetchExpenses();
                                    },
                                  ),
                                  child: ExpenseCard(model: state[index]),
                                ),
                              ),
                            );
                          },
                        ),
                        onEmpty: (_) => const SizedBox(height: 300),
                      );
                    }),
                  ),
                  _makeSection(
                    title: 'Cartões de Crédito',
                    child: Observer(builder: (_) {
                      return ListSegmentedStateWidget(
                        state: widget._creditCardStore.state,
                        onLoading: (ctx) => _makeShimmerList(
                          height: 220,
                          shimmerWidth: 240,
                          shimmerHeight: 140,
                        ),
                        onFail: (ctx, f) => Text(f.message),
                        onState: (ctx, state) {
                          return HorizontalAnimatedList(
                            height: 220,
                            length: state.length,
                            itemBuilderFunction: (context, index) {
                              return UnconstrainedBox(
                                child: Tappable(
                                  options: CreditCardTappableOptions.get(
                                    context: screenContext,
                                    card: state[index],
                                    onPop: widget._creditCardStore.getAll,
                                  ),
                                  child: CreditCardWidget(
                                    creditCard: state[index],
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        onEmpty: (ctx) => const SizedBox(height: 220),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String get _getUserName =>
      (BindServiceProvider.get<AuthStore>().state as SuccessState).user.name;

  void _onAccountChanged(Account? newSelected) {
    setState(() {});
    _fetchAll(widget._accountStore.state);
  }

  void _fetchAll(List<Account> accounts) {
    _fetchIncomes();
    _fetchExpenses();
  }

  void _fetchIncomes() {
    widget._incomeStore.getAll();
  }

  void _fetchExpenses() {
    widget._expenseStore.getAll();
  }

  Widget _makeSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
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

  Widget _makeShimmerList({
    double height = 260,
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
