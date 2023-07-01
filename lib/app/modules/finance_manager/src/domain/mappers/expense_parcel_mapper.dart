import '../../external/schemas/expense_parcel_table.dart';
import '../../utils/extensions.dart';
import '../entities/expense_parcel.dart';
import 'expense_mapper.dart';
import 'payment_method_mapper.dart';

abstract class ExpenseParcelMapper {
  static Map<String, dynamic> toMap(
    ExpenseParcel parcel, {
    int? installmentId,
  }) =>
      <String, dynamic>{
        ExpenseParcelTable.id: parcel.id,
        ExpenseParcelTable.paidValue: parcel.paidValue,
        ExpenseParcelTable.parcelValue: parcel.parcelValue,
        ExpenseParcelTable.paymentDate: parcel.paymentDate.date,
        ExpenseParcelTable.remainingValue: parcel.remainingValue,
        ExpenseParcelTable.expirationDate: parcel.expirationDate.date,
        ExpenseParcelTable.expenseId: parcel.expense.id,
        ExpenseParcelTable.paymentMethodId: parcel.paymentMethod.id,
        ExpenseParcelTable.installmentId: installmentId,
      };

  static ExpenseParcel fromMap(Map<String, dynamic> map) => ExpenseParcel(
        expense: ExpenseMapper.fromMap(map),
        expirationDate:
            DateTime.parse(map[ExpenseParcelTable.expirationDate] as String),
        paymentMethod: PaymentMethodMapper.fromMap(map),
        id: map[ExpenseParcelTable.id] as int,
        paidValue: map[ExpenseParcelTable.paidValue] as double,
        remainingValue: map[ExpenseParcelTable.remainingValue] as double,
        paymentDate:
            DateTime.parse(map[ExpenseParcelTable.paymentDate] as String),
        parcelValue: map[ExpenseParcelTable.parcelValue] as double,
      );
}
