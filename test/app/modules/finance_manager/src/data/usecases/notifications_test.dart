import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/gateways/inotifications_gateway.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iexpense_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iinvoice_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/inotifications_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/notifications_uc.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/notifications_configuration.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/inotifications.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import '../../domain/factorys/expense_parcel_factory.dart';
import '../../domain/factorys/invoice_factory.dart';
import '../../domain/factorys/notifications_configuration_factory.dart';
import '../gateways/notifications_gateway_mock.dart';
import '../repositories/expense_parcel_repository_mock.dart';
import '../repositories/invoice_repository_mock.dart';
import '../repositories/notifications_repository_mock.dart';

void main() {
  late INotificationsRepository repository;
  late IExpenseParcelRepository expenseParcelRepository;
  late IInvoiceRepository invoiceRepository;
  late INotificationsGateway gateway;
  late INotifications usecase;
  late NotificationsConfiguration configuration;
  late NotificationsConfiguration defaultConfiguration;

  setUp(() {
    repository = NotificationsRepoMock();
    expenseParcelRepository = ExpenseParcelRepositoryMock();
    invoiceRepository = InvoiceRepositoryMock();
    gateway = NotificationsGatewayMock();
    usecase = ConfigureNotificationsUC(
      notificationsRepository: repository,
      expensesParcelRepository: expenseParcelRepository,
      invoicesRepository: invoiceRepository,
      gateway: gateway,
    );
    configuration = NotificationsFactory.generate();
    defaultConfiguration = NotificationsFactory.generateDefault();

    registerFallbackValue(defaultConfiguration);
    when(() => repository.getDaysBefore())
        .thenAnswer((_) async => const Success(5));
  });

  group("Notifications usecase is working fine", () {
    group("Configure method is working", () {
      test("Returns void when configuration is changed with success", () async {
        when(() => repository(configuration))
            .thenAnswer((_) async => const Success(2));

        when(() => gateway.configureNotification(configuration))
            .thenAnswer((_) async {});

        final result = await usecase.configure(configuration);

        verify(() => repository(configuration)).called(1);
        verify(() => gateway.configureNotification(configuration)).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });
      test("Returns a Fail when an error occurs in repository", () async {
        when(() => repository(configuration))
            .thenAnswer((_) async => Failure(Fail("")));

        when(() => gateway.configureNotification(configuration))
            .thenAnswer((_) async {});

        final result = await usecase.configure(configuration);

        verify(() => repository(configuration)).called(1);
        verifyNever(() => gateway.configureNotification(any()));

        expect(result.isError(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<Fail>());
      });
    });
    group("Set Default method is working", () {
      test("Returns void when default configuration is applied", () async {
        when(() => repository(any())).thenAnswer((_) async => const Success(2));
        when(() => gateway.configureNotification(any()))
            .thenAnswer((_) async {});

        final result = await usecase.setDefault();

        verify(() => repository(any())).called(1);
        verify(() => gateway.configureNotification(any())).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });
      test("Returns a Fail when an error occur in repository", () async {
        when(() => repository(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        when(() => gateway.configureNotification(any()))
            .thenAnswer((_) async {});

        final result = await usecase.setDefault();

        verify(() => repository(any())).called(1);
        verifyNever(() => gateway.configureNotification(any()));

        expect(result.isError(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<Fail>());
      });
    });

    group("Send Near Expiration method is working", () {
      test("Call Notifications Repository get days before", () async {
        when(() => expenseParcelRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => const Success([]));
        when(() => invoiceRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => const Success([]));
        when(() => gateway.sendExpensesNotification(any()))
            .thenAnswer((_) async {});
        when(() => gateway.sendInvoicesNotification(any()))
            .thenAnswer((_) async {});

        await usecase.sendNearExpiration();

        verify(() => repository.getDaysBefore()).called(1);
      });

      test(
          "Don't call gateway send expenses notification method when the list is empty",
          () async {
        when(() => expenseParcelRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => const Success([]));
        when(() => invoiceRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => Success([InvoiceFactory.generate()]));
        when(() => gateway.sendExpensesNotification(any()))
            .thenAnswer((_) async {});
        when(() => gateway.sendInvoicesNotification(any()))
            .thenAnswer((_) async {});

        await usecase.sendNearExpiration();

        verifyNever(() => gateway.sendExpensesNotification(any()));
      });
      test(
          "Don't call gateway send invoices notification method when the list is empty",
          () async {
        when(() => expenseParcelRepository.getWhereExpiresOn(any())).thenAnswer(
            (_) async => Success([ExpenseParcelFactory.generate()]));
        when(() => invoiceRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => const Success([]));
        when(() => gateway.sendExpensesNotification(any()))
            .thenAnswer((_) async {});
        when(() => gateway.sendInvoicesNotification(any()))
            .thenAnswer((_) async {});

        await usecase.sendNearExpiration();

        verifyNever(() => gateway.sendInvoicesNotification(any()));
      });
      test(
          "Don't call gateway send expenses notification method when an error occur in repository",
          () async {
        when(() => expenseParcelRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => Failure(Fail("")));
        when(() => invoiceRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => const Success([]));
        when(() => gateway.sendExpensesNotification(any()))
            .thenAnswer((_) async {});
        when(() => gateway.sendInvoicesNotification(any()))
            .thenAnswer((_) async {});

        await usecase.sendNearExpiration();

        verifyNever(() => gateway.sendExpensesNotification(any()));
      });
      test(
          "Don't call gateway send invoices notification method when an error occur in repository",
          () async {
        when(() => expenseParcelRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => const Success([]));
        when(() => invoiceRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => Failure(Fail("")));
        when(() => gateway.sendExpensesNotification(any()))
            .thenAnswer((_) async {});
        when(() => gateway.sendInvoicesNotification(any()))
            .thenAnswer((_) async {});

        await usecase.sendNearExpiration();

        verifyNever(() => gateway.sendInvoicesNotification(any()));
      });
      test(
          "Must Call both methods and passing the lists returned by repository when no errors occur and lists aren't empty",
          () async {
        var expensesList = ExpenseParcelFactory.generateList();
        var invoicesList = InvoiceFactory.generateInvoices();
        when(() => expenseParcelRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => Success(expensesList));
        when(() => invoiceRepository.getWhereExpiresOn(any()))
            .thenAnswer((_) async => Success(invoicesList));
        when(() => gateway.sendExpensesNotification(expensesList))
            .thenAnswer((_) async {});
        when(() => gateway.sendInvoicesNotification(invoicesList))
            .thenAnswer((_) async {});

        await usecase.sendNearExpiration();

        verify(() => gateway.sendExpensesNotification(expensesList)).called(1);
        verify(() => gateway.sendInvoicesNotification(invoicesList)).called(1);
      });
    });

    test("Send Remember Method is Working", () async {
      when(() => gateway.sendRememberingNotification())
          .thenAnswer((_) async {});

      await usecase.sendRemembering();

      verify(() => gateway.sendRememberingNotification()).called(1);
    });
  });
}
