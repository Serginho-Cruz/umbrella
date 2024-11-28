import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../stores/expense_store.dart';
import '../../stores/month_store.dart';
import '../../utils/currency_format.dart';
import '../../widgets/filters/finance_filter.dart';
import '../../widgets/others/list_segmented_state_widget.dart';
import '../../widgets/others/segmented_state_widget.dart';
import '../../widgets/tappable/expense_tappable_options.dart';
import '../../stores/account_store.dart';
import '../../stores/expense_category_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/navigation_icon_button.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
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
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return ListSegmentedStateWidget(
        state: widget._accountStore.state,
        onLoading: (_) => UmbrellaScaffold(
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
        onState: (ctx, accounts) {
          return UmbrellaScaffold(
            appBar: CustomAppBar(
              title: 'Despesas',
              showMonthChanger: true,
            ),
            floatingActionButton: const NavigationIconButton(
              route: '/finance_manager/expense/add',
              tooltipMessage: 'Ir para a Tela de Adicionar Despesas',
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
                    Observer(builder: (_) {
                      return AccountSelector(
                        accounts: accounts,
                        selectedAccount: widget._accountStore.selectedAccount,
                        onSelected: widget._accountStore.changeSelectedAccount,
                      );
                    }),
                    const SizedBox(height: 20.0),
                    Observer(
                      builder: (_) => mountTotalText(
                        text: 'Total em Despesas: ',
                        value: widget._expenseStore.totalToPay,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Observer(
                      builder: (_) => mountTotalText(
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
                          onFail: (ctx, fail) => mountFilter(),
                          onState: (ctx, categories) => mountFilter(categories),
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
                              MediumText.bold(text,
                                  textAlign: TextAlign.center),
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
                                ),
                                openMenuDispatcher:
                                    TappableDispatcher.doubleTap,
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
    });
  }

  Widget mountTotalText({
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

  Widget mountFilter([List<Category> categories = const []]) {
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
