import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/utils/round.dart';

import '../../../../domain/entities/category.dart';
import '../../../utils/currency_format.dart';
import '../../../utils/umbrella_palette.dart';
import '../../../utils/umbrella_sizes.dart';
import '../../icons/category_icon.dart';
import '../../texts/small_text.dart';
import '../charts_utils/axis_config.dart';
import '../base_column/column_chart.dart';
import '../base_column/column_config.dart';
import '../base_column/touch_tooltip_data.dart';

class CategoryColumnChart extends StatelessWidget {
  const CategoryColumnChart({
    super.key,
    required this.data,
    required this.padding,
    required this.bottomAxisName,
    required this.colors,
  });

  final Map<Category, double> data;
  final EdgeInsetsGeometry padding;
  final String bottomAxisName;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    double dataBasedWidth = data.keys.length * 60 + 100;

    return ColumnChart<Category, double>(
      data: data,
      transform: _transformCategoryData,
      width: width > dataBasedWidth ? width - 24 : dataBasedWidth,
      height: 400,
      padding: padding,
      leftAxisConfig: _getLeftAxis(),
      bottomAxisNameSize: 20,
      bottomAxisName: bottomAxisName,
      columnTitleSize: 80,
      tooltipData: _buildCategoryTooltipData(),
      buildColumnTitle: _buildCategoryTitleColumn,
    );
  }

  ColumnConfig _transformCategoryData(
    int index,
    MapEntry<Category, double> entry,
  ) =>
      ColumnConfig(
        height: entry.value.roundToDecimal(),
        width: 25.0,
        color: colors[index],
      );

  AxisConfig _getLeftAxis() => AxisConfig(
        axisNameSize: 40,
        reservedColumnSize: 80,
        axisTitleBuilder: (value, meta) {
          return SmallText(CurrencyFormat.format(value));
        },
      );

  Widget _buildCategoryTitleColumn(Category category) {
    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      child: Tooltip(
        height: 50,
        preferBelow: false,
        message: category.name,
        child: CategoryIcon(
          iconName: category.icon,
          radius: 40.0,
        ),
      ),
    );
  }

  TouchTooltipData _buildCategoryTooltipData() {
    return TouchTooltipData(
      resolveColor: (_) => UmbrellaPalette.primaryColor,
      padding: const EdgeInsets.all(10.0),
      borderRadius: 4,
      buildTooltipText: (groupData, __, columnData) {
        String value = CurrencyFormat.format(columnData.toY);
        String categoryName = data.entries.elementAt(groupData.x - 1).key.name;
        return BarTooltipItem(
          '$categoryName: $value',
          const TextStyle(
            fontSize: UmbrellaSizes.small,
            color: Colors.black,
          ),
        );
      },
    );
  }
}
