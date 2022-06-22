import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';

class WatchPage extends StatelessWidget {
  const WatchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('En cours', style: textStyle),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: const AppResponsiveLayout(
            mobileLayout: MobileLayout(),
            desktopLayout: DesktopLayout(),
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
            horizontal: MediaQuery.of(context).size.width / 8),
      );
}

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  late Future<List<SeriesToContinue>> _series;

  Future<List<SeriesToContinue>> _loadSeriesToContinue() async {
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
  Widget build(BuildContext context) => FutureBuilder<List<SeriesToContinue>>(
        future: _series,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                for (SeriesToContinue series in snapshot.data!)
                  ListTile(
                    title: Text(series.title, style: boldTextStyle),
                    subtitle: Text('${series.nbMissing} saison(s) à voir',
                        style: minTextStyle),
                  ),
              ],
            );
          }
          return const AppLoading();
        },
      );
}

class SeriesToContinue {
  final String title;
  final int nbMissing;

  SeriesToContinue(this.title, this.nbMissing);

  SeriesToContinue.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        nbMissing = json['nbMissing'];
}

List<SeriesToContinue> createSeriesToContinue(List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => SeriesToContinue.fromJson(json))
            .toList(growable: false);
