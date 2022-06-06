import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/models/user_series_info.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/snackbar.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/series/season/season_add.dart';
import 'package:seriesmanager/views/user/series/season/season_details.dart';
import 'package:seriesmanager/views/user/series/series.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/season_card.dart';

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
              onPressed: () => push(
                context,
                AddSeasonPage(series: widget.series),
              ),
              icon: const Icon(Icons.video_library_outlined, size: iconSize),
            ),
            IconButton(
              onPressed: () => alertDialog(context, _delete),
              icon: const Icon(Icons.delete_outlined, size: iconSize),
            )
          ],
        ),
        body: UserSeasons(series: widget.series),
      );

  Future<void> alertDialog(BuildContext context, VoidCallback onTap) =>
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
      pushAndRemove(context, const SeriesPage());
      snackBar(context, 'Série supprimée');
    } else {
      snackBar(context, response.message(), Colors.red);
    }
  }
}

class UserSeasons extends StatefulWidget {
  final UserSeries series;
  const UserSeasons({Key? key, required this.series}) : super(key: key);

  @override
  State<UserSeasons> createState() => _UserSeasonsState();
}

class _UserSeasonsState extends State<UserSeasons> {
  late Future<List<UserSeason>> _seasons;
  late Future<UserSeriesInfo> _seriesInfos;

  @override
  void initState() {
    super.initState();
    _seasons = _loadSeasons();
    _seriesInfos = _loadSeriesInfos();
  }

  Future<List<UserSeason>> _loadSeasons() async {
    HttpResponse response =
        await SeasonService().getBySeriesId(widget.series.id);

    if (response.success()) {
      return createUserSeasons(response.content());
    } else {
      throw Exception();
    }
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
  Widget build(BuildContext context) => ListView(
        children: <Widget>[
          FutureBuilder<UserSeriesInfo>(
            future: _seriesInfos,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              } else if (snapshot.hasData) {
                return Card(
                  elevation: 10,
                  child: Column(
                    children: <Widget>[
                      if (snapshot.data!.hasValidDate())
                        ListTile(
                          leading: const Icon(Icons.calendar_month_outlined),
                          title: Text(
                            '${snapshot.data!.formatStartedAt()} - ${snapshot.data!.formatFinishedAt()}',
                          ),
                        ),
                      ListTile(
                        leading: const Icon(Icons.video_library_outlined),
                        title: Text('Saisons vues : ${snapshot.data!.seasons}'),
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
                return const ErrorPage();
              } else if (snapshot.hasData) {
                final width = MediaQuery.of(context).size.width;

                return GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: width < 400
                      ? 1
                      : width < 600
                          ? 2
                          : width < 900
                              ? 3
                              : 4,
                  children: <Widget>[
                    for (UserSeason season in snapshot.data!)
                      AppSeasonCard(
                        series: widget.series,
                        season: season,
                        onTap: () => push(
                          context,
                          SeasonDetailsPage(
                              series: widget.series, season: season),
                        ),
                      )
                  ],
                );
              }
              return const AppLoading();
            },
          )
        ],
      );
}
