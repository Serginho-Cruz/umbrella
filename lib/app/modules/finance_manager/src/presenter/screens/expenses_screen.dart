import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/extensions.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/category.dart';
import '../../domain/models/expense_model.dart';
import '../../domain/models/finance_model.dart';
import '../../domain/usecases/orders/order_expenses.dart';
import '../../utils/currency_format.dart';
import '../controllers/account_controller.dart';
import '../controllers/expense_category_store.dart';
import '../controllers/expense_store.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/appbar/month_changer.dart';
import '../widgets/buttons/navigation_button.dart';
import '../widgets/dialogs/umbrella_dialogs.dart';
import '../widgets/filters/paiyable_filter.dart';
import '../widgets/layout/spaced.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/list_scoped_builder.dart';
import '../widgets/others/value_container.dart';
import '../widgets/selectors/account_selector.dart';
import '../widgets/shimmer/shimmer_list_tile.dart';
import '../widgets/texts/big_text.dart';
import '../widgets/texts/medium_text.dart';
import '../widgets/texts/small_disclaimer.dart';
import '../widgets/texts/small_text.dart';
import '../widgets/tiles/finance_status_tile.dart';
import '../widgets/tiles/finance_tile.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({
    super.key,
    required AccountStore accountStore,
    required ExpenseStore expenseStore,
    required ExpenseCategoryStore categoryStore,
  })  : _accountStore = accountStore,
        _expenseStore = expenseStore,
        _categoryStore = categoryStore;

  final AccountStore _accountStore;
  final ExpenseStore _expenseStore;
  final ExpenseCategoryStore _categoryStore;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Category> filteredCategories = [];
  final List<Status> filteredStatus = [];
  double minValue = 0.0;
  double maxValue = 1.0;
  bool wasFiltered = false;
  PaiyableSortOption? sortOption;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget._categoryStore.getAll();
      widget._expenseStore.when<void>(onState: (_) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListScopedBuilder<AccountStore, List<Account>>(
      store: widget._accountStore,
      loadingWidget: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: 'Despesas', showBalances: false),
          backgroundColor: Colors.white,
          body: const Column(
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
      ),
      onError: (ctx, fail) {
        UmbrellaDialogs.showError(
          context,
          fail.message,
          onRetry: () {
            widget._accountStore.getAll();
          },
          onConfirmPressed: () {
            widget._accountStore.getAll();
          },
        );

        return const SizedBox.shrink();
      },
      onEmptyState: () {
        UmbrellaDialogs.showError(
          context,
          'Um Erro inesperado aconteceu. Por favor, tente novamente',
          onRetry: () {
            widget._accountStore.getAll();
          },
          onConfirmPressed: () {
            widget._accountStore.getAll();
          },
        );

        return const SizedBox.shrink();
      },
      onState: (ctx, accounts) {
        return UmbrellaScaffold(
          appBarTitle: 'Despesas',
          showMonthChanger: true,
          onMonthChange: (_, __) {
            Future.delayed(Duration.zero, () {
              _fetchExpenses();
            });
          },
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
                  onSelected: (selected) {
                    if (selected != widget._accountStore.selectedAccount) {
                      setState(
                        () => widget._accountStore.selectedAccount = selected,
                      );
                      _fetchExpenses();
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                ScopedBuilder<ExpenseCategoryStore, List<Category>>(
                  store: widget._categoryStore,
                  onLoading: (ctx) =>
                      const CircularProgressIndicator.adaptive(),
                  onError: (ctx, fail) => _mountFilter(),
                  onState: (ctx, categories) => _mountFilter(categories),
                ),
                const SizedBox(height: 30.0),
                ListScopedBuilder<ExpenseStore, List<ExpenseModel>>(
                  store: widget._expenseStore,
                  onError: (ctx, fail) {
                    UmbrellaDialogs.showError(
                      context,
                      fail.message,
                    );
                    var month = MonthChanger.currentMonthAndYear.monthName;
                    return Center(
                      child: MediumText(
                          'Erro ao obter as Despesas do Mês de $month'),
                    );
                  },
                  loadingWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (i) => ShimmerListTile(
                        roundedOnTop: i == 0,
                        roundedOnBottom: i == 4,
                      ),
                    ),
                  ),
                  onEmptyState: () {
                    String text;
                    String monthName =
                        MonthChanger.currentMonthAndYear.monthName;
                    if (wasFiltered) {
                      text =
                          'Nenhuma Despesa com os filtros atuais para o mês de $monthName';
                    } else {
                      text =
                          'Nenhuma Despesa encontrada para o mês de $monthName';
                    }

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
                  onState: (ctx, expenses) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(
                        expenses.length,
                        (i) => FinanceTile(
                          model: expenses[i],
                          roundedOnTop: i == 0,
                        ),
                      ),
                      const FinanceStatusTile(),
                      const SmallDisclaimer(
                        'Aperte duas vezes em uma despesa para abrir o menu de opções',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                Spaced(
                  first: ValueContainer(
                    text: 'Total',
                    valueWidget:
                        ListScopedBuilder<ExpenseStore, List<ExpenseModel>>(
                      store: widget._expenseStore,
                      loadingWidget: const SmallText.bold('Carregando...'),
                      onError: (ctx, _) => const MediumText.bold('Erro'),
                      onEmptyState: () =>
                          MediumText.bold(CurrencyFormat.format(0.00)),
                      onState: (ctx, incomes) {
                        double value = 0.00;
                        for (var element in incomes) {
                          value = (value + element.totalValue).roundToDecimal();
                        }

                        return MediumText.bold(CurrencyFormat.format(value));
                      },
                    ),
                  ),
                  second: ValueContainer(
                    text: 'Pago',
                    valueWidget:
                        ListScopedBuilder<ExpenseStore, List<ExpenseModel>>(
                      store: widget._expenseStore,
                      loadingWidget: const SmallText.bold('Carregando...'),
                      onError: (ctx, _) => const MediumText.bold('Erro'),
                      onEmptyState: () =>
                          MediumText.bold(CurrencyFormat.format(0.00)),
                      onState: (ctx, incomes) {
                        double value = 0.00;
                        for (var element in incomes) {
                          value = (value + element.paidValue).roundToDecimal();
                        }

                        return MediumText.bold(CurrencyFormat.format(value));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, bottom: 30.0),
                  child: NavigationButton(
                    context: context,
                    height: 60.0,
                    width: 180.0,
                    label: const MediumText.bold('Nova Despesa'),
                    route: '/finance_manager/expense/add',
                    isPrimaryColor: true,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  ),
                ),
                Spaced(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  first: NavigationButton.toIncomes(context, height: 60.0),
                  second: NavigationButton.toCards(context, height: 60.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _fetchExpenses() {
    if (widget._accountStore.state.isEmpty) {
      Navigator.pushReplacementNamed(context, '/finance_manager/');
      return;
    }

    var current = MonthChanger.currentMonthAndYear;

    var selectedAccount = widget._accountStore.selectedAccount;

    wasFiltered = false;

    selectedAccount != null
        ? widget._expenseStore.getAllOf(
            month: current.month,
            year: current.year,
            account: selectedAccount,
          )
        : widget._expenseStore.getForAll(
            accounts: widget._accountStore.state,
            month: current.month,
            year: current.year,
          );
  }

  Widget _mountFilter([List<Category> categories = const []]) {
    var (min, max) = _getMinAndMaxValues(widget._expenseStore.all);

    if (!wasFiltered) {
      minValue = min;
      maxValue = max;
    }

    return PaiyableFilter<ExpenseModel>(
      models: widget._expenseStore.all,
      filterName: widget._expenseStore.filterByName,
      filterByCategory: (models, cats) {
        setState(() => filteredCategories
          ..clear()
          ..addAll(cats));

        return widget._expenseStore.filterByCategory(models, cats);
      },
      filterByStatus: (models, status) {
        setState(() => filteredStatus
          ..clear()
          ..addAll(status));

        return widget._expenseStore.filterByStatus(models, status);
      },
      filterByValue: (models, minimal, maximum) {
        setState(() {
          wasFiltered = true;
          minValue = minimal;
          maxValue = maximum;
        });

        return widget._expenseStore.filterByRangeValue(
          models,
          minimal,
          maximum,
        );
      },
      sort: (models, option, isCrescent) {
        setState(() => sortOption = option);
        return widget._expenseStore.sort(
          models,
          option,
          isCrescent: isCrescent,
        );
      },
      onFiltersApplied: (models) {
        widget._expenseStore.updateState(models);
      },
      filteredStatus: filteredStatus,
      filteredValues: (minValue, maxValue),
      categories: categories,
      filteredCategories: filteredCategories,
      minValue: min,
      maxValue: max,
      sortOption: sortOption,
    );
  }

  (double, double) _getMinAndMaxValues(List<ExpenseModel> models) {
    var copy = models.getRange(0, models.length).toList();
    copy.sort((a, b) => a.totalValue.compareTo(b.totalValue));

    double min, max;

    if (copy.isEmpty) {
      min = 0.00;
      max = 0.00;
    } else {
      min = copy.first.totalValue;
      max = copy.last.totalValue;
    }

    return (min, max);
  }
}
