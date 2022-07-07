import 'package:flutter/material.dart';
import 'package:seriesmanager/models/user_stat.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppAreaChart extends StatelessWidget {
  final String title;
  final List<UserStat> stats;
  final Color color;
  final bool isTime;
  const AppAreaChart(
      {Key? key,
      required this.title,
      required this.stats,
      required this.color,
      this.isTime = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SfCartesianChart(
        title: ChartTitle(text: title),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries<UserStat, dynamic>>[
          AreaSeries<UserStat, dynamic>(
            color: color,
            dataSource: stats,
            xValueMapper: (UserStat stat, _) => stat.label,
            yValueMapper: (UserStat stat, _) =>
                isTime ? Time.minsToHours(stat.value) : stat.value,
            markerSettings: const MarkerSettings(isVisible: true),
          )
        ],
      );
}
