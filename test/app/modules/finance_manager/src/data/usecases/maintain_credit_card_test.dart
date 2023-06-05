import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/icredit_card_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/maintain_credit_card_uc.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imaintain_credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/factorys/credit_card_factory.dart';
import '../repositories/credit_card_repository_mock.dart';

void main() {
  late IMaintainCreditCard usecase;
  late ICreditCardRepository repository;
  late CreditCard card;

  setUp(() {
    repository = CreditCardRepositoryMock();
    usecase = MaintainCreditCard(repository);
    card = CreditCardFactory.generate();
  });

  group("Maintain Credit Card usecase is working, ", () {
    group("Create Method is ok", () {
      test("Returns void when the CreditCard is create with success", () async {
        when(() => repository.create(card))
            .thenAnswer((_) async => const Success(2));

        final result = await usecase.register(card);
        verify(() => repository.create(card)).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });

      test("Returns a Fail when some error occur in repository", () async {
        when(() => repository.create(card))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.register(card);

        verify(() => repository.create(card)).called(1);

        expect(result.isError(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<Fail>());
      });
    });
    group("Update Method is ok", () {
      test("Returns void when the Card is updated with success", () async {
        when(() => repository.updateCard(card))
            .thenAnswer((_) async => const Success(2));

        final result = await usecase.update(card);

        verify(() => repository.updateCard(card)).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });
      test("Returns a Fail when some error occur in repository", () async {
        when(() => repository.updateCard(card))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.update(card);

        verify(() => repository.updateCard(card)).called(1);

        expect(result.isError(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<Fail>());
      });
    });
    group("GetAll Method is ok", () {
      test("Returns a List of Cards when no errors occur", () async {
        when(() => repository.getAll()).thenAnswer(
            (_) async => Success(CreditCardFactory.generateCards()));

        final result = await usecase.getAll();

        verify(() => repository.getAll()).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<List<CreditCard>>());
      });
      test("Returns a Fail when some error occur in repository", () async {
        when(() => repository.getAll())
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.getAll();

        verify(() => repository.getAll()).called(1);

        expect(result.isError(), isTrue);
        expect(result.fold((s) => s, (f) => f), isA<Fail>());
      });
    });
    group("Delete Method is ok", () {
      test("Returns void when the Card is deleted with success", () async {
        when(() => repository.delete(card))
            .thenAnswer((_) async => const Success(2));

        final result = await usecase.delete(card);

        verify(() => repository.delete(card)).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });
      test("Returns a Fail when some error occur", () async {
        when(() => repository.delete(card))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.delete(card);

        verify(() => repository.delete(card)).called(1);

        expect(result.isError(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<Fail>());
      });
    });
  });
}
