import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/models/user_series_continue.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
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

  @override
  void initState() {
    Guard.checkAuth(_streamController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('En cours', style: textStyle),
          backgroundColor: Colors.black,
        ),
        body: AuthGuard(
          loading: const AppLoading(),
          authStream: _streamController.stream,
          signedOut: const LoginPage(),
          signedIn: SingleChildScrollView(
            controller: ScrollController(),
            child: const AppResponsiveLayout(
              mobileLayout: MobileLayout(),
              desktopLayout: DesktopLayout(),
            ),
          ),
        ),
      );
}

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) => Padding(
        child: const MobileLayout(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8,
        ),
      );
}

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  late Future<List<UserSeriesToContinue>> _series;

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
    _series = _loadSeriesToContinue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<UserSeriesToContinue>>(
        future: _series,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? Column(
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
                  )
                : Column(
                    children: <Widget>[
                      for (UserSeriesToContinue series in snapshot.data!)
                        Card(
                          elevation: 10,
                          child: InkWell(
                            onTap: () => push(
                              context,
                              SeriesDetailsPage(
                                series: UserSeries(
                                    series.id,
                                    series.title,
                                    series.poster,
                                    series.episodeLength,
                                    series.isWatching,
                                    series.sid),
                              ),
                            ),
                            child: ListTile(
                              title: Text(series.title, style: boldTextStyle),
                              subtitle: Text(
                                  '${series.nbMissing} saison(s) à voir',
                                  style: minTextStyle),
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
