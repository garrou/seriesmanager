import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/stats_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/drawer/drawer.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final StatsService _statsService = StatsService();

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
        crossAxisCount: width < 500
            ? 1
            : width < 900
                ? 2
                : 3,
        children: const <Widget>[
          TotalStats(),
          CurrentStats(),
          NbSeasonsByYear(),
          TimeSeasonsByYear(),
        ],
      ),
    );
  }
}

class TotalStats extends StatefulWidget {
  const TotalStats({Key? key}) : super(key: key);

  @override
  State<TotalStats> createState() => _TotalStatsState();
}

class _TotalStatsState extends State<TotalStats> {
  late Future<int> _series;
  late Future<dynamic> _time;

  Future<int> _loadTotalSeries() async {
    HttpResponse response = await _statsService.getTotalSeries();

    if (response.success()) {
      return response.content();
    } else {
      throw Exception();
    }
  }

  Future<dynamic> _loadTotalTime() async {
    HttpResponse response = await _statsService.getTotalTime();

    if (response.success()) {
      return response.content();
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _series = _loadTotalSeries();
    _time = _loadTotalTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: 10,
        child: Column(
          children: [
            _totalSeries(),
            _totalTime(),
          ],
        ),
      );

  Widget _totalSeries() => FutureBuilder<int>(
        future: _series,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.library_books_outlined),
                  title: Text('Total', style: textStyle),
                ),
                ListTile(
                  title: Text('Séries vues', style: textStyle),
                  trailing: Text('${snapshot.data!}', style: textStyle),
                ),
              ],
            );
          }
          return const AppLoading();
        },
      );

  Widget _totalTime() => FutureBuilder<dynamic>(
        future: _time,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            final int mins = snapshot.data!['total'];
            return CardTime(mins: mins);
          }
          return const AppLoading();
        },
      );
}

class CurrentStats extends StatefulWidget {
  const CurrentStats({Key? key}) : super(key: key);

  @override
  State<CurrentStats> createState() => _CurrentStatsState();
}

class _CurrentStatsState extends State<CurrentStats> {
  late Future<dynamic> _timeWeek;

  Future<dynamic> _loadTimeWeek() async {
    HttpResponse response = await _statsService.getTimeCurrentWeek();

    if (response.success()) {
      return response.content();
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _timeWeek = _loadTimeWeek();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: 10,
        child: Column(children: <Widget>[
          _loadTime(),
        ]),
      );

  Widget _loadTime() => FutureBuilder<dynamic>(
        future: _timeWeek,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            final int mins = snapshot.data!['total'];

            return Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.weekend_outlined),
                  title: Text('Cette semaine', style: textStyle),
                ),
                CardTime(mins: mins),
              ],
            );
          }
          return const AppLoading();
        },
      );
}

class NbSeasonsByYear extends StatefulWidget {
  const NbSeasonsByYear({Key? key}) : super(key: key);

  @override
  State<NbSeasonsByYear> createState() => _NbSeasonsByYearState();
}

class _NbSeasonsByYearState extends State<NbSeasonsByYear> {
  late Future<List<SeasonStat>> _stats;

  Future<List<SeasonStat>> _load() async {
    final HttpResponse response = await _statsService.getNbSeasonsByYear();

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
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<SeasonStat>>(
          future: _stats,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage();
            } else if (snapshot.hasData) {
              return Card(
                elevation: 10,
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Saisons par années'),
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries<SeasonStat, int>>[
                    BarSeries<SeasonStat, int>(
                      onPointTap: (chart) {
                        // TODO: details
                      },
                      color: Colors.red,
                      dataSource: snapshot.data!,
                      xValueMapper: (SeasonStat stat, _) => stat.started,
                      yValueMapper: (SeasonStat stat, _) => stat.number,
                    )
                  ],
                ),
              );
            }
            return const AppLoading();
          },
        ),
      );
}

class TimeSeasonsByYear extends StatefulWidget {
  const TimeSeasonsByYear({Key? key}) : super(key: key);

  @override
  State<TimeSeasonsByYear> createState() => _TimeSeasonsByYearState();
}

class _TimeSeasonsByYearState extends State<TimeSeasonsByYear> {
  late Future<List<SeasonStat>> _stats;

  Future<List<SeasonStat>> _load() async {
    final HttpResponse response = await _statsService.getTimeSeasonsByYear();

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
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<SeasonStat>>(
          future: _stats,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage();
            } else if (snapshot.hasData) {
              return Card(
                elevation: 10,
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Minutes par années'),
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries<SeasonStat, int>>[
                    LineSeries<SeasonStat, int>(
                      color: Colors.orange,
                      dataSource: snapshot.data!,
                      xValueMapper: (SeasonStat stat, _) => stat.started,
                      yValueMapper: (SeasonStat stat, _) => stat.number,
                      width: 2,
                      markerSettings: const MarkerSettings(isVisible: true),
                    )
                  ],
                ),
              );
            }
            return const AppLoading();
          },
        ),
      );
}

class CardTime extends StatelessWidget {
  final int mins;
  const CardTime({Key? key, required this.mins}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          ListTile(
            title: Text('Minutes', style: textStyle),
            trailing: Text('$mins', style: textStyle),
          ),
          ListTile(
            title: Text('Heures', style: textStyle),
            trailing: Text(Time.minsToStringHours(mins), style: textStyle),
          ),
          ListTile(
            title: Text('Jours', style: textStyle),
            trailing: Text(Time.minsToStringDays(mins), style: textStyle),
          ),
        ],
      );
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
