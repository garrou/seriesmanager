import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/gridview.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/series/search/search.dart';
import 'package:seriesmanager/views/user/series/series_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/network_image.dart';
import 'package:seriesmanager/widgets/series_card.dart';

final _seriesService = SeriesService();

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  final StreamController<bool> _streamController = StreamController();
  late Future<List<UserSeries>> _series;

  @override
  void initState() {
    Guard.checkAuth(_streamController);
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

  Future<void> _refresh() async {
    setState(() {
      _series = _loadSeries();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Mes séries', style: textStyle),
          actions: [
            IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: SearchUserSeries()),
              icon: const Icon(Icons.search_outlined, size: iconSize),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const SearchPage()));
            _refresh();
          },
          child: const Icon(Icons.add_outlined),
          backgroundColor: Colors.black,
        ),
        body: AuthGuard(
          loading: const AppLoading(),
          authStream: _streamController.stream,
          signedOut: const LoginPage(),
          signedIn: FutureBuilder<List<UserSeries>>(
            future: _series,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              } else if (snapshot.hasData) {
                final width = MediaQuery.of(context).size.width;

                return GridView.count(
                  controller: ScrollController(),
                  crossAxisCount: getNbEltExpandedByWidth(width),
                  children: <Widget>[
                    for (UserSeries series in snapshot.data!)
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SeriesDetailsPage(series: series)));
                          _refresh();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              child: series.poster.isNotEmpty
                                  ? AppNetworkImage(image: series.poster)
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(series.title, style: textStyle)
                                      ],
                                    ),
                            ),
                          ),
                        ),
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

class SearchUserSeries extends SearchDelegate {
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
  Widget buildResults(BuildContext context) => FutureBuilder<List<UserSeries>>(
      future: _seriesService.getByName(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        } else if (snapshot.hasData) {
          final width = MediaQuery.of(context).size.width;

          return GridView.count(
            controller: ScrollController(),
            crossAxisCount: getNbEltExpandedByWidth(width),
            children: <Widget>[
              for (UserSeries series in snapshot.data!)
                AppSeriesCard(
                  series: series,
                  image: series.poster,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SeriesDetailsPage(series: series))),
                )
            ],
          );
        }
        return const AppLoading();
      });

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
