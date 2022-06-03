import 'package:flutter/material.dart';
import 'package:seriesmanager/models/api_episode.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/styles/text.dart';

class SeasonDetailsPage extends StatelessWidget {
  final UserSeason season;
  const SeasonDetailsPage({Key? key, required this.season}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Saison ${season.number}', style: textStyle),
        ),
        body: Layout(season: season),
      );
}

class Layout extends StatefulWidget {
  final UserSeason season;
  const Layout({Key? key, required this.season}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  /*
  late Future<List<ApiEpisode>> _episodes;

  @override
  void initState() {
    _episodes = _load();
    super.initState();
  }

  Future<List<ApiEpisode>> _load() async {}
*/
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
