import '../../../domain/entities/category.dart';
import '../../../infra/datasources/income_category_datasource.dart';

class TemporaryIncomeCategoryDatasource implements IncomeCategoryDatasource {
  @override
  Future<List<Category>> getAll() async {
    return Future.delayed(
      const Duration(seconds: 2),
      () => [
        const Category(
          id: 1,
          name: 'Contas',
          icon: 'icons/conta.png',
        ),
        const Category(
          id: 2,
          name: 'Vestimenta',
          icon: 'icons/vestimenta.png',
        ),
        const Category(
          id: 3,
          name: 'Cosméticos',
          icon: 'icons/cosmeticos.png',
        ),
        const Category(
          id: 4,
          name: 'Transporte',
          icon: 'icons/transporte.png',
        ),
        const Category(
          id: 5,
          name: 'Comida',
          icon: 'icons/alimentacao.png',
        ),
        const Category(
          id: 6,
          name: 'Estudo',
          icon: 'icons/estudo.png',
        ),
        const Category(
          id: 7,
          name: 'Festas',
          icon: 'icons/comemoracao.png',
        ),
        const Category(id: 8, name: 'Moradia', icon: 'icons/moradia.png'),
        const Category(id: 9, name: 'Saúde', icon: 'icons/saude.png'),
        const Category(id: 10, name: 'Reparos', icon: 'icons/reparos.png'),
        const Category(id: 11, name: 'Outros', icon: 'icons/outros.png'),
      ],
    );
  }
}
