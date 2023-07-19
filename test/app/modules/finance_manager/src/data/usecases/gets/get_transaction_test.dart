import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/itransaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/gets/get_transactions.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/gets/iget_transactions.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../../utils/factorys/transactions_factory.dart';
import '../../repositories/transaction_repository_mock.dart';

void main() {
  late ITransactionRepository repository;
  late IGetTransactionsOf usecase;
  late List<Transaction> transactions = [];

  setUp(() {
    repository = TransactionRepositoryMock();
    usecase = GetTransactionsOf(repository);
    transactions.clear();
    transactions
        .addAll(List.generate(8, (_) => TransactionsFactory.generate()));
  });

  group("Get Transactions Of Usecase is Working", () {
    test("answer the same list returned by repository when no error happens",
        () async {
      when(() => repository.getOf(any()))
          .thenAnswer((_) async => Success(transactions));

      final result = await usecase(DateTime.now());

      verify(() => repository.getOf(any())).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<List<Transaction>>());
      expect(result.fold((s) => s, (f) => f), equals(transactions));
    });
    test("answer the same error returned by repository when errors happens",
        () async {
      final fail = Fail("");

      when(() => repository.getOf(any()))
          .thenAnswer((_) async => Failure(fail));

      final result = await usecase(DateTime.now());

      verify(() => repository.getOf(any())).called(1);

      expect(result.isError(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<Fail>());
      expect(result.fold((s) => s, (f) => f), equals(fail));
    });
    test("calls repository with the same month passed by parameter", () async {
      final month = DateTime.now();
      when(() => repository.getOf(any()))
          .thenAnswer((_) async => Success(transactions));

      final result = await usecase(month);

      verify(() => repository.getOf(month)).called(1);

      expect(result.isSuccess(), isTrue);
    });
  });
}
