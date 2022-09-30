import 'package:flutter/material.dart';
import 'package:seriesmanager/models/user_stat.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppAreaChart extends StatefulWidget {
  const AppAreaChart(
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
  State<AppAreaChart> createState() => _AppAreaChartState();
}

class _AppAreaChartState extends State<AppAreaChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SfCartesianChart(
        title: ChartTitle(text: widget.title),
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries<UserStat, dynamic>>[
          AreaSeries<UserStat, dynamic>(
            enableTooltip: true,
            color: widget.color,
            dataSource: widget.stats,
            xValueMapper: (UserStat stat, _) => stat.label,
            yValueMapper: (UserStat stat, _) =>
                widget.isTime ? Time.minsToHours(stat.value) : stat.value,
            markerSettings: const MarkerSettings(isVisible: true),
          )
        ],
      );
}
