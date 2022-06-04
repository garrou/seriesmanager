import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/series/search/search.dart';
import 'package:seriesmanager/views/user/series/series_details.dart';
import 'package:seriesmanager/views/drawer/drawer.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/series_card.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Mes séries', style: textStyle),
          actions: [
            IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: SearchUserSeries()),
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () => push(context, const SearchPage()),
              icon: const Icon(
                Icons.add_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: const AllUserSeries(),
      );
}

class AllUserSeries extends StatefulWidget {
  const AllUserSeries({Key? key}) : super(key: key);

  @override
  State<AllUserSeries> createState() => _AllUserSeriesState();
}

class _AllUserSeriesState extends State<AllUserSeries> {
  final _seriesService = SeriesService();
  late Future<List<UserSeries>> _series;

  @override
  void initState() {
    _series = _loadSeries();
    super.initState();
  }

  Future<List<UserSeries>> _loadSeries() async {
    final HttpResponse response = await _seriesService.getAll();

    if (response.success()) {
      return createUserSeries(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<UserSeries>>(
        future: _series,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            final width = MediaQuery.of(context).size.width;

            return GridView.count(
              crossAxisCount: width < 400
                  ? 1
                  : width < 600
                      ? 2
                      : width < 900
                          ? 3
                          : 4,
              children: <Widget>[
                for (UserSeries series in snapshot.data!)
                  AppSeriesCard(
                    series: series,
                    onTap: () => push(
                      context,
                      SeriesDetailsPage(series: series),
                    ),
                  ),
              ],
            );
          }
          return const AppLoading();
        },
      );
}

class SearchUserSeries extends SearchDelegate {
  final SeriesService _seriesService = SeriesService();

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => query = "",
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => FutureBuilder<List<UserSeries>>(
      future: _seriesService.getByTitle(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        } else if (snapshot.hasData) {
          final width = MediaQuery.of(context).size.width;

          return Expanded(
            child: GridView.count(
              crossAxisCount: width < 400
                  ? 1
                  : width < 600
                      ? 2
                      : width < 900
                          ? 3
                          : 4,
              children: <Widget>[
                for (UserSeries series in snapshot.data!)
                  AppSeriesCard(
                    series: series,
                    onTap: () => push(
                      context,
                      SeriesDetailsPage(series: series),
                    ),
                  ),
              ],
            ),
          );
        }
        return const AppLoading();
      });

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
