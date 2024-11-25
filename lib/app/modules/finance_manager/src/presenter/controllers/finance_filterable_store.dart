import 'package:mobx/mobx.dart';

import '../../domain/entities/category.dart';
import '../../domain/models/status.dart';
import '../../domain/usecases/sorts/sort_expenses.dart';

abstract interface class FinanceFilterableStore {
  bool get wasFiltered;

  ObservableList<Category> get filteredCategories;
  ObservableList<Status> get filteredStatus;
  ({double min, double max}) get minAndMax;
  ({double min, double max}) get filteredRangeValue;
  String get filteredName;
  PaiyableSortOption get sortOption;
  bool get isCrescentOrder;

  void toggleCategory(Category category);
  void toggleStatus(Status status);
  void setFilterName(String name);
  void setMinValueRange(double min);
  void setMaxValueRange(double max);
  void setSortOption(PaiyableSortOption? option);
  void toggleCrescentOrder();
  void clearFilters();
  void filter();
}
