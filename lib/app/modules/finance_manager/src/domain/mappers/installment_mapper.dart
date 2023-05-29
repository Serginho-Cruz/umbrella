import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/credit_card_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/expense_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/mappers/payment_method_mapper.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/external/schemas/installment_table.dart';

import '../entities/expense_parcel.dart';
import '../entities/installment.dart';

abstract class InstallmentMapper {
  static Map<String, dynamic> toMap(Installment installment) =>
      <String, dynamic>{
        InstallmentTable.id: installment.id,
        InstallmentTable.totalValue: installment.totalValue,
        InstallmentTable.parcelsNumber: installment.parcelsNumber,
        InstallmentTable.actualParcel: installment.actualParcel,
        InstallmentTable.paymentMethodId: installment.paymentMethod.id,
        InstallmentTable.expenseId: installment.expense.id,
        InstallmentTable.cardId: installment.card?.id,
      };

  static Installment fromMap(
          Map<String, dynamic> map, List<ExpenseParcel> parcels) =>
      Installment(
        id: map[InstallmentTable.id] as int,
        totalValue: map[InstallmentTable.totalValue] as double,
        parcelsNumber: map[InstallmentTable.parcelsNumber] as int,
        actualParcel: map[InstallmentTable.actualParcel] as int,
        expense: ExpenseMapper.fromMap(map),
        paymentMethod: PaymentMethodMapper.fromMap(map),
        parcels: parcels,
        card: map[InstallmentTable.cardId] == null
            ? null
            : CreditCardMapper.fromMap(map),
      );
}
