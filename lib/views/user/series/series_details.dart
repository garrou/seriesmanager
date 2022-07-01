import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_stat.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/models/user_series_info.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/gridview.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/snackbar.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/nav.dart';
import 'package:seriesmanager/views/user/series/season/season_add.dart';
import 'package:seriesmanager/views/user/series/season/season_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/season_card.dart';

final SeasonService _seasonService = SeasonService();

class SeriesDetailsPage extends StatefulWidget {
  final UserSeries series;
  const SeriesDetailsPage({Key? key, required this.series}) : super(key: key);

  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

class _SeriesDetailsPageState extends State<SeriesDetailsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.series.title,
            style: textStyle,
          ),
          actions: [
            IconButton(
              onPressed: () => _deleteDialog(context, _delete),
              icon: const Icon(Icons.delete_outlined, size: iconSize),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => push(
            context,
            AddSeasonPage(series: widget.series),
          ),
          backgroundColor: Colors.black,
          child: const Icon(Icons.add_outlined),
        ),
        body: ListView(
          controller: ScrollController(),
          children: <Widget>[
            SeasonsInfos(series: widget.series),
            SeasonsDetailsViewed(series: widget.series),
            Seasons(series: widget.series),
          ],
        ),
      );

  Future<void> _deleteDialog(BuildContext context, VoidCallback onTap) =>
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Supprimer cette série ?', style: textStyle),
              content: SvgPicture.asset(
                'assets/delete.svg',
                height: MediaQuery.of(context).size.height / 3,
              ),
              actions: <Widget>[
                Padding(
                  child: InkWell(
                    child: Text('Non', style: textStyle),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  padding: const EdgeInsets.only(right: 20),
                ),
                InkWell(
                  child: Text('Oui', style: textStyle),
                  onTap: onTap,
                )
              ],
            );
          });

  void _delete() async {
    final HttpResponse response =
        await SeriesService().deleteBySeriesId(widget.series.id);

    if (response.success()) {
      pushAndRemove(context, const UserNav(initial: 0));
    }

    snackBar(
      context,
      response.message(),
      response.success() ? Colors.black : Colors.red,
    );
  }
}

class SeasonsInfos extends StatefulWidget {
  final UserSeries series;
  const SeasonsInfos({Key? key, required this.series}) : super(key: key);

  @override
  State<SeasonsInfos> createState() => _SeasonsInfosState();
}

class _SeasonsInfosState extends State<SeasonsInfos> {
  late Future<UserSeriesInfo> _seriesInfos;

  @override
  void initState() {
    super.initState();
    _seriesInfos = _loadSeriesInfos();
  }

  Future<UserSeriesInfo> _loadSeriesInfos() async {
    HttpResponse response =
        await SeriesService().getInfosBySeriesId(widget.series.id);

    if (response.success()) {
      return UserSeriesInfo.fromJson(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<UserSeriesInfo>(
        future: _seriesInfos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return Card(
              elevation: 10,
              child: Column(
                children: <Widget>[
                  if (snapshot.data!.isValidDates())
                    ListTile(
                      leading: const Icon(Icons.calendar_month_outlined),
                      title: Text(
                          '${snapshot.data!.formatBeginAt()} - ${snapshot.data!.formatEndAt()}'),
                    ),
                  ListTile(
                    leading: const Icon(Icons.video_library_outlined),
                    title: Text('Saisons vues : ${snapshot.data!.seasons}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_alt_outlined),
                    title: Text('Episodes vus : ${snapshot.data!.episodes}'),
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
                ],
              ),
            );
          }
          return const AppLoading();
        },
      );
}

class SeasonsDetailsViewed extends StatefulWidget {
  final UserSeries series;
  const SeasonsDetailsViewed({Key? key, required this.series})
      : super(key: key);

  @override
  State<SeasonsDetailsViewed> createState() => _SeasonsDetailsViewedState();
}

class _SeasonsDetailsViewedState extends State<SeasonsDetailsViewed> {
  late Future<List<UserStat>> _details;
  bool _isVisible = false;

  @override
  void initState() {
    _details = _loadDetails();
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

  @override
  Widget build(BuildContext context) => FutureBuilder<List<UserStat>>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
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
                          ? const Icon(Icons.arrow_upward_outlined)
                          : const Icon(Icons.arrow_downward_outlined),
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
      );
}

class Seasons extends StatefulWidget {
  final UserSeries series;
  const Seasons({Key? key, required this.series}) : super(key: key);

  @override
  State<Seasons> createState() => _SeasonsState();
}

class _SeasonsState extends State<Seasons> {
  late Future<List<UserSeason>> _seasons;

  @override
  void initState() {
    super.initState();
    _seasons = _loadSeasons();
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
  Widget build(BuildContext context) => FutureBuilder<List<UserSeason>>(
        future: _seasons,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            final width = MediaQuery.of(context).size.width;

            return GridView.count(
              controller: ScrollController(),
              shrinkWrap: true,
              crossAxisCount: getNbEltExpandedByWidth(width),
              children: <Widget>[
                for (UserSeason season in snapshot.data!)
                  AppSeasonCard(
                    series: widget.series,
                    season: season,
                    onTap: () => push(
                      context,
                      SeasonDetailsPage(
                          series: widget.series, season: season.number),
                    ),
                  )
              ],
            );
          }
          return const AppLoading();
        },
      );
}
