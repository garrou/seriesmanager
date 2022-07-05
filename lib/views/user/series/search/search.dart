import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:seriesmanager/models/api_details_series.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/gridview.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/series/search/search_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/series_card.dart';

final _searchService = SearchService();

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<ApiDetailsSeries>> _discoverSeries;
  final StreamController<bool> _streamController = StreamController();

  @override
  void initState() {
    Guard.checkAuth(_streamController);
    _discoverSeries = _loadDiscover();
    super.initState();
  }

  Future<List<ApiDetailsSeries>> _loadDiscover() async {
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
              onPressed: () =>
                  showSearch(context: context, delegate: SearchSeries()),
            )
          ],
        ),
        body: AuthGuard(
          authStream: _streamController.stream,
          signedOut: const LoginPage(),
          signedIn: FutureBuilder<List<ApiDetailsSeries>>(
            future: _discoverSeries,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              } else if (snapshot.hasData) {
                final width = MediaQuery.of(context).size.width;

                return GridView.count(
                  controller: ScrollController(),
                  crossAxisCount: getNbEltExpandedByWidth(width),
                  children: <Widget>[
                    for (ApiDetailsSeries series in snapshot.data!)
                      AppSeriesCard(
                        image: series.getImage(),
                        series: series,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SearchDetailsPage(series: series))),
                      ),
                  ],
                );
              }
              return const AppLoading();
            },
          ),
        ),
      );
}

class SearchSeries extends SearchDelegate {
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
      FutureBuilder<List<ApiDetailsSeries>>(
        future: _searchService.getSeriesByName(query),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            final width = MediaQuery.of(context).size.width;

            return GridView.count(
              controller: ScrollController(),
              crossAxisCount: getNbEltExpandedByWidth(width),
              children: <Widget>[
                for (ApiDetailsSeries series in snapshot.data!)
                  AppSeriesCard(
                    series: series,
                    image: series.getImage(),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SearchDetailsPage(series: series))),
                  ),
              ],
            );
          }
          return const AppLoading();
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
