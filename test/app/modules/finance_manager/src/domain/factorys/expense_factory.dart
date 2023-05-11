import 'package:faker/faker.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/frequency.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense.dart';
import 'expense_type_factory.dart';
import 'payment_method_factory.dart';

abstract class ExpenseFactory {
  static final Faker faker = Faker();

  static Expense generate() => Expense(
        id: faker.randomGenerator.integer(100),
        value: faker.randomGenerator.decimal(),
        personName: faker.person.firstName(),
        name: faker.lorem.word(),
        expirationDate: faker.date.dateTime(),
        type: ExpenseTypeFactory.generate(),
        paymentMethod: PaymentMethodFactory.generate(),
        frequency: frequencyFromInt(faker.randomGenerator.integer(5)),
      );
}
