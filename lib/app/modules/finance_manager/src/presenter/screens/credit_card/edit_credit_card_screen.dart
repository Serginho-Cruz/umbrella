import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/credit_card_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/appbar/custom_app_bar.dart';

import '../../../domain/entities/credit_card.dart';
import '../../../domain/states/state.dart' as s;
import '../../utils/umbrella_palette.dart';
import '../../widgets/dialogs/loading_dialog.dart';
import '../../widgets/simple_information/account_name.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/others/card_preview_section.dart';
import '../../widgets/simple_information/color_row.dart';
import '../../widgets/layout/umbrella_scaffold.dart';
import '../../widgets/layout/spaced.dart';
import '../../widgets/texts/big_text.dart';
import '../../widgets/dialogs/umbrella_dialogs.dart';
import '../../widgets/forms/default_text_field.dart';
import '../../widgets/forms/my_form.dart';
import '../../widgets/selectors/color_selector.dart';
import '../../widgets/selectors/day_selector.dart';
import '../../widgets/texts/medium_text.dart';

class EditCreditCardScreen extends StatefulWidget {
  const EditCreditCardScreen({
    super.key,
    required CreditCardStore cardStore,
    required CreditCard card,
  })  : _cardStore = cardStore,
        _card = card;

  final CreditCardStore _cardStore;
  final CreditCard _card;

  @override
  State<EditCreditCardScreen> createState() => _EditCreditCardScreenState();
}

class _EditCreditCardScreenState extends State<EditCreditCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  bool _isLoading = false;
  late final ReactionDisposer _disposer;

  void _setUpReaction() {
    _disposer = reaction(
      (_) => widget._cardStore.state,
      (st) async {
        switch (st) {
          case s.LoadingState():
            _isLoading = true;
            LoadingDialog.show(
              context,
              message: 'Atualizando seu cartão...',
            );
            break;
          case s.SuccessState():
            if (_isLoading) Navigator.pop(context);
            _isLoading = false;
            await UmbrellaDialogs.showSuccess(
              context,
              title: 'Cartão Atualizado',
              message:
                  'Seu Cartão de Crédito foi atualizado com sucesso. Iremos redireciona-lo para a Tela Anterior',
            );
            _disposer();

            if (mounted) Navigator.pop(context);
            break;
          case s.FailState f:
            if (_isLoading) Navigator.pop(context);
            _isLoading = false;
            await UmbrellaDialogs.showError(context, f.fail.message);
            break;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _setUpReaction();
    _setVariablesToOriginal();
  }

  void _setVariablesToOriginal() {
    widget._cardStore.setName(widget._card.name);
    widget._cardStore.setColor(widget._card.color);
    widget._cardStore.setCloseDay(widget._card.cardInvoiceClosingDay);
    widget._cardStore.setDueDay(widget._card.cardInvoiceDueDay);
  }

  @override
  void dispose() {
    widget._cardStore.resetFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UmbrellaScaffold(
      appBar: CustomAppBar(
        title: 'Editar Cartão',
      ),
      child: SingleChildScrollView(
        child: MyForm(
          formKey: formKey,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.05,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: AccountName(
                account: widget._card.accountToDiscountInvoice,
                trailingText: 'Debitando da Conta',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Observer(
                builder: (_) => DefaultTextField(
                  validator: widget._cardStore.validateName,
                  maxLength: 30,
                  labelText: 'Nome',
                  initialValue: widget._cardStore.name,
                  onChanged: widget._cardStore.setName,
                  readOnly: widget._cardStore.isLoading,
                ),
              ),
            ),
            Observer(builder: (_) {
              return DaySelector(
                bottomSheetText:
                    'Selecione o Dia do Fechamento da fatura desse cartão',
                onDaySelected: widget._cardStore.setCloseDay,
                child: Spaced(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  first: const BigText('Fecham. da Fatura'),
                  second: BigText('Dia ${widget._cardStore.invoiceCloseDay}'),
                ),
              );
            }),
            Observer(builder: (_) {
              return DaySelector(
                bottomSheetText:
                    'Selecione o Dia do Vencimento da fatura desse cartão',
                onDaySelected: widget._cardStore.setDueDay,
                child: Spaced(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  first: const BigText('Vencim. da Fatura'),
                  second: BigText('Dia ${widget._cardStore.invoiceDueDay}'),
                ),
              );
            }),
            Observer(
              builder: (_) {
                String hex = widget._cardStore.color;
                return ColorSelector(
                  onSelected: widget._cardStore.setColor,
                  child: ColorRow(
                    colorHex: widget._cardStore.color,
                    colorName: UmbrellaPalette.cardHexAndNames[hex]!,
                    label: 'Cor do Cartão',
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                );
              },
            ),
            Observer(
              builder: (_) => CardPreviewSection(
                card: _mountCard(),
                isToShow: widget._cardStore.showPreview,
              ),
            ),
            Spaced(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              first: SecondaryButton(
                onPressed: _resetForm,
                label: const MediumText.bold('Limpar'),
              ),
              second: PrimaryButton(
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Colors.black,
                  size: 24.0,
                ),
                label: const MediumText.bold('Atualizar'),
                onPressed: _onFormSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    bool isValid = formKey.currentState!.validate();

    if (!isValid) {
      UmbrellaDialogs.showError(context,
          'O formulário contém erros. Corrija-os para cadastrar seu cartão');
      return;
    }

    widget._cardStore.updateCard(widget._card);
  }

  void _resetForm() => _setVariablesToOriginal();

  CreditCard _mountCard() {
    return CreditCard(
      id: widget._card.id,
      name: widget._cardStore.name,
      accountToDiscountInvoice: widget._card.accountToDiscountInvoice,
      cardInvoiceClosingDay: widget._cardStore.invoiceCloseDay,
      cardInvoiceDueDay: widget._cardStore.invoiceDueDay,
      color: widget._cardStore.color,
    );
  }
}
