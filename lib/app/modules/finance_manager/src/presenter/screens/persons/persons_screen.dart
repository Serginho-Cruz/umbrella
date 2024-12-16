import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/routes.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/resolve_value_color.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/list_segmented_state_widget.dart';

import '../../stores/account_store.dart';
import '../../stores/person_store.dart';
import '../../widgets/animations/loading_animation.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/others/no_debts_found.dart';
import '../../widgets/others/person_letter_widget.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/others/segmented_state_widget.dart';
import '../../widgets/selectors/account_selector.dart';
import '../../widgets/texts/medium_text.dart';

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
            child: LoadingAnimation(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: 400,
              message: 'Carregando Contas...',
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

          return Center(
            child: Column(
              children: [
                const MediumText('Houve um erro ao obter suas contas'),
                const SizedBox(height: 30),
                PrimaryButton(
                  label: const MediumText.bold('Tentar novamente'),
                  onPressed: widget._accountStore.get,
                ),
              ],
            ),
          );
        },
        onEmpty: (_) {
          UmbrellaDialogs.showError(
            context,
            'Um Erro inesperado aconteceu. Por favor, tente novamente',
            onRetry: widget._accountStore.get,
            onConfirmPressed: widget._accountStore.get,
          );

          return Center(
            child: Column(
              children: [
                const MediumText('Houve um erro ao obter suas contas'),
                const SizedBox(height: 30),
                PrimaryButton(
                  label: const MediumText.bold('Tentar novamente'),
                  onPressed: widget._accountStore.get,
                ),
              ],
            ),
          );
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
                physics: const AlwaysScrollableScrollPhysics(),
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
                          child: LoadingAnimation(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            height: 400,
                            message: 'Carregando Débitos existentes...',
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

                          return Center(
                            child: Column(
                              children: [
                                const MediumText(
                                    'Houve um erro ao obter os dados de débitos de pessoas'),
                                const SizedBox(height: 30),
                                PrimaryButton(
                                  label:
                                      const MediumText.bold('Tentar novamente'),
                                  onPressed: widget._personStore.getAll,
                                ),
                              ],
                            ),
                          );
                        },
                        onState: (ctx, debts) => debts.isEmpty
                            ? _mountEmptyCase()
                            : ListView.builder(
                                padding: const EdgeInsets.only(top: 40),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: debts.keys.length,
                                itemBuilder: (_, index) {
                                  var name = debts.keys.elementAt(index);
                                  double value = debts[name]!;
                                  return UnconstrainedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            FinanceRoutes.personDetails,
                                            arguments: name,
                                          );
                                        },
                                        child: PersonLetterWidget(
                                          personName: name,
                                          personStatus:
                                              _resolveDebtStatus(value),
                                          value: value,
                                          valueColor: resolveValueColor(value),
                                        ),
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

  Widget _mountEmptyCase() {
    return const Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: NoDebtsFound(),
    );
  }

  String _resolveDebtStatus(double value) => switch (value) {
        _ when value > 0.00 => 'Receptor',
        _ when value < 0.00 => 'Devedor',
        _ => 'Quitado',
      };
}
