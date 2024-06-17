import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/paiyable_filter_dialog.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/tiles/finance_tile.dart';
import '../../domain/entities/category.dart';
import '../../domain/models/finance_model.dart';
import '../../domain/models/income_model.dart';
import '../controllers/account_controller.dart';
import '../controllers/income_category_store.dart';
import '../controllers/income_store.dart';
import '../widgets/appbar/month_changer.dart';
import '../widgets/paiyable_filter.dart';
import '../widgets/tiles/finance_status_tile.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/list_scoped_builder.dart';
import '../widgets/texts/medium_text.dart';
import '../widgets/dialogs/umbrella_dialogs.dart';

class IncomesScreen extends StatefulWidget {
  const IncomesScreen({
    super.key,
    required this.incomeStore,
    required this.accountStore,
    required this.categoryStore,
  });

  final IncomeStore incomeStore;
  final IncomeCategoryStore categoryStore;
  final AccountStore accountStore;

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  final List<Category> filteredCategories = [];
  final List<Status> filteredStatus = [];
  double minValue = 0.0;
  double maxValue = 1.0;
  bool wasFiltered = false;
  PaiyableSortOption? sortOption;

  @override
  void initState() {
    super.initState();
    widget.categoryStore.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBarTitle: 'Receitas',
      showMonthChanger: true,
      onMonthChange: _onMonthChange,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          ListScopedBuilder<IncomeStore, List<IncomeModel>>(
            store: widget.incomeStore,
            onError: (ctx, fail) {
              UmbrellaDialogs.showError(
                context,
                fail.message,
              );
              var month = MonthChanger.currentMonthAndYear.monthName;
              return Center(
                child: MediumText('Erro ao obter as Receitas do Mês de $month'),
              );
            },
            loadingWidget: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            onEmptyState: () => const Center(
              child: Text('Não há Receitas para este mês'),
            ),
            onState: (ctx, incomes) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.05,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListScopedBuilder<IncomeCategoryStore, List<Category>>(
                    store: widget.categoryStore,
                    loadingWidget: const CircularProgressIndicator.adaptive(),
                    onError: (ctx, fail) =>
                        const CircularProgressIndicator.adaptive(),
                    onEmptyState: () =>
                        const CircularProgressIndicator.adaptive(),
                    onState: (ctx, categories) {
                      var (min, max) =
                          _getMinAndMaxValues(widget.incomeStore.all);

                      if (!wasFiltered) {
                        minValue = min;
                        maxValue = max;
                      }

                      return PaiyableFilter<IncomeModel>(
                        models: widget.incomeStore.all,
                        filterName: widget.incomeStore.filterByName,
                        filterByCategory: (models, cats) {
                          filteredCategories
                            ..clear()
                            ..addAll(cats);

                          return widget.incomeStore
                              .filterByCategory(models, cats);
                        },
                        filterByStatus: (models, status) {
                          filteredStatus
                            ..clear()
                            ..addAll(status);

                          return widget.incomeStore
                              .filterByStatus(models, status);
                        },
                        filterByValue: (models, minimal, maximum) {
                          wasFiltered = true;
                          minValue = minimal;
                          maxValue = maximum;

                          return widget.incomeStore.filterByRangeValue(
                            models,
                            minimal,
                            maximum,
                          );
                        },
                        sort: (models, option) {
                          sortOption = option;
                          return widget.incomeStore.sort(models, option);
                        },
                        onFiltersApplied: (models) {
                          widget.incomeStore.updateState(models);
                        },
                        filteredStatus: filteredStatus,
                        filteredValues: (minValue, maxValue),
                        categories: categories,
                        filteredCategories: filteredCategories,
                        minValue: min,
                        maxValue: max,
                        sortOption: sortOption,
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                  ...List.generate(
                    incomes.length,
                    (i) => FinanceTile(
                      model: incomes[i],
                      roundedOnTop: i == 0,
                    ),
                  ),
                  const FinanceStatusTile(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (double, double) _getMinAndMaxValues(List<IncomeModel> models) {
    var copy = models.getRange(0, models.length).toList();
    copy.sort((a, b) => a.totalValue.compareTo(b.totalValue));

    double min = copy.first.totalValue + 23.41;
    double max = copy.last.totalValue - 54.21;

    return (min, max);
  }

  void _onMonthChange(int month, int year) {
    if (!mounted) setState(() {});
  }
}
