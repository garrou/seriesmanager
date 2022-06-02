import 'package:flutter/material.dart';
import 'package:seriesmanager/models/api_season.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/error.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/season_card.dart';

class AddSeasonPage extends StatefulWidget {
  final UserSeries series;
  const AddSeasonPage({Key? key, required this.series}) : super(key: key);

  @override
  State<AddSeasonPage> createState() => _AddSeasonPageState();
}

class _AddSeasonPageState extends State<AddSeasonPage> {
  late Future<List<ApiSeason>> _seasons;

  @override
  void initState() {
    super.initState();
    _seasons = _load();
  }

  Future<List<ApiSeason>> _load() async {
    HttpResponse response =
        await SearchService().getSeasonsBySeriesId(widget.series.id);

    if (response.success()) {
      return createApiSeasons(response.content()?['seasons']);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saisons', style: textStyle),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<ApiSeason>>(
        future: _seasons,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              crossAxisCount: MediaQuery.of(context).size.width < 400
                  ? 1
                  : MediaQuery.of(context).size.width < 600
                      ? 2
                      : 3,
              children: <Widget>[
                for (ApiSeason season in snapshot.data!)
                  AppSeasonCard(season: season)
              ],
            );
          }
          return const AppLoading();
        },
      ),
    );
  }
}
