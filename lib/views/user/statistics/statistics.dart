import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/stats_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/drawer/drawer.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Statistiques', style: textStyle),
      ),
      drawer: const AppDrawer(),
      body: GridView.count(
        crossAxisCount: width < 500 ? 1 : 2,
        children: const <Widget>[
          NbSeasonsByYear(),
          TimeSeasonsByYear(),
        ],
      ),
    );
  }
}

class NbSeasonsByYear extends StatefulWidget {
  const NbSeasonsByYear({Key? key}) : super(key: key);

  @override
  State<NbSeasonsByYear> createState() => _NbSeasonsByYearState();
}

class _NbSeasonsByYearState extends State<NbSeasonsByYear> {
  late Future<List<SeasonStat>> _stats;

  Future<List<SeasonStat>> _load() async {
    final HttpResponse response = await StatsService().getNbSeasonsByYear();

    if (response.success()) {
      return createSeasonStats(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _stats = _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SeasonStat>>(
        future: _stats,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return SfCartesianChart(
              title: ChartTitle(text: 'Saisons par années'),
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries<SeasonStat, int>>[
                BarSeries<SeasonStat, int>(
                  color: Colors.red,
                  dataSource: snapshot.data!,
                  xValueMapper: (SeasonStat stat, _) => stat.started,
                  yValueMapper: (SeasonStat stat, _) => stat.number,
                )
              ],
            );
          }
          return const AppLoading();
        },
      ),
    );
  }
}

class TimeSeasonsByYear extends StatefulWidget {
  const TimeSeasonsByYear({Key? key}) : super(key: key);

  @override
  State<TimeSeasonsByYear> createState() => _TimeSeasonsByYearState();
}

class _TimeSeasonsByYearState extends State<TimeSeasonsByYear> {
  late Future<List<SeasonStat>> _stats;

  Future<List<SeasonStat>> _load() async {
    final HttpResponse response = await StatsService().getTimeSeasonsByYear();

    if (response.success()) {
      return createSeasonStats(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _stats = _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SeasonStat>>(
        future: _stats,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return SfCartesianChart(
              title: ChartTitle(text: 'Minutes par années'),
              primaryXAxis: CategoryAxis(),
              series: <SplineSeries<SeasonStat, int>>[
                SplineSeries<SeasonStat, int>(
                  color: Colors.orange,
                  dataSource: snapshot.data!,
                  xValueMapper: (SeasonStat stat, _) => stat.started,
                  yValueMapper: (SeasonStat stat, _) => stat.number,
                )
              ],
            );
          }
          return const AppLoading();
        },
      ),
    );
  }
}

class SeasonStat {
  final int started;
  final int finished;
  final int number;

  SeasonStat.fromJson(Map<String, dynamic> json)
      : started = json['started'],
        finished = json['finished'],
        number = json['num'];
}

List<SeasonStat> createSeasonStats(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => SeasonStat.fromJson(json)).toList(growable: false);
