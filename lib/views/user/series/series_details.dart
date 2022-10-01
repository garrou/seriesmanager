import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_stat.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/models/user_series_info.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/widgets/snackbar.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:seriesmanager/widgets/error.dart';
import 'package:seriesmanager/views/user/series/season/season_add.dart';
import 'package:seriesmanager/views/user/series/season/season_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/season_card.dart';

final _seasonService = SeasonService();
final _seriesServices = SeriesService();

class SeriesDetailsPage extends StatefulWidget {
  final UserSeries series;
  const SeriesDetailsPage({Key? key, required this.series}) : super(key: key);

  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

class _SeriesDetailsPageState extends State<SeriesDetailsPage> {
  late Future<UserSeriesInfo> _seriesInfos;
  late Future<List<UserStat>> _details;
  late Future<List<UserSeason>> _seasons;
  bool _isVisible = false;

  @override
  void initState() {
    _seriesInfos = _loadSeriesInfos();
    _details = _loadDetails();
    _seasons = _loadSeasons();
    super.initState();
  }

  Future<List<UserStat>> _loadDetails() async {
    HttpResponse response =
        await _seasonService.getDetailsSeasonsViewed(widget.series.id);

    if (response.success()) {
      return createStats(response.content());
    } else {
      throw Exception();
    }
  }

  Future<UserSeriesInfo> _loadSeriesInfos() async {
    HttpResponse response = await _seriesServices.getInfos(widget.series.id);

    if (response.success()) {
      return UserSeriesInfo.fromJson(response.content());
    } else {
      throw Exception();
    }
  }

  Future<List<UserSeason>> _loadSeasons() async {
    HttpResponse response =
        await _seasonService.getBySeriesId(widget.series.id);

    if (response.success()) {
      return createUserSeasons(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.series.title,
            style: textStyle,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outlined, size: iconSize),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    AddSeasonPage(series: widget.series),
              ),
            );
            _refresh();
          },
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          child: Icon(
            Icons.add_outlined,
            color: Theme.of(context).backgroundColor,
          ),
        ),
        body: ListView(
          controller: ScrollController(),
          children: <Widget>[
            FutureBuilder<UserSeriesInfo>(
              future: _seriesInfos,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const AppError();
                } else if (snapshot.hasData) {
                  return Card(
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        if (snapshot.data!.hasValidDates())
                          ListTile(
                            leading: const Icon(Icons.calendar_month_outlined),
                            title: Text(
                                '${snapshot.data!.formatBeginAt()} - ${snapshot.data!.formatEndAt()}'),
                          ),
                        ListTile(
                          leading: const Icon(Icons.video_library_outlined),
                          title:
                              Text('Saisons vues : ${snapshot.data!.seasons}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.list_alt_outlined),
                          title:
                              Text('Episodes vus : ${snapshot.data!.episodes}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.timelapse_outlined),
                          title: Text(
                            Time.minsToStringHours(snapshot.data!.duration),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.timelapse_outlined),
                          title: Text(
                            Time.minsToStringDays(snapshot.data!.duration),
                          ),
                        ),
                        if (snapshot.data!.hasValidDates())
                          SwitchListTile(
                            title: const Text('Continuer la série ?'),
                            value: snapshot.data!.isWatching,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              _updateWatching(snapshot.data!.id);
                              setState(() => snapshot.data!.isWatching = value);
                            },
                          ),
                      ],
                    ),
                  );
                }
                return const AppLoading();
              },
            ),
            FutureBuilder<List<UserStat>>(
              future: _details,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const AppError();
                } else if (snapshot.hasData) {
                  return Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() => _isVisible = !_isVisible);
                          },
                          child: ListTile(
                            leading: const Icon(Icons.movie_outlined),
                            title: const Text('Détails de visionnage'),
                            trailing: _isVisible
                                ? const Icon(Icons.arrow_drop_up_outlined)
                                : const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        Visibility(
                          visible: _isVisible,
                          child: Column(
                            children: <Widget>[
                              for (UserStat details in snapshot.data!)
                                ListTile(
                                  title: Text(
                                    'Saison ${details.label}',
                                    style: smallBoldTextStyle,
                                  ),
                                  subtitle: Text('Vue ${details.value} fois'),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const AppLoading();
              },
            ),
            FutureBuilder<List<UserSeason>>(
              future: _seasons,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const AppError();
                } else if (snapshot.hasData) {
                  final width = MediaQuery.of(context).size.width;

                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: getNbEltExpandedByWidth(width),
                    children: <Widget>[
                      for (UserSeason season in snapshot.data!)
                        AppSeasonCard(
                          series: widget.series,
                          season: season,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeasonDetailsPage(
                                    series: widget.series,
                                    season: season.number),
                              ),
                            );
                            _refresh();
                          },
                        )
                    ],
                  );
                }
                return const AppLoading();
              },
            ),
          ],
        ),
      );

  void _updateWatching(int seriesId) async {
    HttpResponse response = await _seriesServices.updateWatching(seriesId);
    snackBar(context, response.message());
  }

  Future<void> _refresh() async {
    setState(() {
      _seriesInfos = _loadSeriesInfos();
      _details = _loadDetails();
      _seasons = _loadSeasons();
    });
  }

  void _delete() async {
    final HttpResponse response =
        await _seriesServices.delete(widget.series.id);

    if (response.success()) {
      Navigator.pop(context);
    }
    snackBar(context, response.message());
  }
}
