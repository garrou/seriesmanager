import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/error.dart';
import 'package:seriesmanager/views/user/series/season/add_season.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: const Icon(
              Icons.list_outlined,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
      ),
      body: UserSeasons(series: widget.series),
    );
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

  @override
  void initState() {
    super.initState();
    _seasons = _load();
  }

  Future<List<UserSeason>> _load() async {
    HttpResponse response = await SeasonService().getBySid(widget.series.sid!);

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
                    season: season,
                    onTap: () {},
                  )
              ],
            );
          }
          return const AppLoading();
        },
      );
}
