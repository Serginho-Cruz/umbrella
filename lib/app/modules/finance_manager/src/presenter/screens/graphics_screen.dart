import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../stores/graphs_store.dart';
import '../stores/month_store.dart';
import '../utils/umbrella_palette.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/charts/column/category_column_chart.dart';
import '../widgets/charts/line/balance_evolution_chart.dart';
import '../widgets/charts/pie/status_pie_chart.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/others/segmented_graphs_state.dart';
import '../widgets/texts/big_text.dart';
import '../widgets/texts/medium_text.dart';
import '../widgets/texts/small_disclaimer.dart';

class GraphicsScreen extends StatefulWidget {
  final GraphsStore _graphsStore;
  final MonthStore _monthStore;

  const GraphicsScreen({
    super.key,
    required GraphsStore graphsStore,
    required MonthStore monthStore,
  })  : _graphsStore = graphsStore,
        _monthStore = monthStore;
  @override
  State<GraphicsScreen> createState() => _GraphicsScreenState();
}

class _GraphicsScreenState extends State<GraphicsScreen> {
  int? touchedIndex;
  Offset? touchedOffset;

  ReactionDisposer? _monthReaction;

  @override
  void initState() {
    super.initState();

    _monthReaction = reaction((_) => widget._monthStore.month, (_) {
      _fetchData();
    }, fireImmediately: true);
  }

  bool _shouldShowAppBarFunctionalities(Orientation orientation) {
    return orientation == Orientation.portrait;
  }

  @override
  void dispose() {
    _monthReaction?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showAppBarFuncs =
        _shouldShowAppBarFunctionalities(MediaQuery.orientationOf(context));

    final screenWidth = MediaQuery.sizeOf(context).width;

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: UmbrellaScaffold(
        appBar: CustomAppBar(
          showBalances: showAppBarFuncs,
          showMonthChanger: showAppBarFuncs,
          title: 'Gráficos',
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            const SizedBox(height: 25.0),
            _graphTitle('Valor em Despesas por Categoria'),
            Observer(
              builder: (_) {
                return SegmentedGraphsState(
                  observable: widget._graphsStore.valuePerExpenseCategoryState,
                  onLoading: (ctx) => const SizedBox(
                    height: 200.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MediumText.bold('Buscando dados...'),
                        CircularProgressIndicator.adaptive(
                          semanticsLabel:
                              'Carregando Dados do Gráfico de Valor gasto por Categoria de Despesa',
                        ),
                      ],
                    ),
                  ),
                  onFail: (ctx, failState) => SizedBox(
                    height: 200,
                    child: MediumText.bold(failState.fail.message),
                  ),
                  onSuccess: (_, successState) => CategoryColumnChart(
                    data: successState.data,
                    bottomAxisName: 'Categorias de Despesa',
                    colors: UmbrellaPalette.statusChartsColors,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 25.0,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40.0),
            _graphTitle('Valor em Receitas por Categoria'),
            Observer(
              builder: (_) {
                return SegmentedGraphsState(
                  observable: widget._graphsStore.valuePerIncomeCategoryState,
                  onLoading: (ctx) => const SizedBox(
                    height: 200.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MediumText.bold('Buscando dados...'),
                        CircularProgressIndicator.adaptive(
                          semanticsLabel:
                              'Carregando Dados do Gráfico de Valor recebido por Categoria de Despesa',
                        )
                      ],
                    ),
                  ),
                  onFail: (ctx, failState) => SizedBox(
                    height: 200,
                    child: MediumText.bold(failState.fail.message),
                  ),
                  onSuccess: (_, successState) => CategoryColumnChart(
                    data: successState.data,
                    bottomAxisName: 'Categorias de Receita',
                    colors: UmbrellaPalette.statusChartsColors,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 25.0,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40.0),
            _graphTitle('Valor em Despesas por Status'),
            Observer(
              builder: (_) {
                return SegmentedGraphsState(
                  observable: widget._graphsStore.valueCastPerStatusState,
                  onLoading: (ctx) => const SizedBox(
                    height: 200.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MediumText.bold('Buscando dados...'),
                        CircularProgressIndicator.adaptive(
                          semanticsLabel:
                              'Carregando Dados do Gráfico de Valor gasto por Status',
                        ),
                      ],
                    ),
                  ),
                  onFail: (ctx, failState) => SizedBox(
                    height: 200,
                    child: MediumText.bold(failState.fail.message),
                  ),
                  onSuccess: (ctx, state) => StatusPieChart(
                    data: state.data,
                    graphSize: 400,
                  ),
                );
              },
            ),
            const SizedBox(height: 40.0),
            _graphTitle('Valor em Receitas por Status'),
            Observer(
              builder: (_) {
                return SegmentedGraphsState(
                  observable: widget._graphsStore.valueReceivedPerStatusState,
                  onLoading: (ctx) => const SizedBox(
                    height: 200.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MediumText.bold('Buscando dados...'),
                        CircularProgressIndicator.adaptive(
                          semanticsLabel:
                              'Carregando Dados do Gráfico de Valor recebido por Status',
                        ),
                      ],
                    ),
                  ),
                  onFail: (ctx, failState) => SizedBox(
                    height: 200,
                    child: MediumText.bold(failState.fail.message),
                  ),
                  onSuccess: (ctx, state) => StatusPieChart(
                    data: state.data,
                    graphSize: 400,
                  ),
                );
              },
            ),
            const SizedBox(height: 40.0),
            _graphTitle('Evolução do Saldo nesse Mês'),
            const SizedBox(height: 20),
            LimitedBox(
              maxWidth: screenWidth - 60,
              child: const SmallDisclaimer(
                'Vire a Tela para o Modo Paisagem para uma melhor visualização',
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 10),
            Observer(
              builder: (_) => SegmentedGraphsState(
                observable: widget._graphsStore.balanceEvolutionState,
                onFail: (ctx, failState) => SizedBox(
                  height: 200,
                  child: MediumText.bold(failState.fail.message),
                ),
                onLoading: (ctx) => const SizedBox(
                  height: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MediumText.bold('Buscando dados...'),
                      CircularProgressIndicator.adaptive(
                        semanticsLabel:
                            'Carregando Dados do Gráfico de Evolução do Saldo no mês',
                      ),
                    ],
                  ),
                ),
                onSuccess: (ctx, success) => BalanceEvolutionChart(
                  data: success.data,
                  height: 300,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    widget._graphsStore.fetchExpenseCategoryGraphData();
    widget._graphsStore.fetchIncomeCategoryGraphData();
    widget._graphsStore.fetchExpenseStatusGraphData();
    widget._graphsStore.fetchIncomeStatusGraphData();
    widget._graphsStore.fetchBalanceEvolutionGraphData();
  }

  Widget _graphTitle(String title) {
    return BigText.bold(
      title,
      textAlign: TextAlign.center,
      maxLines: 2,
      softWrap: true,
    );
  }
}
