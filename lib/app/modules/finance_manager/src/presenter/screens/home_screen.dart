import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/my_drawer.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/list_scoped_builder.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/models/income_model.dart';
import '../../utils/umbrella_palette.dart';
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
import '../widgets/texts/big_text.dart';
import '../widgets/texts/title_text.dart';

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
  Account? selectedAccount;

  @override
  void initState() {
    super.initState();

    selectedAccount = widget.accountStore.selectedAccount;
    Future.delayed(Duration.zero, () {
      widget.creditCardStore.getAll();
      widget.accountStore.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListScopedBuilder<AccountStore, List<Account>>(
        store: widget.accountStore,
        loadingWidget: Scaffold(
          appBar: CustomAppBar(title: 'Home', showBalances: false),
          body: Center(
            child: SizedBox.fromSize(
              size: MediaQuery.sizeOf(context),
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
              onMonthChange: (month, year) {
                _fetch(month, year, accounts);
              },
            ),
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: AccountSelector(
                      label: 'Conta Atual',
                      accounts: accounts,
                      selectedAccount: selectedAccount,
                      onSelected: (selected) {
                        setState(() => selectedAccount = selected);

                        var current = MonthChanger.currentMonthAndYear;

                        _fetch(current.month, current.year, accounts);
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
                                    horizontal: 20.0),
                              );
                            },
                          ),
                        );
                      },
                      onEmptyState: () => const SizedBox(height: 300),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _fetch(int month, int year, List<Account> accounts) {
    if (selectedAccount != null) {
      Future(() {
        widget.expenseStore.getAllOf(
          account: selectedAccount!,
          month: month,
          year: year,
        );

        widget.incomeStore.getAllOf(
          account: selectedAccount!,
          month: month,
          year: year,
        );
      });
    } else {
      Future(() {
        widget.expenseStore.getForAll(
          accounts: accounts,
          month: month,
          year: year,
        );

        widget.incomeStore.getForAll(
          accounts: accounts,
          month: month,
          year: year,
        );
      });
    }
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

  Widget _makeShimmerList({double width = 250, double height = 300}) {
    return HorizontalListView(
      itemCount: 4,
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      itemCallback: (i) => ShimmerContainer(
        height: height,
        width: width,
      ),
    );
  }
}
