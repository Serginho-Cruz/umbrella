import '../../../domain/entities/category.dart';
import '../../../infra/datasources/expense_category_datasource.dart';

class TemporaryExpenseCategoryDatasource implements ExpenseCategoryDatasource {
  @override
  Future<List<Category>> getAll() async {
    return Future.value([
      const Category(
        id: '1',
        name: 'Contas',
        icon: 'conta.png',
      ),
      const Category(
        id: '2',
        name: 'Vestimenta',
        icon: 'vestimenta.png',
      ),
      const Category(
        id: '3',
        name: 'Cosméticos',
        icon: 'cosmeticos.png',
      ),
      const Category(
        id: '4',
        name: 'Transporte',
        icon: 'transporte.png',
      ),
      const Category(
        id: '5',
        name: 'Comida',
        icon: 'alimentacao.png',
      ),
      const Category(
        id: '6',
        name: 'Estudo',
        icon: 'estudo.png',
      ),
      const Category(
        id: '7',
        name: 'Festas',
        icon: 'comemoracao.png',
      ),
      const Category(id: '8', name: 'Moradia', icon: 'moradia.png'),
      const Category(id: '9', name: 'Saúde', icon: 'saude.png'),
      const Category(id: '10', name: 'Reparos', icon: 'reparos.png'),
      const Category(id: '11', name: 'Outros', icon: 'outros.png'),
    ]);
  }
}
