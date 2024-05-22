import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/common/my_drawer.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/list_scoped_builder.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/umbrella_sizes.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/models/income_model.dart';
import '../../utils/umbrella_palette.dart';
import '../controllers/account_controller.dart';
import '../controllers/credit_card_store.dart';
import '../controllers/expense_store.dart';
import '../controllers/income_store.dart';
import '../widgets/credit_card_widget.dart';
import '../widgets/expense_card.dart';
import '../widgets/lists/horizontal_listview.dart';
import '../widgets/common/horizontal_infinity_container.dart';
import '../widgets/income_card.dart';
import '../widgets/shimmer/shimmer_container.dart';

import '../../domain/entities/date.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/lists/horizontal_animated_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.incomeStore,
    required this.expenseStore,
    required this.creditCardStore,
    required this.accountStore,
    super.key,
  });

  final AccountStore accountStore;
  final IncomeStore incomeStore;
  final ExpenseStore expenseStore;
  final CreditCardStore creditCardStore;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.creditCardStore.getAll();
    widget.accountStore.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ScopedBuilder<AccountStore, List<Account>>(
            store: widget.accountStore,
            onLoading: (ctx) {
              return const Center(
                child: SizedBox(
                  width: 300,
                  height: 400,
                  child: CircularProgressIndicator(),
                ),
              );
            },
            onState: (ctx, accounts) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: 'Home',
                    initialMonthAndYear: Date.today(),
                    onMonthChange: (month, year) {
                      _onMonthChange(month, year, accounts);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text(
                      'Olá! Obrigado por Voltar',
                      style: TextStyle(
                        fontSize: UmbrellaSizes.big,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _makeSection(
                    title: 'Receitas',
                    child: ListScopedBuilder<IncomeStore, List<IncomeModel>>(
                      store: widget.incomeStore,
                      loadingWidget: SizedBox(
                        height: 325,
                        child: _makeShimmerList(),
                      ),
                      onError: (ctx, f) => Text(f.message),
                      onState: (ctx, state) => SizedBox(
                        height: 325,
                        child: HorizontalAnimatedList(
                          length: state.length,
                          itemBuilderFunction: (context, index) {
                            return IncomeCard(model: state[index]);
                          },
                        ),
                      ),
                      onEmptyState: () => const SizedBox(height: 300),
                    ),
                  ),
                  _makeSection(
                    title: 'Despesas',
                    child: ListScopedBuilder<ExpenseStore, List<ExpenseModel>>(
                      store: widget.expenseStore,
                      loadingWidget: SizedBox(
                        height: 325,
                        child: _makeShimmerList(),
                      ),
                      onError: (ctx, f) => Text(f.message),
                      onState: (ctx, state) => SizedBox(
                        height: 325,
                        child: HorizontalAnimatedList(
                          length: state.length,
                          itemBuilderFunction: (context, index) {
                            return ExpenseCard(model: state[index]);
                          },
                        ),
                      ),
                      onEmptyState: () => const SizedBox(height: 300),
                    ),
                  ),
                  _makeSection(
                    title: 'Cartões de Crédito',
                    child: ListScopedBuilder<CreditCardStore, List<CreditCard>>(
                      store: widget.creditCardStore,
                      loadingWidget: SizedBox(
                        height: 240,
                        child: _makeShimmerList(width: 275, height: 150),
                      ),
                      onError: (ctx, f) => Text(f.message),
                      onState: (ctx, state) {
                        return SizedBox(
                          height: 240,
                          child: HorizontalAnimatedList(
                            length: state.length,
                            itemBuilderFunction: (context, index) {
                              return CreditCardWidget(
                                  creditCard: state[index],
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0));
                            },
                          ),
                        );
                      },
                      onEmptyState: () => const SizedBox(height: 300),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onMonthChange(int month, int year, List<Account> accounts) {
    _fetchData(
      month: month,
      year: year,
      accounts: accounts,
      fetchAll: widget.expenseStore.getForAll,
      fetchOne: widget.expenseStore.getAllOf,
    );

    _fetchData(
      month: month,
      year: year,
      accounts: accounts,
      fetchAll: widget.incomeStore.getForAll,
      fetchOne: widget.incomeStore.getAllOf,
    );
  }

  void _fetchData({
    required int month,
    required int year,
    required List<Account> accounts,
    required void Function({
      required int month,
      required int year,
      required List<Account> accounts,
    }) fetchAll,
    required void Function({
      required int month,
      required int year,
      required Account account,
    }) fetchOne,
  }) {
    var selectedAccount = widget.accountStore.selectedAccount;
    if (selectedAccount != null) {
      fetchOne(month: month, year: year, account: selectedAccount);
      return;
    }
    fetchAll(month: month, year: year, accounts: accounts);
  }

  Widget _makeSection({required String title, required Widget child}) {
    return HorizontallyInfinityContainer(
      color: UmbrellaPalette.gray,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: UmbrellaSizes.title,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _makeShimmerList({double width = 250, double height = 300}) {
    return HorizontalListView(
      itemCount: 4,
      itemCallback: (i) => ShimmerContainer(
        height: height,
        width: width,
      ),
    );
  }
}
