import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/stores/auth_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/primary_button.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/dialogs/create_account_dialog.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/tappable/account_tappable_options.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/tappable/tappable.dart';

import '../../stores/account_store.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/umbrella_icon_button.dart';
import '../../widgets/cards/account_card.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/others/list_segmented_state_widget.dart';
import '../../widgets/texts/medium_text.dart';
import '../../widgets/texts/small_text.dart';

class AccountsScreen extends StatefulWidget {
  final AccountStore _accountStore;

  const AccountsScreen({
    super.key,
    required AccountStore accountStore,
    required AuthStore authStore,
  }) : _accountStore = accountStore;

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  void _createAccount() {
    showDialog(
      context: context,
      builder: (ctx) => CreateAccountDialog(accountStore: widget._accountStore),
    ).then((_) {
      widget._accountStore.cleanFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Minhas Contas',
        showMonthChanger: false,
      ),
      floatingActionButton: UmbrellaIconButton(
        icon: const Icon(Icons.add, color: Colors.black, size: 35.0),
        isPrimary: false,
        onPressed: _createAccount,
      ),
      child: RefreshIndicator.adaptive(
        onRefresh: () => widget._accountStore.get(force: true),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.1,
                vertical: 20,
              ),
              sliver: SliverList.list(
                children: const [
                  MediumText('Olá! Aqui estão as suas contas'),
                  SizedBox(height: 15.0),
                  SmallText('A estrela indica sua Conta Padrão'),
                ],
              ),
            ),
            Observer(
              builder: (_) => ListSegmentedStateWidget(
                state: widget._accountStore.state,
                onLoading: (_) => SliverToBoxAdapter(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 600,
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ),
                onFail: (ctx, f) {
                  return SliverFillRemaining(
                    child: Center(
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MediumText('Erro: ${f.message}'),
                            PrimaryButton(
                              label: const MediumText('Recarregar Contas'),
                              onPressed: widget._accountStore.get,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                onState: (ctx, state) {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.2,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) {
                          var acc = state[index];
                          return Tappable(
                            options: AccountTappableOptions.get(
                              account: acc,
                              context: ctx,
                              store: widget._accountStore,
                            ),
                            child: AccountCard(account: acc),
                          );
                        },
                        childCount: state.length,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
