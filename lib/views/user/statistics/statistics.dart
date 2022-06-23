import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/stat.dart';
import 'package:seriesmanager/services/stats_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final StatsService _statsService = StatsService();

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final StreamController<bool> _streamController = StreamController();

  @override
  void initState() {
    Guard.checkAuth(_streamController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Statistiques', style: textStyle),
      ),
      body: AuthGuard(
        loading: const AppLoading(),
        authStream: _streamController.stream,
        signedOut: const LoginPage(),
        signedIn: SingleChildScrollView(
          child: GridView.count(
            shrinkWrap: true,
            controller: ScrollController(),
            crossAxisCount: width < 600
                ? 1
                : width < 900
                    ? 2
                    : 3,
            children: const <Widget>[
              Total(),
              CurrentMonth(),
              SeriesAddedYears(),
              NbSeasonsByYears(),
              NbEpisodesByYears(),
              NbSeasonsByMonths(),
              TimeSeasonsByYears(),
            ],
          ),
        ),
      ),
    );
  }
}

class Total extends StatefulWidget {
  const Total({Key? key}) : super(key: key);

  @override
  State<Total> createState() => _TotalState();
}

class _TotalState extends State<Total> {
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
                  title: Text('Total des séries', style: textStyle),
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

class CurrentMonth extends StatefulWidget {
  const CurrentMonth({Key? key}) : super(key: key);

  @override
  State<CurrentMonth> createState() => _CurrentMonthState();
}

class _CurrentMonthState extends State<CurrentMonth> {
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
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: Text('Ce mois', style: textStyle),
                ),
                CardTime(mins: mins),
              ],
            );
          }
          return const AppLoading();
        },
      );
}

class SeriesAddedYears extends StatefulWidget {
  const SeriesAddedYears({Key? key}) : super(key: key);

  @override
  State<SeriesAddedYears> createState() => _SeriesAddedYearsState();
}

class _SeriesAddedYearsState extends State<SeriesAddedYears> {
  late Future<List<Stat>> _series;

  Future<List<Stat>> _loadAddedSeries() async {
    HttpResponse response = await _statsService.getAddedSeriesByYears();

    if (response.success()) {
      return createStats(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _series = _loadAddedSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Stat>>(
        future: _series,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: SfCircularChart(
                title: ChartTitle(text: 'Séries ajoutées par années'),
                legend: Legend(
                    isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                series: <CircularSeries<Stat, dynamic>>[
                  PieSeries<Stat, dynamic>(
                    dataSource: snapshot.data!,
                    xValueMapper: (Stat stat, _) => stat.label,
                    yValueMapper: (Stat stat, _) => stat.value,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    enableTooltip: true,
                  )
                ],
              ),
            );
          }
          return const AppLoading();
        },
      );
}

class NbSeasonsByYears extends StatefulWidget {
  const NbSeasonsByYears({Key? key}) : super(key: key);

  @override
  State<NbSeasonsByYears> createState() => _NbSeasonsByYearsState();
}

class _NbSeasonsByYearsState extends State<NbSeasonsByYears> {
  late Future<List<Stat>> _stats;

  Future<List<Stat>> _load() async {
    final HttpResponse response = await _statsService.getNbSeasonsByYears();

    if (response.success()) {
      return createStats(response.content());
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
  Widget build(BuildContext context) => FutureBuilder<List<Stat>>(
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
                series: <ChartSeries<Stat, dynamic>>[
                  BarSeries<Stat, dynamic>(
                    color: Colors.red,
                    dataSource: snapshot.data!,
                    xValueMapper: (Stat stat, _) => stat.label,
                    yValueMapper: (Stat stat, _) => stat.value,
                  )
                ],
              ),
            );
          }
          return const AppLoading();
        },
      );
}

class NbEpisodesByYears extends StatefulWidget {
  const NbEpisodesByYears({Key? key}) : super(key: key);

  @override
  State<NbEpisodesByYears> createState() => _NbEpisodesByYearsState();
}

class _NbEpisodesByYearsState extends State<NbEpisodesByYears> {
  late Future<List<Stat>> _stats;

  Future<List<Stat>> _load() async {
    final HttpResponse response = await _statsService.getNbEpisodesByYear();

    if (response.success()) {
      return createStats(response.content());
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
  Widget build(BuildContext context) => FutureBuilder<List<Stat>>(
        future: _stats,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Episodes par années'),
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries<Stat, dynamic>>[
                  BarSeries<Stat, dynamic>(
                    color: Colors.green,
                    dataSource: snapshot.data!,
                    xValueMapper: (Stat stat, _) => stat.label,
                    yValueMapper: (Stat stat, _) => stat.value,
                  )
                ],
              ),
            );
          }
          return const AppLoading();
        },
      );
}

class TimeSeasonsByYears extends StatefulWidget {
  const TimeSeasonsByYears({Key? key}) : super(key: key);

  @override
  State<TimeSeasonsByYears> createState() => _TimeSeasonsByYearsState();
}

class _TimeSeasonsByYearsState extends State<TimeSeasonsByYears> {
  late Future<List<Stat>> _stats;

  Future<List<Stat>> _load() async {
    final HttpResponse response = await _statsService.getTimeSeasonsByYear();

    if (response.success()) {
      return createStats(response.content());
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
  Widget build(BuildContext context) => FutureBuilder<List<Stat>>(
        future: _stats,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Heures par années'),
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries<Stat, dynamic>>[
                  AreaSeries<Stat, dynamic>(
                    color: Colors.orange,
                    dataSource: snapshot.data!,
                    xValueMapper: (Stat stat, _) => stat.label,
                    yValueMapper: (Stat stat, _) =>
                        Time.minsToHours(stat.value),
                    markerSettings: const MarkerSettings(isVisible: true),
                  )
                ],
              ),
            );
          }
          return const AppLoading();
        },
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

class NbSeasonsByMonths extends StatefulWidget {
  const NbSeasonsByMonths({Key? key}) : super(key: key);

  @override
  State<NbSeasonsByMonths> createState() => _NbSeasonsByMonthsState();
}

class _NbSeasonsByMonthsState extends State<NbSeasonsByMonths> {
  late Future<List<Stat>> _stats;

  Future<List<Stat>> _load() async {
    final HttpResponse response = await _statsService.getNbSeasonsByMonths();

    if (response.success()) {
      return createStats(response.content());
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
  Widget build(BuildContext context) => FutureBuilder<List<Stat>>(
        future: _stats,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Saisons par mois'),
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries<Stat, dynamic>>[
                  BarSeries<Stat, dynamic>(
                    color: Colors.purple,
                    dataSource: snapshot.data!,
                    xValueMapper: (Stat stat, _) => stat.label,
                    yValueMapper: (Stat stat, _) => stat.value,
                  )
                ],
              ),
            );
          }
          return const AppLoading();
        },
      );
}
