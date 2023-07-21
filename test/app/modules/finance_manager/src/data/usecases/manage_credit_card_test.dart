import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/icredit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/manage_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../utils/factorys/credit_card_factory.dart';
import '../repositories/credit_card_repository_mock.dart';
import '../repositories/invoice_repository_mock.dart';

void main() {
  late IManageCreditCard usecase;
  late ICreditCardRepository cardRepository;
  late IInvoiceRepository invoiceRepository;

  setUpAll(() {
    registerFallbackValue(CreditCardFactory.generate());
  });

  setUp(() {
    cardRepository = CreditCardRepositoryMock();
    invoiceRepository = InvoiceRepositoryMock();
    usecase = ManageCreditCard(
      cardRepository: cardRepository,
      invoiceRepository: invoiceRepository,
    );
  });

  group("Manage Credit Card Usecase is Working", () {
    group("register method", () {
      setUp(() {
        when(() => cardRepository.create(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => invoiceRepository.generateOfCard(any()))
            .thenAnswer((_) async => const Success(2));
      });

      test("Must call card repository to create the card", () async {
        await usecase.register(CreditCardFactory.generate());

        verify(() => cardRepository.create(any()));
      });
      test("Must call invoice repository to create the card's invoice",
          () async {
        await usecase.register(CreditCardFactory.generate());

        verify(() => invoiceRepository.generateOfCard(any()));
      });

      test("Must pass the exactly same card to repositories", () async {
        final card = CreditCardFactory.generate();
        await usecase.register(card);

        verify(() => cardRepository.create(card));
        verify(() => invoiceRepository.generateOfCard(card));
      });
      test("returns an error when some of repositories fails", () async {
        when(() => cardRepository.create(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        var result = await usecase.register(CreditCardFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return a Fail because a error happened creating the card',
        );

        when(() => cardRepository.create(any()))
            .thenAnswer((_) async => const Success(2));
        when(() => invoiceRepository.generateOfCard(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        result = await usecase.register(CreditCardFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return a Fail because a error happened creating the invoice of card',
        );
      });
      test("returns success when no error happens", () async {
        var result = await usecase.register(CreditCardFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason:
              'Must return success because no error happened in repositories',
        );
      });
    });
    group("update method", () {
      setUp(() {
        when(() => cardRepository.updateCard(any()))
            .thenAnswer((_) async => const Success(2));
      });

      test("must call repository to update card data", () async {
        await usecase.update(CreditCardFactory.generate());

        verify(() => cardRepository.updateCard(any()));
      });
      test("returns fail when an error happens in repository", () async {
        when(() => cardRepository.updateCard(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.update(CreditCardFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason:
              'Must return an error because an error happened in repository',
        );
      });
      test("returns success when no error happens", () async {
        final result = await usecase.update(CreditCardFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return success because no error happened in repository',
        );
      });
    });
    group("get all method", () {
      setUp(() {
        when(() => cardRepository.getAll()).thenAnswer((_) async =>
            Success(List.generate(5, (_) => CreditCardFactory.generate())));
      });

      test("returns success with a list when no error happens", () async {
        final result = await usecase.getAll();

        expect(
          result.isSuccess(),
          isTrue,
          reason:
              'Must return a success because no error happened in repository',
        );
        expect(result.fold((s) => s, (f) => f), isA<List<CreditCard>>());

        verify(() => cardRepository.getAll());
      });
      test("returns fail when an error happens in repository", () async {
        when(() => cardRepository.getAll())
            .thenAnswer((_) async => Failure(Fail("")));
        final result = await usecase.getAll();

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return a fail because an error happened in repository',
        );
        expect(result.fold((s) => s, (f) => f), isA<Fail>());

        verify(() => cardRepository.getAll());
      });
    });
    group("cancel method", () {
      setUp(() {
        when(() => cardRepository.delete(any()))
            .thenAnswer((_) async => const Success(2));
      });

      test("returns success when no error happens", () async {
        final result = await usecase.cancel(CreditCardFactory.generate());

        expect(
          result.isSuccess(),
          isTrue,
          reason: 'Must return success because no error happened',
        );
        verify(() => cardRepository.delete(any()));
      });
      test("returns fail when an error happens in repository", () async {
        when(() => cardRepository.delete(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.cancel(CreditCardFactory.generate());

        expect(
          result.isError(),
          isTrue,
          reason: 'Must return fail because an error happened in repository',
        );
        verify(() => cardRepository.delete(any()));
      });
      test("pass the exactly same card to repository", () async {
        final card = CreditCardFactory.generate();
        await usecase.cancel(card);

        verify(() => cardRepository.delete(card));
      });
    });
  });
}
