import 'package:flutter/material.dart';
import 'package:seriesmanager/models/user_stat.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppBarChart extends StatefulWidget {
  const AppBarChart(
      {Key? key,
      required this.title,
      required this.stats,
      required this.color,
      this.isTime = false})
      : super(key: key);

  final String title;
  final List<UserStat> stats;
  final Color color;
  final bool isTime;

  @override
  State<AppBarChart> createState() => _AppBarChartState();
}

class _AppBarChartState extends State<AppBarChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
      header: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SfCartesianChart(
        title: ChartTitle(text: widget.title),
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries<UserStat, dynamic>>[
          BarSeries<UserStat, dynamic>(
            color: widget.color,
            dataSource: widget.stats,
            enableTooltip: true,
            xValueMapper: (UserStat stat, _) => stat.label,
            yValueMapper: (UserStat stat, _) =>
                widget.isTime ? Time.minsToHours(stat.value) : stat.value,
            markerSettings: const MarkerSettings(isVisible: true),
          )
        ],
      );
}
