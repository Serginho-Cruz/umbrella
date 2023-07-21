import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';

import '../../domain/entities/credit_card.dart';
import '../../domain/usecases/imanage_credit_card.dart';
import '../../errors/errors.dart';
import '../repositories/icredit_card_repository.dart';

class ManageCreditCard implements IManageCreditCard {
  final ICreditCardRepository cardRepository;
  final IInvoiceRepository invoiceRepository;

  ManageCreditCard({
    required this.cardRepository,
    required this.invoiceRepository,
  });

  @override
  Future<Result<void, Fail>> register(CreditCard card) async {
    final cardCreateResult = await cardRepository.create(card);

    if (cardCreateResult.isError()) {
      return cardCreateResult;
    }

    return await invoiceRepository.generateOfCard(card);
  }

  @override
  Future<Result<void, Fail>> update(CreditCard newCard) =>
      cardRepository.updateCard(newCard);

  @override
  Future<Result<List<CreditCard>, Fail>> getAll() => cardRepository.getAll();

  @override
  Future<Result<void, Fail>> cancel(CreditCard card) =>
      cardRepository.delete(card);
}
