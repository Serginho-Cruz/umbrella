import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_segmented_state_widget.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/tiles/finance_tile.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/date.dart';
import '../../controllers/balance_store.dart';
import '../../controllers/month_store.dart';
import '../../controllers/income_store.dart';
import '../../utils/currency_format.dart';
import '../../controllers/account_store.dart';
import '../../controllers/income_category_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/navigation_icon_button.dart';
import '../../widgets/filters/finance_filter.dart';
import '../../widgets/others/segmented_state_widget.dart';
import '../../widgets/selectors/account_selector.dart';
import '../../widgets/shimmer/shimmer_list_tile.dart';
import '../../widgets/tappable/income_tappable_options.dart';
import '../../widgets/tappable/tappable.dart';
import '../../widgets/texts/big_text.dart';
import '../../widgets/texts/small_disclaimer.dart';
import '../../widgets/texts/small_text.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/others/list_scoped_builder.dart';
import '../../widgets/texts/medium_text.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';

class IncomesScreen extends StatefulWidget {
  const IncomesScreen({
    super.key,
    required IncomeStore incomeStore,
    required AccountStore accountStore,
    required IncomeCategoryStore categoryStore,
    required BalanceStore balanceStore,
  })  : _incomeStore = incomeStore,
        _categoryStore = categoryStore,
        _accountStore = accountStore,
        _balanceStore = balanceStore;

  final IncomeStore _incomeStore;
  final IncomeCategoryStore _categoryStore;
  final AccountStore _accountStore;
  final BalanceStore _balanceStore;

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
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
        appBar: CustomAppBar(title: 'Receitas', showBalances: false),
        floatingActionButton: const NavigationIconButton(
          route: '/finance_manager/income/add',
          tooltipMessage: 'Ir para a Tela de Adicionar Receitas',
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
            title: 'Receitas',
            showMonthChanger: true,
            onMonthChange: (_, __) {},
          ),
          floatingActionButton: NavigationIconButton(
            route: '/finance_manager/income/add',
            tooltipMessage: 'Ir para a Tela de Adicionar Receitas',
            onPop: () {
              widget._balanceStore.getForAll(
                accounts: accounts,
              );
              _fetchIncomes();
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
                      text: 'Total em Receitas: ',
                      value: widget._incomeStore.totalToReceive,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Observer(
                    builder: (_) => _mountTotalText(
                      text: 'Total Recebido: ',
                      value: widget._incomeStore.totalReceived,
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
                    state: widget._incomeStore.state,
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
                            'Erro ao obter as Receitas do Mês de $name'),
                      );
                    },
                    onEmpty: (_) {
                      String text;
                      var (:month, :year) =
                          BindServiceProvider.get<MonthStore>().month;

                      String name =
                          Date(day: 1, month: month, year: year).monthName;

                      text = 'Nenhuma Receita encontrada para o mês de $name';

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
                    onState: (ctx, incomes) => Observer(builder: (_) {
                      var filtered = widget._incomeStore.filteredIncomes;

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
                          ...List.generate(
                            filtered.length,
                            (i) => Tappable(
                              options: IncomeTappableOptions.get(
                                context: context,
                                model: filtered[i],
                                store: widget._incomeStore,
                                accountStore: widget._accountStore,
                                onPop: () {
                                  widget._balanceStore.getForAll(
                                    accounts: accounts,
                                  );
                                  _fetchIncomes();
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
                          const SmallDisclaimer(
                            'Aperte duas vezes em uma receita para abrir o menu de opções',
                            textAlign: TextAlign.center,
                            maxLines: 2,
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

  void _onAccountChanged(Account? newSelected) {
    setState(() {});
    _fetchIncomes();
  }

  void _fetchIncomes() {
    if (widget._accountStore.state.isEmpty) {
      Navigator.pushReplacementNamed(context, '/finance_manager/');
      return;
    }

    widget._incomeStore.getAll();
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
          state: widget._incomeStore.state,
          onLoading: (_) => const SmallText.bold('Carregando...'),
          onFail: (ctx, _) => const MediumText.bold('Erro'),
          onState: (ctx, __) => MediumText.bold(CurrencyFormat.format(value)),
        ),
      ],
    );
  }

  Widget _mountFilter([List<Category> categories = const []]) {
    return SegmentedStateWidget(
      state: widget._incomeStore.state,
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
        filterableStore: widget._incomeStore,
        categories: categories,
      ),
    );
  }
}
