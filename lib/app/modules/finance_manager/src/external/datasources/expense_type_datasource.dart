import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/expense_type.dart';

import '../../infra/datasources/expense_type_datasource.dart';

class TemporaryExpenseTypeDatasource implements ExpenseTypeDatasource {
  @override
  Future<List<ExpenseType>> getAll() async {
    return Future.value([
      const ExpenseType(
        id: 1,
        name: 'Contas',
        icon: 'icons/conta.png',
      ),
      const ExpenseType(
        id: 2,
        name: 'Vestimenta',
        icon: 'icons/vestimenta.png',
      ),
      const ExpenseType(
        id: 3,
        name: 'Cosméticos',
        icon: 'icons/cosmeticos.png',
      ),
      const ExpenseType(
        id: 4,
        name: 'Transporte',
        icon: 'icons/transporte.png',
      ),
      const ExpenseType(
        id: 5,
        name: 'Comida',
        icon: 'icons/alimentacao.png',
      ),
      const ExpenseType(
        id: 6,
        name: 'Estudo',
        icon: 'icons/estudo.png',
      ),
      const ExpenseType(
        id: 7,
        name: 'Festas',
        icon: 'icons/comemoracao.png',
      ),
      const ExpenseType(id: 8, name: 'Moradia', icon: 'icons/moradia.png'),
      const ExpenseType(id: 9, name: 'Saúde', icon: 'icons/saude.png'),
      const ExpenseType(id: 10, name: 'Reparos', icon: 'icons/reparos.png'),
      const ExpenseType(id: 11, name: 'Outros', icon: 'icons/outros.png'),
    ]);
  }
}
