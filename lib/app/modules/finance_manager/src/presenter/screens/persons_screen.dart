import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/resolve_value_color.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_segmented_state_widget.dart';

import '../stores/account_store.dart';
import '../stores/person_store.dart';
import '../utils/umbrella_palette.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/others/person_letter_widget.dart';
import '../widgets/dialogs/umbrella_dialogs.dart';
import '../widgets/layout/spaced.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/others/segmented_state_widget.dart';
import '../widgets/selectors/account_selector.dart';
import '../widgets/texts/big_text.dart';
import '../widgets/texts/medium_text.dart';
import '../widgets/texts/price.dart';
import '../widgets/texts/small_text.dart';

class PersonsScreen extends StatefulWidget {
  final AccountStore _accountStore;
  final PersonStore _personStore;

  const PersonsScreen({
    super.key,
    required AccountStore accountStore,
    required PersonStore personStore,
  })  : _accountStore = accountStore,
        _personStore = personStore;

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  @override
  void initState() {
    super.initState();
    widget._personStore.activate();
  }

  @override
  void dispose() {
    super.dispose();
    widget._personStore.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => ListSegmentedStateWidget(
        state: widget._accountStore.state,
        onLoading: (_) => UmbrellaScaffold(
          appBar: CustomAppBar(title: 'Pessoas', showBalances: false),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: MediaQuery.sizeOf(context).width - 100.0,
                  child: const CircularProgressIndicator(),
                ),
                const SizedBox(height: 20.0),
                const BigText.bold('Carregando Contas...')
              ],
            ),
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
        onInitial: (_) => UmbrellaScaffold(
          appBar: CustomAppBar(
            title: 'Pessoas',
            showMonthChanger: true,
          ),
          child: const SizedBox(),
        ),
        onState: (ctx, accounts) {
          return UmbrellaScaffold(
            appBar: CustomAppBar(
              title: 'Pessoas',
              showMonthChanger: true,
            ),
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                widget._accountStore.get(force: true);
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
                      child: Observer(
                        builder: (_) => AccountSelector(
                          label: 'Conta Atual',
                          accounts: accounts,
                          selectedAccount: widget._accountStore.selectedAccount,
                          onSelected: (acc) {
                            widget._accountStore.changeSelectedAccount(acc);
                          },
                        ),
                      ),
                    ),
                    Observer(
                      builder: (_) => SegmentedStateWidget(
                        state: widget._personStore.personsDebts,
                        onLoading: (_) => Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox.square(
                                dimension:
                                    MediaQuery.sizeOf(context).width - 150.0,
                                child: const CircularProgressIndicator(),
                              ),
                              const SizedBox(height: 20.0),
                              const BigText.bold('Carregando Informações...')
                            ],
                          ),
                        ),
                        onFail: (ctx, fail) {
                          UmbrellaDialogs.showError(
                            context,
                            fail.message,
                            onRetry: widget._personStore.obtainPersonsDebts,
                            onConfirmPressed:
                                widget._personStore.obtainPersonsDebts,
                          );

                          return const SizedBox.shrink();
                        },
                        onState: (ctx, debts) => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: debts.keys.length,
                          itemBuilder: (_, index) {
                            var name = debts.keys.elementAt(index);
                            double value = debts[name]!;
                            return UnconstrainedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: PersonLetterWidget(
                                  personName: name,
                                  personStatus: _resolveDebtStatus(value),
                                  value: value,
                                  valueColor: resolveValueColor(value),
                                ),
                              ),
                              // child: _mountPersonCard(name, debts[name]!),
                            );
                          },
                          shrinkWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mountPersonCard(String name, double value) {
    return Container(
      width: 240,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(4.0),
        color: UmbrellaPalette.secondaryColor,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BigText.bold(_resolveDebtStatus(value)),
          Spaced(
            first: const MediumText('Nome'),
            second: MediumText.bold(name),
          ),
          Spaced(
            first: const SmallText('Valor devido:'),
            second: Price.small(
              value,
              color: resolveValueColor(value),
            ),
          ),
        ],
      ),
    );
  }

  String _resolveDebtStatus(double value) => switch (value) {
        _ when value > 0.00 => 'Credor',
        _ when value < 0.00 => 'Devedor',
        _ => 'Quitado',
      };
}
