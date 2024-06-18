import '../../../domain/models/finance_model.dart';

abstract class FilterFinanceModel<T extends FinanceModel> {
  List<T> byStatus({required List<T> models, required List<Status> status}) {
    return status.isEmpty
        ? models
        : models.where((m) => status.contains(m.status)).toList();
  }

  List<T> byRangeValue({
    required List<T> models,
    required double max,
    required double min,
  }) {
    return models
        .where((m) => m.totalValue >= min && m.totalValue <= max)
        .toList();
  }
}
