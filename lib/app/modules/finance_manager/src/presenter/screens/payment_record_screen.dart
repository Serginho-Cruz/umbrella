import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/others/segmented_state_widget.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/payment_records/payment_record_section.dart';

import '../../domain/entities/date.dart';
import '../../domain/entities/payment_record.dart';
import '../stores/account_store.dart';
import '../stores/month_store.dart';
import '../stores/payment_record_store.dart';
import '../widgets/appbar/custom_app_bar.dart';
import '../widgets/dialogs/umbrella_dialogs.dart';
import '../widgets/filters/payment_record_filter.dart';
import '../widgets/layout/umbrella_scaffold.dart';
import '../widgets/others/list_segmented_state_widget.dart';
import '../widgets/payment_records/payment_record_widget.dart';
import '../widgets/selectors/account_selector.dart';
import '../widgets/texts/big_text.dart';

class PaymentRecordScreen extends StatefulWidget {
  const PaymentRecordScreen({
    super.key,
    required PaymentRecordStore recordStore,
    required AccountStore accountStore,
    required MonthStore monthStore,
  })  : _recordStore = recordStore,
        _monthStore = monthStore,
        _accountStore = accountStore;

  final PaymentRecordStore _recordStore;
  final AccountStore _accountStore;
  final MonthStore _monthStore;

  @override
  State<PaymentRecordScreen> createState() => _PaymentRecordScreenState();
}

class _PaymentRecordScreenState extends State<PaymentRecordScreen> {
  @override
  void initState() {
    super.initState();
    widget._recordStore.activate();
    widget._recordStore.fetch();
  }

  @override
  void dispose() {
    widget._recordStore.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext screenContext) {
    return Observer(
      builder: (_) => ListSegmentedStateWidget(
        state: widget._accountStore.state,
        onLoading: (_) => UmbrellaScaffold(
          appBar: CustomAppBar(
            title: 'Registros de Pagamento',
            showBalances: false,
          ),
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
            title: 'Registros de Pagamento',
            showMonthChanger: true,
          ),
          child: const SizedBox(),
        ),
        onState: (context, accounts) => UmbrellaScaffold(
          appBar: CustomAppBar(
            title: 'Registros de Pagamento',
            showMonthChanger: true,
          ),
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              widget._accountStore.get(force: true);
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                    PaymentRecordFilter(recordStore: widget._recordStore),
                    Observer(
                      builder: (ctx) => SegmentedStateWidget(
                        state: widget._recordStore.state,
                        onLoading: (_) => Padding(
                          padding: const EdgeInsets.only(top: 40.0),
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
                        onInitial: (_) {
                          return const SizedBox.shrink();
                        },
                        onFail: (_, fail) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            UmbrellaDialogs.showError(
                              context,
                              fail.message,
                              onRetry: widget._recordStore.fetch,
                              onConfirmPressed: widget._recordStore.fetch,
                            );
                          });

                          return const SizedBox.shrink();
                        },
                        onState: (_, map) => _getRecordsListWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getRecordsListWidget() {
    var (:month, :year) = widget._monthStore.month;

    var monthName = Date(day: 1, month: month, year: year).monthName;

    return Observer(
      builder: (_) {
        var filtered = widget._recordStore.filteredState;

        List<int> orderedKeys = _getOrderedKeys(filtered.keys.toList());

        return ListView.builder(
          itemCount: orderedKeys.length,
          addAutomaticKeepAlives: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.05,
            vertical: 30,
          ),
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            int key = orderedKeys[index];
            return _mountDaySection(
              key,
              monthName,
              filtered[key]!,
            );
          },
        );
      },
    );
  }

  List<int> _getOrderedKeys(List<int> keys) {
    int multiplierFactor = widget._recordStore.areDatesInCrescentOrder ? -1 : 1;

    return List<int>.from(keys)
      ..sort((key1, key2) => key1.compareTo(key2) * multiplierFactor);
  }

  Widget _mountDaySection(
    int day,
    String monthName,
    List<PaymentRecord> records,
  ) {
    var (:month, :year) = widget._monthStore.month;
    final date = Date(day: day, month: month, year: year);

    return PaymentRecordSection(
        day: date,
        children: records.indexed.map(
          (rec) {
            return PaymentRecordWidget(
              roundedOnTop: rec.$1 == 0,
              roundedOnBottom: rec.$1 == records.length - 1,
              record: rec.$2,
            );
          },
        ).toList());
  }
}
