import '../../../domain/models/finance_model.dart';
import '../../../domain/models/status.dart';

abstract class FilterFinanceModel<T extends FinanceModel> {
  List<T> byStatus({required List<T> models, required List<Status> status}) =>
      status.isEmpty
          ? models
          : models.where((m) => status.contains(m.status)).toList();

  List<T> byRangeValue({
    required List<T> models,
    required double? max,
    required double min,
  }) =>
      models.where((m) {
        if (max != null) return m.totalValue >= min && m.totalValue <= max;
        return m.totalValue >= min;
      }).toList();
}
