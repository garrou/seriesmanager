import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series_continue.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/widgets/error.dart';
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
            return const AppError();
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const UpToDate()
                : Column(
                    children: <Widget>[
                      for (UserSeriesToContinue series in snapshot.data!)
                        InkWell(
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
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(series.title, style: boldTextStyle),
                              subtitle: Text(
                                '${series.nbMissing} saison(s) à voir',
                                style: minTextStyle,
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
  Widget build(BuildContext context) => Center(
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/check.png'),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('Vous êtes à jour', style: boldTextStyle),
                ),
              ],
            ),
          ),
        ),
      );
}
