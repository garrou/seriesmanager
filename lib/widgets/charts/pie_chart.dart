import 'package:flutter/material.dart';
import 'package:seriesmanager/models/user_stat.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppPieChart extends StatefulWidget {
  const AppPieChart({Key? key, required this.title, required this.stats})
      : super(key: key);

  final String title;
  final List<UserStat> stats;

  @override
  State<AppPieChart> createState() => _AppPieChartState();
}

class _AppPieChartState extends State<AppPieChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SfCircularChart(
        title: ChartTitle(text: widget.title),
        tooltipBehavior: _tooltipBehavior,
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries<UserStat, dynamic>>[
          PieSeries<UserStat, dynamic>(
            dataSource: widget.stats,
            xValueMapper: (UserStat stat, _) => stat.label,
            yValueMapper: (UserStat stat, _) => stat.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
          )
        ],
      );
}
