import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../controllers/account_store.dart';
import '../controllers/balance_store.dart';
import '../controllers/graphs_store.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/charts/column/category_column_chart.dart';
import '../widgets/charts/pie/status_pie_chart.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/others/segmented_graphs_state.dart';
import '../widgets/texts/big_text.dart';
import '../widgets/texts/medium_text.dart';

class GraphicsScreen extends StatefulWidget {
  final GraphsStore _graphsStore;
  final BalanceStore _balanceStore;
  final AccountStore _accountStore;

  const GraphicsScreen({
    super.key,
    required GraphsStore graphsStore,
    required BalanceStore balanceStore,
    required AccountStore accountStore,
  })  : _graphsStore = graphsStore,
        _balanceStore = balanceStore,
        _accountStore = accountStore;

  @override
  State<GraphicsScreen> createState() => _GraphicsScreenState();
}

class _GraphicsScreenState extends State<GraphicsScreen> {
  final List<Color> _colors = const [
    Colors.indigo,
    Colors.pink,
    Colors.green,
    Colors.lightBlue,
    Colors.orange,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.cyan,
    Colors.yellow,
    Colors.brown,
    Colors.deepPurple,
    Colors.lime,
    Colors.teal,
  ];

  int? touchedIndex;
  Offset? touchedOffset;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  bool _shouldShowAppBarFunctionalities(Orientation orientation) {
    return orientation == Orientation.portrait;
  }

  @override
  Widget build(BuildContext context) {
    final showAppBarFuncs =
        _shouldShowAppBarFunctionalities(MediaQuery.orientationOf(context));

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: UmbrellaScaffold(
        appBar: CustomAppBar(
          accountStore: widget._accountStore,
          balanceStore: widget._balanceStore,
          showBalances: showAppBarFuncs,
          showMonthChanger: showAppBarFuncs,
          onMonthChange: (_, __) {},
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
                    colors: _colors,
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
                    colors: _colors,
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
            // _graphTitle('Evolução do Saldo nesse Mês'),
            // const SizedBox(height: 20),
            // LimitedBox(
            //   maxWidth: screenWidth - 60,
            //   child: const SmallDisclaimer(
            //     'Vire a Tela para o Modo Paisagem para uma melhor visualização',
            //     fontWeight: FontWeight.bold,
            //     textAlign: TextAlign.center,
            //     maxLines: 2,
            //   ),
            // ),
            // const SizedBox(height: 10),
            //   SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     padding: const EdgeInsets.symmetric(horizontal: 10),
            //     physics: const BouncingScrollPhysics(),
            //     child: SizedBox(
            //       height: 300,
            //       width: screenWidth - 20,
            //       child: LineChart(
            //         LineChartData(
            //           minX: 0,
            //           maxX: 32,
            //           lineTouchData: LineTouchData(
            //             touchTooltipData: LineTouchTooltipData(
            //               fitInsideHorizontally: true,
            //               fitInsideVertically: true,
            //               tooltipPadding: const EdgeInsets.all(8),
            //               tooltipRoundedRadius: 2,
            //               tooltipMargin: 20,
            //               getTooltipColor: (_) => UmbrellaPalette.primaryColor,
            //               tooltipBorder: const BorderSide(),
            //               getTooltipItems: (spots) => spots
            //                   .map(
            //                     (spot) => LineTooltipItem(
            //                       'Dia ${spot.x.toInt()}: ${CurrencyFormat.format(spot.y)}',
            //                       const TextStyle(
            //                         color: Colors.black,
            //                         fontSize: UmbrellaSizes.small,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                     ),
            //                   )
            //                   .toList(),
            //             ),
            //           ),
            //           titlesData: TitlesData(
            //             leftConfig: AxisConfig(
            //               reservedColumnSize: 60,
            //               axisTitleBuilder: (value, _) {
            //                 return SmallText(CurrencyFormat.format(value));
            //               },
            //             ),
            //             bottomConfig: AxisConfig(
            //               axisNameSize: 40,
            //               axisName: 'Dias',
            //               reservedColumnSize: 20,
            //               axisTitleBuilder: (value, _) {
            //                 return SmallText(value.toInt().toString());
            //               },
            //             ),
            //           ),
            //           lineBarsData: [
            //             LineChartBarData(
            //               barWidth: 2,
            //               isCurved: true,
            //               dotData: FlDotData(
            //                 checkToShowDot: (spot, barData) {
            //                   final isFirst = barData.spots.first.x == spot.x;
            //                   final isLast = barData.spots.last.x == spot.x;

            //                   return isFirst || isLast || spot.x % 2 == 0;
            //                 },
            //               ),
            //               color: Colors.lightGreen,
            //               preventCurveOverShooting: true,
            //               spots: [
            //                 const FlSpot(1, 0),
            //                 const FlSpot(2, 3.5),
            //                 const FlSpot(3, 3.5),
            //                 const FlSpot(4, 6.4),
            //                 const FlSpot(5, 10.12),
            //                 const FlSpot(6, 20),
            //                 const FlSpot(7, 5),
            //                 const FlSpot(8, -4.09),
            //                 const FlSpot(9, -5.67),
            //                 const FlSpot(10, 3),
            //                 const FlSpot(11, 7),
            //                 const FlSpot(12, 6.45),
            //                 const FlSpot(13, 24.50),
            //                 const FlSpot(14, 50.99),
            //                 const FlSpot(15, 26.71),
            //                 const FlSpot(16, 0),
            //                 const FlSpot(17, 2.5),
            //                 const FlSpot(18, -4.4),
            //                 const FlSpot(19, 3.90),
            //                 const FlSpot(20, 0.5),
            //                 const FlSpot(21, 3.20),
            //                 const FlSpot(22, 9.21),
            //                 const FlSpot(23, 6.65),
            //                 const FlSpot(24, 24.25),
            //                 const FlSpot(25, 50.05),
            //                 const FlSpot(26, 26.1),
            //                 const FlSpot(27, 0.4),
            //                 const FlSpot(28, 2.75),
            //                 const FlSpot(29, -4),
            //                 const FlSpot(30, 3.99),
            //                 const FlSpot(31, 0),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    final accounts = widget._accountStore.state;

    widget._graphsStore.fetchExpenseCategoryGraphData(accounts);
    widget._graphsStore.fetchIncomeCategoryGraphData(accounts);
    widget._graphsStore.fetchExpenseStatusGraphData(accounts);
    widget._graphsStore.fetchIncomeStatusGraphData(accounts);
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
