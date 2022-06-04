import 'package:flutter/material.dart';
import 'package:seriesmanager/models/api_series.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/series/search/search_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/series_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchService _searchService = SearchService();
  late Future<List<ApiSeries>> _discoverSeries;

  @override
  void initState() {
    _discoverSeries = _loadDiscover();
    super.initState();
  }

  Future<List<ApiSeries>> _loadDiscover() async {
    final HttpResponse response = await _searchService.discover();

    if (response.success()) {
      return createApiSeries(response.content()?["shows"]);
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
              icon: const Icon(
                Icons.search_outlined,
                size: 30,
              ),
              onPressed: () => showSearch(
                context: context,
                delegate: SearchSeries(searchService: _searchService),
              ),
            )
          ],
        ),
        body: FutureBuilder<List<ApiSeries>>(
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
                  for (ApiSeries series in snapshot.data!)
                    AppSeriesCard(
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
  Widget buildResults(BuildContext context) => FutureBuilder<List<ApiSeries>>(
      future: searchService.getSeriesByName(query),
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
                for (ApiSeries series in snapshot.data!)
                  AppSeriesCard(
                    series: series,
                    onTap: () => push(
                      context,
                      SearchDetailsPage(series: series),
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
