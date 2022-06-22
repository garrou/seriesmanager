import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/search/search.dart';
import 'package:seriesmanager/views/user/series/series_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/series_card.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  final StreamController<bool> _streamController = StreamController();

  @override
  void initState() {
    Guard.checkAuth(_streamController);
    super.initState();
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
          onPressed: () => push(context, const SearchPage()),
          child: const Icon(Icons.add_outlined),
          backgroundColor: Colors.black,
        ),
        body: AuthGuard(
          authStream: _streamController.stream,
          signedIn: const AllUserSeries(),
          signedOut: const LoginPage(),
        ),
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
              controller: ScrollController(),
              crossAxisCount: width < 400
                  ? 1
                  : width < 600
                      ? 2
                      : width < 900
                          ? 3
                          : 4,
              children: <Widget>[
                for (UserSeries series in snapshot.data!)
                  GestureDetector(
                    onTap: () => push(
                      context,
                      SeriesDetailsPage(series: series),
                    ),
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
                              ? Image.network(
                                  series.poster,
                                  semanticLabel: 'Image de la série',
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    return loadingProgress == null
                                        ? child
                                        : Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.grey,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(
                                                Colors.black,
                                              ),
                                              value: loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!,
                                            ),
                                          );
                                  },
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
      );
}

class SearchUserSeries extends SearchDelegate {
  final SeriesService _seriesService = SeriesService();

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
                  image: series.poster,
                  onTap: () => push(
                    context,
                    SeriesDetailsPage(series: series),
                  ),
                )
            ],
          );
        }
        return const AppLoading();
      });

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
