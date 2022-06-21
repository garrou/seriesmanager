import 'package:flutter/material.dart';
import 'package:seriesmanager/models/api_episode.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/models/user_season_info.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';

class SeasonDetailsPage extends StatelessWidget {
  final UserSeries series;
  final UserSeason season;
  const SeasonDetailsPage(
      {Key? key, required this.series, required this.season})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Saison ${season.number}', style: textStyle),
          actions: [
            IconButton(
              onPressed: () {
                // TODO : edit season
                // TODO: delete season
                // TODO: refresh
              },
              icon: const Icon(Icons.edit_outlined),
            )
          ],
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: AppResponsiveLayout(
            mobileLayout: MobileLayout(series: series, season: season),
            desktopLayout: DesktopLayout(series: series, season: season),
          ),
        ),
      );
}

class MobileLayout extends StatelessWidget {
  final UserSeries series;
  final UserSeason season;
  const MobileLayout({Key? key, required this.series, required this.season})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeasonInfos(series: series, season: season),
        EpisodesList(series: series, season: season),
      ],
    );
  }
}

class DesktopLayout extends StatelessWidget {
  final UserSeries series;
  final UserSeason season;
  const DesktopLayout({Key? key, required this.series, required this.season})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: MobileLayout(series: series, season: season),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 8,
      ),
    );
  }
}

class SeasonInfos extends StatefulWidget {
  final UserSeries series;
  final UserSeason season;
  const SeasonInfos({Key? key, required this.series, required this.season})
      : super(key: key);

  @override
  State<SeasonInfos> createState() => _SeasonInfosState();
}

class _SeasonInfosState extends State<SeasonInfos> {
  late Future<List<UserSeasonInfo>> _infos;

  Future<List<UserSeasonInfo>> _loadInfos() async {
    HttpResponse response = await SeasonService()
        .getInfosByNumberBySeriesId(widget.season.number, widget.series.id);

    if (response.success()) {
      return createUserSeasonInfo(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _infos = _loadInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: FutureBuilder<List<UserSeasonInfo>>(
        future: _infos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            final int nb = snapshot.data!.length;
            final String s = nb > 1 ? 's' : '';

            return Column(
              children: <Widget>[
                Padding(
                  child: Text('$nb visionnage$s',
                      style: boldTextStyle, textAlign: TextAlign.center),
                  padding: const EdgeInsets.only(top: 10),
                ),
                ListTile(
                  leading: const Icon(Icons.timelapse, size: 30),
                  title: Text(Time.minsToStringHours(
                      snapshot.data!.first.duration * snapshot.data!.length)),
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

class EpisodesList extends StatefulWidget {
  final UserSeries series;
  final UserSeason season;
  const EpisodesList({Key? key, required this.series, required this.season})
      : super(key: key);

  @override
  State<EpisodesList> createState() => _EpisodesListState();
}

class _EpisodesListState extends State<EpisodesList> {
  late Future<List<ApiEpisode>> _episodes;

  @override
  void initState() {
    _episodes = _load();
    super.initState();
  }

  Future<List<ApiEpisode>> _load() async {
    HttpResponse response = await SearchService()
        .getEpisodesBySidBySeason(widget.series.sid!, widget.season.number);

    if (response.success()) {
      return createApiEpisodes(response.content()?['episodes']);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          Padding(
            child: Text(
              'Episodes',
              style: boldTextStyle,
              textAlign: TextAlign.center,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          FutureBuilder<List<ApiEpisode>>(
            future: _episodes,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              } else if (snapshot.hasData) {
                return SingleChildScrollView(
                  controller: ScrollController(),
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        snapshot.data![index].isExpanded = !isExpanded;
                      });
                    },
                    children: <ExpansionPanel>[
                      for (ApiEpisode episode in snapshot.data!)
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text(episode.title, style: textStyle),
                              subtitle: Text(episode.formatDate()),
                            );
                          },
                          body: ListTile(
                            title: Text(episode.code, style: textStyle),
                            subtitle:
                                Text(episode.description, style: textStyle),
                          ),
                          isExpanded: episode.isExpanded,
                        )
                    ],
                  ),
                );
              }
              return const AppLoading();
            },
          ),
        ],
      ),
    );
  }
}
