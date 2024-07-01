import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/drawer/my_drawer.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_scoped_builder.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/tappable_options.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/models/income_model.dart';
import '../utils/umbrella_palette.dart';
import '../controllers/account_controller.dart';
import '../controllers/credit_card_store.dart';
import '../controllers/expense_store.dart';
import '../controllers/income_store.dart';
import '../widgets/appbar/month_changer.dart';
import '../widgets/cards/credit_card_widget.dart';
import '../widgets/cards/expense_card.dart';
import '../widgets/layout/horizontal_listview.dart';
import '../widgets/layout/horizontal_infinity_container.dart';
import '../widgets/cards/income_card.dart';
import '../widgets/selectors/account_selector.dart';
import '../widgets/shimmer/shimmer_container.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/layout/horizontal_animated_list.dart';
import '../widgets/others/tappable.dart';
import '../widgets/texts/big_text.dart';
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
  Account? selectedAccount;

  @override
  void initState() {
    super.initState();

    selectedAccount = widget._accountStore.selectedAccount;
    Future.delayed(Duration.zero, () {
      widget._creditCardStore.getAll();
      widget._accountStore.getAll();
    });
  }

  @override
  Widget build(BuildContext screenContext) {
    return SafeArea(
      child: ListScopedBuilder<AccountStore, List<Account>>(
        store: widget._accountStore,
        loadingWidget: Scaffold(
          appBar: CustomAppBar(title: 'Home', showBalances: false),
          body: Center(
            child: SizedBox.fromSize(
              size: MediaQuery.sizeOf(screenContext),
              child: const CircularProgressIndicator(),
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
          return Scaffold(
            backgroundColor: Colors.white,
            drawer: MyDrawer(),
            appBar: CustomAppBar(
              title: 'Home',
              showMonthChanger: true,
              onMonthChange: (_, __) {
                _fetchAll(accounts);
              },
            ),
            body: RefreshIndicator(
              onRefresh: widget._accountStore.getAll,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
                      child: AccountSelector(
                        label: 'Conta Atual',
                        accounts: accounts,
                        selectedAccount: selectedAccount,
                        onSelected: (selected) {
                          setState(() => selectedAccount = selected);

                          _fetchAll(accounts);
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0, bottom: 30.0),
                      child: BigText('Olá! Obrigado por Voltar'),
                    ),
                    _makeSection(
                      title: 'Receitas',
                      child: ListScopedBuilder<IncomeStore, List<IncomeModel>>(
                        store: widget._incomeStore,
                        loadingWidget: _makeShimmerList(),
                        onError: (ctx, f) => Text(f.message),
                        onState: (ctx, state) => HorizontalAnimatedList(
                          height: 325,
                          length: state.length,
                          itemBuilderFunction: (context, index) {
                            return Tappable(
                              options: TappableOptions.incomes(
                                context: screenContext,
                                model: state[index],
                                store: widget._incomeStore,
                                onPop: () {
                                  _fetchIncomes(accounts);
                                },
                              ),
                              child: IncomeCard(model: state[index]),
                            );
                          },
                        ),
                        onEmptyState: () => const SizedBox(height: 300),
                      ),
                    ),
                    _makeSection(
                      title: 'Despesas',
                      child:
                          ListScopedBuilder<ExpenseStore, List<ExpenseModel>>(
                        store: widget._expenseStore,
                        loadingWidget: _makeShimmerList(),
                        onError: (ctx, f) => Text(f.message),
                        onState: (ctx, state) => HorizontalAnimatedList(
                          height: 325,
                          length: state.length,
                          itemBuilderFunction: (context, index) {
                            return Tappable(
                              options: TappableOptions.expenses(
                                context: screenContext,
                                model: state[index],
                                store: widget._expenseStore,
                                onPop: () => _fetchExpenses(accounts),
                              ),
                              child: ExpenseCard(model: state[index]),
                            );
                          },
                        ),
                        onEmptyState: () => const SizedBox(height: 300),
                      ),
                    ),
                    _makeSection(
                      title: 'Cartões de Crédito',
                      child:
                          ListScopedBuilder<CreditCardStore, List<CreditCard>>(
                        store: widget._creditCardStore,
                        loadingWidget: _makeShimmerList(
                          height: 240,
                          shimmerWidth: 275,
                          shimmerHeight: 150,
                        ),
                        onError: (ctx, f) => Text(f.message),
                        onState: (ctx, state) {
                          return HorizontalAnimatedList(
                            height: 240,
                            length: state.length,
                            itemBuilderFunction: (context, index) {
                              return Tappable(
                                options: TappableOptions.cards(
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
                              );
                            },
                          );
                        },
                        onEmptyState: () => const SizedBox(height: 300),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _fetchAll(List<Account> accounts) {
    Future(() {
      _fetchIncomes(accounts);
      _fetchExpenses(accounts);
    });
  }

  void _fetchIncomes(List<Account> accounts) {
    var (month, year) = _getMonthAndYear();

    if (selectedAccount != null) {
      widget._incomeStore.getAllOf(
        account: selectedAccount!,
        month: month,
        year: year,
      );
    } else {
      widget._incomeStore.getForAll(
        accounts: accounts,
        month: month,
        year: year,
      );
    }
  }

  void _fetchExpenses(List<Account> accounts) {
    var (month, year) = _getMonthAndYear();

    if (selectedAccount != null) {
      widget._expenseStore.getAllOf(
        account: selectedAccount!,
        month: month,
        year: year,
      );
    } else {
      widget._expenseStore.getForAll(
        accounts: accounts,
        month: month,
        year: year,
      );
    }
  }

  (int month, int year) _getMonthAndYear() {
    var date = MonthChanger.currentMonthAndYear;

    return (date.month, date.year);
  }

  Widget _makeSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: HorizontallyInfinityContainer(
        padding: const EdgeInsets.only(top: 20.0),
        color: UmbrellaPalette.gray,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TitleText.bold(title),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _makeShimmerList(
      {double height = 325,
      double shimmerWidth = 250,
      double shimmerHeight = 300}) {
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
