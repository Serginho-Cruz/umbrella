import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/models/status.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/sorts/sort_expenses.dart';

String adaptSortOptionName(PaiyableSortOption option) {
  return switch (option) {
    PaiyableSortOption.byName => 'Nome',
    PaiyableSortOption.byDueDate => 'Data de Vencimento',
    PaiyableSortOption.byValue => 'Valor',
  };
}

String adaptStatusName(Status status) {
  return switch (status) {
    Status.okay => 'Pago',
    Status.inTime => 'Em Tempo',
    Status.overdue => 'Vencido',
  };
}
