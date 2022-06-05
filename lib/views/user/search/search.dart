import 'package:flutter/material.dart';
import 'package:seriesmanager/models/details_series.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/search/search_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/series_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchService _searchService = SearchService();
  late Future<List<DetailsSeries>> _discoverSeries;

  @override
  void initState() {
    _discoverSeries = _loadDiscover();
    super.initState();
  }

  Future<List<DetailsSeries>> _loadDiscover() async {
    final HttpResponse response = await _searchService.discover();

    if (response.success()) {
      return createDetailsSeries(response.content()?["shows"]);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Ajouter une série', style: textStyle),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined, size: iconSize),
              onPressed: () => showSearch(
                context: context,
                delegate: SearchSeries(searchService: _searchService),
              ),
            )
          ],
        ),
        body: FutureBuilder<List<DetailsSeries>>(
          future: _discoverSeries,
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
                  for (DetailsSeries series in snapshot.data!)
                    AppSeriesCard(
                      image: series.images['poster'],
                      series: series,
                      onTap: () => push(
                        context,
                        SearchDetailsPage(series: series),
                      ),
                    ),
                ],
              );
            }
            return const AppLoading();
          },
        ),
      );
}

class SearchSeries extends SearchDelegate {
  final SearchService searchService;

  SearchSeries({required this.searchService});

  @override
  String get searchFieldLabel => 'Nom de la série';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.cancel, size: iconSize),
          onPressed: () => query = "",
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, size: iconSize),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) =>
      FutureBuilder<List<DetailsSeries>>(
          future: searchService.getSeriesByName(query),
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
                  for (DetailsSeries series in snapshot.data!)
                    AppSeriesCard(
                      series: series,
                      image: series.images['poster'],
                      onTap: () => push(
                        context,
                        SearchDetailsPage(series: series),
                      ),
                    ),
                ],
              );
            }
            return const AppLoading();
          });

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
