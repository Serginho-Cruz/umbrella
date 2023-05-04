import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/inotifications_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/configure_notifications_uc.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/notifications_configuration.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/iconfigure_notifications.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../repositories/notification_repository_mock.dart';

void main() {
  late INotificationsRepository repository;
  late IConfigureNotifications usecase;
  late NotificationsConfiguration configuration;
  late NotificationsConfiguration defaultConfiguration;

  setUp(() {
    repository = NotificationRepoMock();
    usecase = ConfigureNotificationsUC(repository);
    configuration = NotificationsConfiguration(
      isToSend: true,
      daysBefore: 2,
      hourToSend: DateTime(2023, 2, 3, 17, 45),
    );
    defaultConfiguration = NotificationsConfiguration(
      isToSend: true,
      daysBefore: 5,
      hourToSend: DateTime(2023, 2, 3, 20, 00),
    );

    registerFallbackValue(defaultConfiguration);
  });

  group("Configure notifications usecase is working fine", () {
    group("Call method is working", () {
      test("Returns void when configuration is changed with success", () async {
        when(() => repository(configuration))
            .thenAnswer((_) async => const Success(2));

        final result = await usecase(configuration);

        verify(() => repository(configuration)).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });
      test("Returns a Fail when an error occurs", () async {
        when(() => repository(configuration))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase(configuration);

        verify(() => repository(configuration)).called(1);

        expect(result.isError(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<Fail>());
      });
    });
    group("Set Default method is working", () {
      test("Returns void when default configuration is applied", () async {
        when(() => repository(any())).thenAnswer((_) async => const Success(2));

        final result = await usecase.setDefault();

        verify(() => repository(any())).called(1);

        expect(result.isSuccess(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<void>());
      });
      test("Returns a Fail when no errors occur", () async {
        when(() => repository(any()))
            .thenAnswer((_) async => Failure(Fail("")));

        final result = await usecase.setDefault();

        verify(() => repository(any())).called(1);

        expect(result.isError(), isTrue);
        expect(result.fold((s) {}, (f) => f), isA<Fail>());
      });
    });
  });
}
