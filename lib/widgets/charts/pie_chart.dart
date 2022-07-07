import 'package:flutter/material.dart';
import 'package:seriesmanager/models/user_stat.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppPieChart extends StatelessWidget {
  final String title;
  final List<UserStat> stats;
  const AppPieChart({Key? key, required this.title, required this.stats})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SfCircularChart(
        title: ChartTitle(text: title),
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries<UserStat, dynamic>>[
          PieSeries<UserStat, dynamic>(
            dataSource: stats,
            xValueMapper: (UserStat stat, _) => stat.label,
            yValueMapper: (UserStat stat, _) => stat.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
          )
        ],
      );
}
