import '../../domain/entities/income_type.dart';
import '../../infra/datasources/income_type_datasource.dart';

class TemporaryIncomeTypeDatasource implements IncomeTypeDatasource {
  @override
  Future<List<IncomeType>> getAll() async {
    return Future.delayed(
      const Duration(seconds: 2),
      () => [
        const IncomeType(
          id: 1,
          name: 'Contas',
          icon: 'icons/conta.png',
        ),
        const IncomeType(
          id: 2,
          name: 'Vestimenta',
          icon: 'icons/vestimenta.png',
        ),
        const IncomeType(
          id: 3,
          name: 'Cosméticos',
          icon: 'icons/cosmeticos.png',
        ),
        const IncomeType(
          id: 4,
          name: 'Transporte',
          icon: 'icons/transporte.png',
        ),
        const IncomeType(
          id: 5,
          name: 'Comida',
          icon: 'icons/alimentacao.png',
        ),
        const IncomeType(
          id: 6,
          name: 'Estudo',
          icon: 'icons/estudo.png',
        ),
        const IncomeType(
          id: 7,
          name: 'Festas',
          icon: 'icons/comemoracao.png',
        ),
        const IncomeType(id: 8, name: 'Moradia', icon: 'icons/moradia.png'),
        const IncomeType(id: 9, name: 'Saúde', icon: 'icons/saude.png'),
        const IncomeType(id: 10, name: 'Reparos', icon: 'icons/reparos.png'),
        const IncomeType(id: 11, name: 'Outros', icon: 'icons/outros.png'),
      ],
    );
  }
}
