import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_stat.dart';
import 'package:seriesmanager/services/stats_service.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/widgets/error.dart';
import 'package:seriesmanager/widgets/charts/area_chart.dart';
import 'package:seriesmanager/widgets/charts/bar_chart.dart';
import 'package:seriesmanager/widgets/charts/pie_chart.dart';
import 'package:seriesmanager/widgets/loading.dart';

final StatsService _statsService = StatsService();

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final StreamController<bool> _streamController = StreamController();
  late Future<int> _nbSeries;
  late Future<dynamic> _totalTime;
  late Future<dynamic> _timeCurrentMonth;
  late Future<List<UserStat>> _seriesAddedYears;
  late Future<List<UserStat>> _nbSeasonsByYears;
  late Future<List<UserStat>> _nbEpisodesByYears;
  late Future<List<UserStat>> _nbSeasonsByMonths;
  late Future<List<UserStat>> _timeSeasonsByYears;

  @override
  void initState() {
    Guard.checkAuth(_streamController);
    _nbSeries = _loadTotalSeries();
    _totalTime = _loadTotalTime();
    _timeCurrentMonth = _loadTimeCurrentMonth();
    _seriesAddedYears = _loadSeriesAddedYears();
    _nbSeasonsByYears = _loadNbSeasonsByYears();
    _nbEpisodesByYears = _loadNbEpisodesByYears();
    _nbSeasonsByMonths = _loadNbSeasonsByMonths();
    _timeSeasonsByYears = _loadTimeByYears();
    super.initState();
  }

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

  Widget _statsTotal() => Card(
        elevation: 10,
        child: Column(
          children: [
            FutureBuilder<int>(
              future: _nbSeries,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const AppError();
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
            ),
            FutureBuilder<dynamic>(
              future: _totalTime,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const AppError();
                } else if (snapshot.hasData) {
                  final int mins = snapshot.data!['total'];
                  return CardTime(mins: mins);
                }
                return const AppLoading();
              },
            )
          ],
        ),
      );

  Future<dynamic> _loadTimeCurrentMonth() async {
    HttpResponse response = await _statsService.getTimeCurrentWeek();

    if (response.success()) {
      return response.content();
    } else {
      throw Exception();
    }
  }

  Widget _statsCurrentMonth() => Card(
        elevation: 10,
        child: Column(
          children: <Widget>[
            FutureBuilder<dynamic>(
              future: _timeCurrentMonth,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
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
            ),
          ],
        ),
      );

  Future<List<UserStat>> _loadSeriesAddedYears() async {
    HttpResponse response = await _statsService.getAddedSeriesByYears();

    if (response.success()) {
      return createStats(response.content());
    } else {
      throw Exception();
    }
  }

  Widget _statsSeriesAddedYears() => FutureBuilder<List<UserStat>>(
        future: _seriesAddedYears,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: AppPieChart(
                title: 'Séries ajoutées par années',
                stats: snapshot.data!,
              ),
            );
          }
          return const AppLoading();
        },
      );

  Future<List<UserStat>> _loadNbSeasonsByYears() async {
    final HttpResponse response = await _statsService.getNbSeasonsByYears();

    if (response.success()) {
      return createStats(response.content());
    } else {
      throw Exception();
    }
  }

  Widget _statsNbSeasonsByYears() => FutureBuilder<List<UserStat>>(
        future: _nbSeasonsByYears,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: AppBarChart(
                title: 'Saisons par années',
                stats: snapshot.data!,
                color: Colors.red,
              ),
            );
          }
          return const AppLoading();
        },
      );

  Future<List<UserStat>> _loadNbEpisodesByYears() async {
    final HttpResponse response = await _statsService.getNbEpisodesByYear();

    if (response.success()) {
      return createStats(response.content());
    } else {
      throw Exception();
    }
  }

  Widget _statsNbEpisodesByYears() => FutureBuilder<List<UserStat>>(
        future: _nbEpisodesByYears,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: AppBarChart(
                title: 'Episodes par années',
                stats: snapshot.data!,
                color: Colors.green,
              ),
            );
          }
          return const AppLoading();
        },
      );

  Future<List<UserStat>> _loadNbSeasonsByMonths() async {
    final HttpResponse response = await _statsService.getNbSeasonsByMonths();

    if (response.success()) {
      return createStats(response.content());
    } else {
      throw Exception();
    }
  }

  Widget _statsNbSeasonsByMonths() => FutureBuilder<List<UserStat>>(
        future: _nbSeasonsByMonths,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: AppBarChart(
                title: 'Saisons par mois',
                stats: snapshot.data!,
                color: Colors.purple,
              ),
            );
          }
          return const AppLoading();
        },
      );

  Future<List<UserStat>> _loadTimeByYears() async {
    final HttpResponse response = await _statsService.getTimeSeasonsByYear();

    if (response.success()) {
      return createStats(response.content());
    } else {
      throw Exception();
    }
  }

  Widget _statsTimeByYears() => FutureBuilder<List<UserStat>>(
        future: _timeSeasonsByYears,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: AppAreaChart(
                title: 'Heures par années',
                stats: snapshot.data!,
                color: Colors.orange,
                isTime: true,
              ),
            );
          }
          return const AppLoading();
        },
      );

  Future<void> _refresh() async {
    setState(() {
      _nbSeries = _loadTotalSeries();
      _totalTime = _loadTotalTime();
      _timeCurrentMonth = _loadTimeCurrentMonth();
      _seriesAddedYears = _loadSeriesAddedYears();
      _nbSeasonsByYears = _loadNbSeasonsByYears();
      _nbEpisodesByYears = _loadNbEpisodesByYears();
      _nbSeasonsByMonths = _loadNbSeasonsByMonths();
      _timeSeasonsByYears = _loadTimeByYears();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Statistiques', style: textStyle),
        actions: <Widget>[
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_outlined),
          )
        ],
      ),
      body: AuthGuard(
        authStream: _streamController.stream,
        signedOut: const LoginPage(),
        signedIn: SingleChildScrollView(
          controller: ScrollController(),
          child: GridView.count(
            shrinkWrap: true,
            controller: ScrollController(),
            crossAxisCount: getNbEltByWidth(width),
            children: <Widget>[
              _statsTotal(),
              _statsCurrentMonth(),
              _statsSeriesAddedYears(),
              _statsNbSeasonsByYears(),
              _statsNbEpisodesByYears(),
              _statsNbSeasonsByMonths(),
              _statsTimeByYears(),
            ],
          ),
        ),
      ),
    );
  }
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
