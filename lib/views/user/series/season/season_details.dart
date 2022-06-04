import 'package:flutter/material.dart';
import 'package:seriesmanager/models/api_episode.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/styles/text.dart';
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
      ),
      body: AppResponsiveLayout(
        mobileLayout: MobileLayout(series: series, season: season),
        desktopLayout: DesktopLayout(
          series: series,
          season: season,
        ),
      ));
}

class MobileLayout extends StatelessWidget {
  final UserSeries series;
  final UserSeason season;
  const MobileLayout({Key? key, required this.series, required this.season})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        UserSeasonInfos(series: series, season: season),
        Padding(
          child:
              Text('Episodes', style: textStyle, textAlign: TextAlign.center),
          padding: const EdgeInsets.symmetric(vertical: 5),
        ),
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

class EpisodesList extends StatefulWidget {
  final UserSeries series;
  final UserSeason season;
  const EpisodesList({Key? key, required this.series, required this.season})
      : super(key: key);

  @override
  State<EpisodesList> createState() => _EpisodesListState();
}

class UserSeasonInfos extends StatefulWidget {
  final UserSeries series;
  final UserSeason season;
  const UserSeasonInfos({Key? key, required this.series, required this.season})
      : super(key: key);

  @override
  State<UserSeasonInfos> createState() => _UserSeasonInfosState();
}

class _UserSeasonInfosState extends State<UserSeasonInfos> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
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
        .getEpisodesBySeriesIdBySeason(widget.series.id, widget.season.number);

    if (response.success()) {
      return createApiEpisodes(response.content()?['episodes']);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ApiEpisode>>(
      future: _episodes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
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
                      );
                    },
                    body: ListTile(
                      title: Text(episode.code, style: textStyle),
                      subtitle: Text(episode.description, style: textStyle),
                    ),
                    isExpanded: episode.isExpanded,
                  )
              ],
            ),
          );
        }
        return const AppLoading();
      },
    );
  }
}
