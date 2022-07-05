import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series_continue.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/widgets/snackbar.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/series/series_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';

class ContinuePage extends StatefulWidget {
  const ContinuePage({Key? key}) : super(key: key);

  @override
  State<ContinuePage> createState() => _ContinuePageState();
}

class _ContinuePageState extends State<ContinuePage> {
  final StreamController<bool> _streamController = StreamController();
  late Future<List<UserSeriesToContinue>> _initSeries;

  Future<List<UserSeriesToContinue>> _loadSeriesToContinue() async {
    HttpResponse response = await SeasonService().getSeriesToContinue();

    if (response.success()) {
      return createSeriesToContinue(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    Guard.checkAuth(_streamController);
    _initSeries = _loadSeriesToContinue();
    super.initState();
  }

  void _updateWatching(int seriesId) async {
    HttpResponse response = await SeriesService().updateWatching(seriesId);

    snackBar(
      context,
      response.message(),
      response.success() ? Colors.black : Colors.red,
    );
  }

  Future _refresh() async {
    setState(() {
      _initSeries = _loadSeriesToContinue();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('En cours', style: textStyle),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_outlined),
            )
          ],
        ),
        body: AuthGuard(
          loading: const AppLoading(),
          authStream: _streamController.stream,
          signedOut: const LoginPage(),
          signedIn: SingleChildScrollView(
            controller: ScrollController(),
            child: AppResponsiveLayout(
              mobileLayout: mobileLayout(),
              desktopLayout: desktopLayout(),
            ),
          ),
        ),
      );

  Widget desktopLayout() => Padding(
        child: mobileLayout(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8,
        ),
      );

  Widget mobileLayout() => FutureBuilder<List<UserSeriesToContinue>>(
        future: _initSeries,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const UpToDate()
                : Column(
                    children: <Widget>[
                      for (UserSeriesToContinue series in snapshot.data!)
                        Card(
                          elevation: 10,
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SeriesDetailsPage(
                                    series: series.toUserSeries(),
                                  ),
                                ),
                              );
                              _refresh();
                            },
                            child: Dismissible(
                              key: Key('${series.id}'),
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.cancel_outlined),
                              ),
                              onDismissed: (direction) {
                                snapshot.data!.remove(series);
                                _updateWatching(series.id);
                              },
                              child: ListTile(
                                title: Text(series.title, style: boldTextStyle),
                                subtitle: Text(
                                  '${series.nbMissing} saison(s) à voir',
                                  style: minTextStyle,
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

class UpToDate extends StatefulWidget {
  const UpToDate({Key? key}) : super(key: key);

  @override
  State<UpToDate> createState() => _UpToDateState();
}

class _UpToDateState extends State<UpToDate> {
  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Center(
            child: Card(
              elevation: 10,
              child: SvgPicture.asset(
                'assets/up_to_date.svg',
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ),
          Padding(
            child: Text('Vous êtes à jour !', style: textStyle),
            padding: const EdgeInsets.all(10),
          ),
        ],
      );
}
