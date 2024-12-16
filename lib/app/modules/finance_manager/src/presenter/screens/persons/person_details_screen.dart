import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/person_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/animations/loading_animation.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/horizontal_animated_list.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/umbrella_scaffold.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_segmented_state_widget.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/no_data_found.dart';

import '../../../domain/entities/date.dart';
import '../../../domain/states/state.dart' as s;
import '../../utils/currency_format.dart';
import '../../utils/umbrella_palette.dart';
import '../../utils/umbrella_sizes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/expense_card.dart';
import '../../widgets/cards/income_card.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/layout/horizontal_infinity_container.dart';
import '../../widgets/texts/big_text.dart';
import '../../widgets/texts/medium_text.dart';

class PersonDetailsScreen extends StatefulWidget {
  const PersonDetailsScreen({
    super.key,
    required PersonStore store,
    required String personName,
  })  : _store = store,
        _personName = personName;

  final PersonStore _store;
  final String _personName;

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  double valueInDebt = 0.00;

  @override
  void initState() {
    super.initState();
    widget._store.getDataFor(widget._personName);

    var valuesState =
        widget._store.personsDebts as s.SuccessState<Map<String, double>>;

    valueInDebt = valuesState.state[widget._personName]!;
  }

  @override
  Widget build(BuildContext context) {
    var status = _resolveDebtStatus(valueInDebt);

    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Detalhes de Pessoa',
        showMonthChanger: false,
        monthAndYear: Date.today(),
      ),
      child: RefreshIndicator(
        onRefresh: () => widget._store.getDataFor(widget._personName),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _sliverText(
              'Nome da Pessoa: ${widget._personName}',
              bold: true,
            ),
            _sliverRichText('Status da Dívida: ', status),
            _sliverRichText(
              'Valor: ',
              CurrencyFormat.format(valueInDebt.abs()),
            ),
            SliverToBoxAdapter(
              child: _sectionLayout(
                'Débitos (Pessoa deve a você)',
                Observer(
                  builder: (_) => _sectionChild(
                    state: widget._store.debts,
                    loadingMessage: 'Carregando Débitos...',
                    emptyMessage: '${widget._personName} não deve nada a você',
                    errorMessage:
                        'Houve um erro ao obter os débitos de ${widget._personName}',
                    buildState: (ctx, state) {
                      return HorizontalAnimatedList(
                        height: 240,
                        length: state.length,
                        itemBuilderFunction: (context, index) =>
                            UnconstrainedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: IncomeCard(model: state[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _sectionLayout(
                'Créditos (Você deve a pessoa)',
                Observer(
                  builder: (_) => _sectionChild(
                    state: widget._store.credits,
                    loadingMessage: 'Carregando Créditos...',
                    emptyMessage: 'Você não deve nada a ${widget._personName}',
                    errorMessage:
                        'Houve um erro ao obter os créditos de ${widget._personName}',
                    buildState: (ctx, state) {
                      return HorizontalAnimatedList(
                        height: 240,
                        length: state.length,
                        itemBuilderFunction: (context, index) =>
                            UnconstrainedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: ExpenseCard(model: state[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveDebtStatus(double value) => switch (value) {
        _ when value > 0.00 => 'Receptor',
        _ when value < 0.00 => 'Devedor',
        _ => 'Quitado',
      };

  Widget _sliverText(
    String text, {
    double fontSize = UmbrellaSizes.medium,
    bool bold = false,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
      sliver: SliverToBoxAdapter(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _sliverRichText(
    String text,
    String highlight, {
    double fontSize = UmbrellaSizes.medium,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Text.rich(
          TextSpan(
            style: TextStyle(fontSize: fontSize),
            children: [
              TextSpan(text: text),
              TextSpan(
                text: highlight,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLayout(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: HorizontallyInfinityContainer(
        color: UmbrellaPalette.gray,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 12.0),
              child: BigText.bold(title),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _sectionChild<S extends Object>({
    required s.State<List<S>> state,
    required Widget Function(BuildContext, List<S>) buildState,
    required String loadingMessage,
    required String emptyMessage,
    required String errorMessage,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return ListSegmentedStateWidget(
      state: state,
      onLoading: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: LoadingAnimation(
            width: screenWidth - 80,
            height: 220,
            message: loadingMessage,
          ),
        ),
      ),
      onEmpty: (_) => Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(
          child: NoDataFound(
            width: screenWidth * 0.5,
            message: '$emptyMessage, Maravilha!',
            tooltipMessage: '$emptyMessage.',
          ),
        ),
      ),
      onFail: (ctx, fail) {
        UmbrellaDialogs.showError(
          context,
          fail.message,
          onRetry: () => widget._store.getDataFor(widget._personName),
          onConfirmPressed: () => widget._store.getDataFor(widget._personName),
        );

        return Center(
          child: Column(
            children: [
              MediumText(errorMessage),
              const SizedBox(height: 30),
              PrimaryButton(
                label: const MediumText.bold('Tentar novamente'),
                onPressed: () => widget._store.getDataFor(
                  widget._personName,
                ),
              ),
            ],
          ),
        );
      },
      onState: buildState,
    );
  }
}
