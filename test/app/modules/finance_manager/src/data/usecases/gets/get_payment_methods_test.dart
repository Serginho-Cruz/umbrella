import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/ipayment_method_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/gets/get_payment_methods.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_payment_methods.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../../utils/factorys/payment_method_factory.dart';
import '../../repositories/payment_method_repository_mock.dart';

void main() {
  late IPaymentMethodRepository repository;
  late IGetPaymentMethods usecase;
  late List<PaymentMethod> methods = [];

  setUp(() {
    repository = PaymentMethodRepositoryMock();
    usecase = GetPaymentMethods(repository);
    methods.clear();
    methods.addAll(List.generate(8, (_) => PaymentMethodFactory.generate()));
  });

  group("Get Payment Methods Usecase is Working", () {
    test("answer the same list returned by repository when no error happens",
        () async {
      when(() => repository.getAll()).thenAnswer((_) async => Success(methods));

      final result = await usecase();

      verify(() => repository.getAll()).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<List<PaymentMethod>>());
      expect(result.fold((s) => s, (f) => f), equals(methods));
    });
    test("answer the same error returned by repository when errors happens",
        () async {
      final fail = Fail("");
      when(() => repository.getAll()).thenAnswer((_) async => Failure(fail));

      final result = await usecase();

      verify(() => repository.getAll()).called(1);

      expect(result.isError(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<Fail>());
      expect(result.fold((s) => s, (f) => f), equals(fail));
    });
  });
}
