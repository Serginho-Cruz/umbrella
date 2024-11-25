import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/controllers/balance_store.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../controllers/expense_store.dart';
import '../../controllers/month_store.dart';
import '../../utils/currency_format.dart';
import '../../widgets/filters/finance_filter.dart';
import '../../widgets/others/list_segmented_state_widget.dart';
import '../../widgets/others/segmented_state_widget.dart';
import '../../widgets/tappable/expense_tappable_options.dart';
import '../../controllers/account_store.dart';
import '../../controllers/expense_category_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/navigation_icon_button.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/others/list_scoped_builder.dart';
import '../../widgets/selectors/account_selector.dart';
import '../../widgets/shimmer/shimmer_list_tile.dart';
import '../../widgets/tappable/tappable.dart';
import '../../widgets/texts/big_text.dart';
import '../../widgets/texts/medium_text.dart';
import '../../widgets/texts/small_disclaimer.dart';
import '../../widgets/texts/small_text.dart';
import '../../widgets/tiles/finance_tile.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({
    super.key,
    required AccountStore accountStore,
    required BalanceStore balanceStore,
    required ExpenseStore expenseStore,
    required ExpenseCategoryStore categoryStore,
  })  : _accountStore = accountStore,
        _balanceStore = balanceStore,
        _expenseStore = expenseStore,
        _categoryStore = categoryStore;

  final AccountStore _accountStore;
  final BalanceStore _balanceStore;
  final ExpenseStore _expenseStore;
  final ExpenseCategoryStore _categoryStore;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    super.initState();

    widget._accountStore.addSelectedAccountListener(_onAccountChanged);
  }

  @override
  void dispose() {
    widget._accountStore.removeSelectedAccountListener(_onAccountChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListScopedBuilder<AccountStore, List<Account>>(
      store: widget._accountStore,
      loadingWidget: UmbrellaScaffold(
        appBar: CustomAppBar(title: 'Despesas', showBalances: false),
        floatingActionButton: const NavigationIconButton(
          route: '/finance_manager/expense/add',
          tooltipMessage: 'Ir para a Tela de Adicionar Despesas',
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator.adaptive(),
            ),
            BigText.bold('Carregando Contas...')
          ],
        ),
      ),
      onError: (ctx, fail) {
        UmbrellaDialogs.showError(
          context,
          fail.message,
          onRetry: widget._accountStore.getAll,
          onConfirmPressed: widget._accountStore.getAll,
        );

        return const SizedBox.shrink();
      },
      onEmptyState: () {
        UmbrellaDialogs.showError(
          context,
          'Um Erro inesperado aconteceu. Por favor, tente novamente',
          onRetry: widget._accountStore.getAll,
          onConfirmPressed: widget._accountStore.getAll,
        );

        return const SizedBox.shrink();
      },
      onState: (ctx, accounts) {
        return UmbrellaScaffold(
          appBar: CustomAppBar(
            title: 'Despesas',
            showMonthChanger: true,
            onMonthChange: (_, __) {},
          ),
          floatingActionButton: NavigationIconButton(
            route: '/finance_manager/expense/add',
            tooltipMessage: 'Ir para a Tela de Adicionar Despesas',
            onPop: () {
              widget._balanceStore.getForAll(
                accounts: accounts,
              );
              _fetchExpenses();
            },
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.05,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20.0),
                  AccountSelector(
                    accounts: accounts,
                    selectedAccount: widget._accountStore.selectedAccount,
                    onSelected: widget._accountStore.changeSelectedAccount,
                  ),
                  const SizedBox(height: 20.0),
                  Observer(
                    builder: (_) => _mountTotalText(
                      text: 'Total em Despesas: ',
                      value: widget._expenseStore.totalToPay,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Observer(
                    builder: (_) => _mountTotalText(
                      text: 'Total Pago: ',
                      value: widget._expenseStore.totalPaid,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Observer(
                    builder: (_) {
                      return ListSegmentedStateWidget<Category>(
                        state: widget._categoryStore.state,
                        onLoading: (ctx) =>
                            const CircularProgressIndicator.adaptive(),
                        onFail: (ctx, fail) => _mountFilter(),
                        onState: (ctx, categories) => _mountFilter(categories),
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                  ListSegmentedStateWidget(
                    state: widget._expenseStore.state,
                    onLoading: (ctx) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (i) => ShimmerListTile(
                          roundedOnTop: i == 0,
                          roundedOnBottom: i == 4,
                        ),
                      ),
                    ),
                    onFail: (ctx, fail) {
                      UmbrellaDialogs.showError(
                        context,
                        fail.message,
                      );
                      var (:month, :year) =
                          BindServiceProvider.get<MonthStore>().month;

                      String name =
                          Date(day: 1, month: month, year: year).monthName;
                      return Center(
                        child: MediumText(
                            'Erro ao obter as Despesas do Mês de $name'),
                      );
                    },
                    onEmpty: (_) {
                      String text;
                      var (:month, :year) =
                          BindServiceProvider.get<MonthStore>().month;

                      String name =
                          Date(day: 1, month: month, year: year).monthName;

                      text = 'Nenhuma Despesa encontrada para o mês de $name';

                      return SizedBox(
                        height: 200.0,
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.money_off_rounded, size: 60.0),
                            const SizedBox(height: 20.0),
                            MediumText.bold(text, textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    },
                    onState: (ctx, expenses) => Observer(builder: (_) {
                      var filtered = widget._expenseStore.filteredExpenses;

                      if (filtered.isEmpty) {
                        String text;
                        var (:month, :year) =
                            BindServiceProvider.get<MonthStore>().month;

                        String name =
                            Date(day: 1, month: month, year: year).monthName;

                        text =
                            'Nenhuma Receita encontrada para o mês de $name com os filtros escolhidos';

                        return SizedBox(
                          height: 200.0,
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.money_off_rounded, size: 60.0),
                              const SizedBox(height: 20.0),
                              MediumText.bold(
                                text,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SmallDisclaimer(
                            'Aperte duas vezes em uma receita para abrir o menu de opções',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          ...List.generate(
                            filtered.length,
                            (i) => Tappable(
                              options: ExpenseTappableOptions.get(
                                context: context,
                                model: filtered[i],
                                store: widget._expenseStore,
                                accountStore: widget._accountStore,
                                onPop: () {
                                  widget._balanceStore.getForAll(
                                    accounts: accounts,
                                  );
                                  _fetchExpenses();
                                },
                              ),
                              openMenuDispatcher: TappableDispatcher.doubleTap,
                              child: FinanceTile(
                                model: filtered[i],
                                roundedOnTop: i == 0,
                                roundedOnBottom: i == filtered.length - 1,
                              ),
                            ),
                          ),
                        ],
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

  void _onAccountChanged(Account? account) {
    setState(() {});
    _fetchExpenses();
  }

  void _fetchExpenses() {
    if (widget._accountStore.state.isEmpty) {
      Navigator.pushReplacementNamed(context, '/finance_manager/');
      return;
    }

    widget._expenseStore.getAll();
  }

  Widget _mountTotalText({
    required String text,
    required double value,
  }) {
    return Row(
      children: [
        MediumText(text),
        const SizedBox(width: 10.0),
        ListSegmentedStateWidget(
          state: widget._expenseStore.state,
          onLoading: (_) => const SmallText.bold('Carregando...'),
          onFail: (ctx, _) => const MediumText.bold('Erro'),
          onState: (ctx, __) => MediumText.bold(CurrencyFormat.format(value)),
        ),
      ],
    );
  }

  Widget _mountFilter([List<Category> categories = const []]) {
    return SegmentedStateWidget(
      state: widget._expenseStore.state,
      onLoading: (ctx) => const CircularProgressIndicator(),
      onFail: (ctx, fail) => SizedBox(
        height: 40.0,
        width: MediaQuery.sizeOf(ctx).width * 0.8,
        child: MediumText(
          fail.message,
          textAlign: TextAlign.center,
        ),
      ),
      onState: (ctx, _) => FinanceFilter(
        filterableStore: widget._expenseStore,
        categories: categories,
      ),
    );
  }
}
