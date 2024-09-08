import '../../domain/entities/account.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/payment_record.dart';

abstract interface class PaymentRecordDatasource {
  Future<int> register(PaymentRecord transaction, Account account);
  Future<List<PaymentRecord>> getAllOf({
    required Account account,
    required int month,
    required int year,
  });
  Future<void> deleteAllOf(Paiyable paiyable);
}
