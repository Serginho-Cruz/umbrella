import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../controllers/graphs_store.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/charts/column/category_column_chart.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/others/segmented_graphs_state.dart';
import '../widgets/texts/big_text.dart';
import '../widgets/texts/medium_text.dart';

class GraphicsScreen extends StatefulWidget {
  final GraphsStore _graphsStore;

  const GraphicsScreen({
    super.key,
    required GraphsStore graphsStore,
  }) : _graphsStore = graphsStore;

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

  @override
  void initState() {
    super.initState();
    widget._graphsStore.fetchExpenseCategoryGraphData([]);
    widget._graphsStore.fetchIncomeCategoryGraphData([]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return RefreshIndicator(
      onRefresh: () async {
        widget._graphsStore.fetchExpenseCategoryGraphData([]);
        widget._graphsStore.fetchIncomeCategoryGraphData([]);
      },
      child: UmbrellaScaffold(
        appBar: const CustomAppBar(
          showBalances: false,
          showMonthChanger: false,
          title: 'Gráficos',
        ),
        child: ListView(
          children: [
            const SizedBox(height: 25.0),
            _graphTitle('Valor em Receitas por Categoria'),
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
          ],
        ),
      ),
    );
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
