import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/maintain_invoice_uc.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/credit_card.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/invoice_item.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imaintain_invoice.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import '../../domain/factorys/credit_card_factory.dart';
import '../../domain/factorys/invoice_factory.dart';
import '../../domain/factorys/invoice_item_factory.dart';

import '../repositories/invoice_repository_mock.dart';

void main() {
  late IInvoiceRepository repository;
  late IMaintainInvoice usecase;
  late Invoice invoice;
  late InvoiceItem item;
  late CreditCard card;

  setUp(() {
    repository = InvoiceRepositoryMock();
    usecase = MaintainInvoiceUC(repository);
    invoice = InvoiceFactory.generate();
    item = InvoiceItemFactory.generate();
    card = CreditCardFactory.generate();
    registerFallbackValue(invoice);
    registerFallbackValue(item);
    registerFallbackValue(card);
  });

  group("Add Item Method is Working,", () {
    test("Returns Void when no errors occur", () async {
      when(() => repository.addItemToInvoice(
            item: any(named: "item"),
            card: any(named: "card"),
          )).thenAnswer((_) async => const Success(2));

      final result = await usecase.addItemToInvoice(
        item: item,
        card: card,
      );

      verify(() => repository.addItemToInvoice(
            item: item,
            card: card,
          )).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) {}, (f) => f), isA<void>());
    });
    test("Returns a Fail when some error occur", () async {
      when(() => repository.addItemToInvoice(
            item: any(named: "item"),
            card: any(named: "card"),
          )).thenAnswer((_) async => Failure(Fail("")));

      final result = await usecase.addItemToInvoice(
        item: item,
        card: card,
      );

      verify(() => repository.addItemToInvoice(
            item: item,
            card: card,
          )).called(1);

      expect(result.isError(), isTrue);
      expect(result.fold((s) {}, (f) => f), isA<Fail>());
    });
  });
  group("Get All Method is Working,", () {
    test("Returns a List of Invoices when no errors occur", () async {
      var list = InvoiceFactory.generateInvoices();

      when(() => repository.getAll()).thenAnswer((_) async => Success(list));

      final result = await usecase.getAll();

      verify(() => repository.getAll()).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<List<Invoice>>());
      expect(result.fold((s) => s, (f) => f), equals(list));
    });
    test("Returns a Fail when some error occur", () async {
      when(() => repository.getAll())
          .thenAnswer((_) async => Failure(Fail("")));

      final result = await usecase.getAll();

      verify(() => repository.getAll()).called(1);

      expect(result.isError(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<Fail>());
    });
  });
  group("Generate All Method is Working", () {
    test("Returns Void when no errors occur", () async {
      when(() => repository.generateAll())
          .thenAnswer((_) async => const Success(2));

      final result = await usecase.generateInvoices();

      verify(() => repository.generateAll()).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) {}, (f) => f), isA<void>());
    });
    test("Returns a Fail when some error occur", () async {
      when(() => repository.generateAll())
          .thenAnswer((_) async => Failure(Fail("")));

      final result = await usecase.generateInvoices();

      verify(() => repository.generateAll()).called(1);

      expect(result.isError(), isTrue);
      expect(result.fold((s) {}, (f) => f), isA<Fail>());
    });
  });

  group("Delete Method is Working", () {
    test("Returns Void when no errors occur", () async {
      when(() => repository.deleteInvoice(any()))
          .thenAnswer((_) async => const Success(2));

      final result = await usecase.deleteInvoice(invoice);

      verify(() => repository.deleteInvoice(invoice)).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) {}, (f) => f), isA<void>());
    });
    test("Returns a Fail when some error occur", () async {
      when(() => repository.deleteInvoice(any()))
          .thenAnswer((_) async => Failure(Fail("")));

      final result = await usecase.deleteInvoice(invoice);

      verify(() => repository.deleteInvoice(invoice)).called(1);

      expect(result.isError(), isTrue);
      expect(result.fold((s) {}, (f) => f), isA<Fail>());
    });
  });
}
