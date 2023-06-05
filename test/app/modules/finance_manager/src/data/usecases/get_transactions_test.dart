import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/itransaction_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/usecases/get_transactions_uc.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/iget_transactions.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';
import '../repositories/transaction_repository_mock.dart';
import '../../domain/factorys/transaction_factory.dart';

void main() {
  late ITransactionRepository repository;
  late IGetTransactions usecase;

  setUp(() {
    repository = TransactionRepoMock();
    usecase = GetTransactionsUC(repository);
  });

  group('GetTransaction usecase is working fine', () {
    test("Returns a List of Transactions when no errors occur", () async {
      var list = List.generate(2, (index) => TransactionFactory.generate());
      when(() => repository.getOf(any()))
          .thenAnswer((_) async => Success(list));

      final result = await usecase(2);

      verify(() => repository.getOf(any())).called(1);

      expect(result.isSuccess(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<List<Transaction>>());
      expect(result.fold((s) => s, (f) => f), equals(list));
    });
    test("Returns a Fail when some error occur", () async {
      when(() => repository.getOf(any()))
          .thenAnswer((_) async => Failure(Fail("")));

      final result = await usecase(2);

      verify(() => repository.getOf(any())).called(1);

      expect(result.isError(), isTrue);
      expect(result.fold((s) => s, (f) => f), isA<Fail>());
    });
  });
}
