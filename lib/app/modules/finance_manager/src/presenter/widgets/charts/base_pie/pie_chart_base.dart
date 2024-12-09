import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'pie_chart_touch_config.dart';
import 'pie_slice_config.dart';

class PieChartBase<T> extends StatefulWidget {
  const PieChartBase({
    super.key,
    required this.data,
    required this.transform,
    required this.graphSize,
    this.centerRadius = 10,
    this.graphStartAngle = 270,
    this.slicesSpacing = 5,
    this.legendSize,
    this.buildLegend,
    this.buildTooltip,
    this.onSlicePressed,
    this.onSlicePressEnd,
  });

  final Map<T, double> data;
  final PieSliceConfig Function(
    int index,
    MapEntry<T, double>,
    bool isTouched,
  ) transform;
  final double graphSize;
  final double centerRadius;
  final double graphStartAngle;
  final double slicesSpacing;
  final void Function(int index, MapEntry<T, double>)? onSlicePressed;
  final void Function(int index, MapEntry<T, double>)? onSlicePressEnd;
  final Widget Function(MapEntry<T, double>)? buildTooltip;
  final double? legendSize;
  final Widget Function(MapEntry<T, double>)? buildLegend;

  @override
  State<PieChartBase<T>> createState() => _PieChartBaseState<T>();
}

class _PieChartBaseState<T> extends State<PieChartBase<T>> {
  int? _touchedIndex;
  Offset? _touchedOffset;

  @override
  Widget build(BuildContext context) {
    List<PieSliceConfig> slices = widget.data.entries.indexed
        .map((tuple) => widget.transform(
              tuple.$1,
              tuple.$2,
              tuple.$1 == _touchedIndex,
            ))
        .toList();

    return Column(
      children: [
        SizedBox.square(
          dimension: widget.graphSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: widget.centerRadius,
                  startDegreeOffset: widget.graphStartAngle,
                  sectionsSpace: widget.slicesSpacing,
                  pieTouchData: PieChartTouchConfig(
                    onSlicePressed: _onSlicePressed,
                    onSlicePressEnd: _onSlicePressEnd,
                  ),
                  sections: slices,
                ),
              ),
              Positioned(
                left: _resolveCoordinate(_Coordinate.x),
                top: _resolveCoordinate(_Coordinate.y),
                child: _touchedIndex == null
                    ? const SizedBox.shrink()
                    : widget.buildTooltip?.call(
                            widget.data.entries.elementAt(_touchedIndex!)) ??
                        const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        if (widget.buildLegend != null)
          SizedBox(
            width: widget.legendSize ?? widget.graphSize,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 20,
              direction: Axis.horizontal,
              children: widget.data.entries.map(widget.buildLegend!).toList(),
            ),
          ),
      ],
    );
  }

  void _onSlicePressed(FlTouchEvent event, PieTouchResponse? resp) {
    int? touched = resp?.touchedSection?.touchedSectionIndex;

    _touchedIndex = switch (touched) {
      null => null,
      int n when n < 0 || n >= widget.data.length => null,
      _ => touched
    };

    _touchedOffset = _touchedIndex == null ? null : event.localPosition;

    if (_touchedIndex != null) {
      int index = _touchedIndex!;
      widget.onSlicePressed?.call(
        index,
        widget.data.entries.elementAt(index),
      );
    }

    setState(() {});
  }

  void _onSlicePressEnd(FlTouchEvent event, PieTouchResponse? resp) {
    int oldIndex = _touchedIndex!;
    widget.onSlicePressEnd?.call(
      oldIndex,
      widget.data.entries.elementAt(oldIndex),
    );
    setState(() {
      _touchedIndex = null;
      _touchedOffset = null;
    });
  }

  double? _resolveCoordinate(_Coordinate coord) {
    if (_touchedOffset == null) return null;

    return switch (coord) {
      _Coordinate.x => _touchedOffset!.dx - 40,
      _Coordinate.y => _touchedOffset!.dy - 75,
    };
  }
}

enum _Coordinate { x, y }
