import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/stats_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/time.dart';
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
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Statistiques', style: textStyle),
      ),
      body: GridView.count(
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
  late Future<List<SeriesStat>> _series;

  Future<List<SeriesStat>> _loadAddedSeries() async {
    HttpResponse response = await _statsService.getAddedSeriesByYears();

    if (response.success()) {
      return createSeriesStats(response.content());
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
  Widget build(BuildContext context) => FutureBuilder<List<SeriesStat>>(
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
                series: <CircularSeries<dynamic, String>>[
                  PieSeries<SeriesStat, String>(
                    dataSource: snapshot.data!,
                    xValueMapper: (SeriesStat stat, _) => stat.added,
                    yValueMapper: (SeriesStat stat, _) => stat.total,
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
  late Future<List<SeasonStat>> _stats;

  Future<List<SeasonStat>> _load() async {
    final HttpResponse response = await _statsService.getNbSeasonsByYears();

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
  Widget build(BuildContext context) => FutureBuilder<List<SeasonStat>>(
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
                    color: Colors.red,
                    dataSource: snapshot.data!,
                    xValueMapper: (SeasonStat stat, _) => stat.viewedAt,
                    yValueMapper: (SeasonStat stat, _) => stat.number,
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
  late Future<List<SeasonStat>> _stats;

  Future<List<SeasonStat>> _load() async {
    final HttpResponse response = await _statsService.getNbEpisodesByYear();

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
  Widget build(BuildContext context) => FutureBuilder<List<SeasonStat>>(
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
                series: <ChartSeries<SeasonStat, int>>[
                  BarSeries<SeasonStat, int>(
                    color: Colors.green,
                    dataSource: snapshot.data!,
                    xValueMapper: (SeasonStat stat, _) => stat.viewedAt,
                    yValueMapper: (SeasonStat stat, _) => stat.number,
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
  Widget build(BuildContext context) => FutureBuilder<List<SeasonStat>>(
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
                series: <ChartSeries<SeasonStat, int>>[
                  AreaSeries<SeasonStat, int>(
                    color: Colors.orange,
                    dataSource: snapshot.data!,
                    xValueMapper: (SeasonStat stat, _) => stat.viewedAt,
                    yValueMapper: (SeasonStat stat, _) =>
                        Time.minsToHours(stat.number),
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
  late Future<List<SeasonMonthStat>> _stats;

  Future<List<SeasonMonthStat>> _load() async {
    final HttpResponse response = await _statsService.getNbSeasonsByMonths();

    if (response.success()) {
      return createSeasonMonthStats(response.content());
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
  Widget build(BuildContext context) => FutureBuilder<List<SeasonMonthStat>>(
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
                series: <ChartSeries<SeasonMonthStat, String>>[
                  BarSeries<SeasonMonthStat, String>(
                    color: Colors.purple,
                    dataSource: snapshot.data!,
                    xValueMapper: (SeasonMonthStat stat, _) => stat.month,
                    yValueMapper: (SeasonMonthStat stat, _) => stat.number,
                  )
                ],
              ),
            );
          }
          return const AppLoading();
        },
      );
}

class SeasonStat {
  final int viewedAt;
  final int number;

  SeasonStat.fromJson(Map<String, dynamic> json)
      : viewedAt = json['viewedAt'],
        number = json['num'];
}

List<SeasonStat> createSeasonStats(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => SeasonStat.fromJson(json)).toList(growable: false);

class SeasonMonthStat {
  final String month;
  final int number;

  SeasonMonthStat.fromJson(Map<String, dynamic> json)
      : month = json['month'],
        number = json['num'];
}

List<SeasonMonthStat> createSeasonMonthStats(List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => SeasonMonthStat.fromJson(json))
            .toList(growable: false);

class SeriesStat {
  final String added;
  final int total;

  SeriesStat.fromJson(Map<String, dynamic> json)
      : added = json['added'].toString(),
        total = json['total'];
}

List<SeriesStat> createSeriesStats(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => SeriesStat.fromJson(json)).toList(growable: false);
