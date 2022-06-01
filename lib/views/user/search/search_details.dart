import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/search_preview_series.dart';
import 'package:seriesmanager/models/search_details_series.dart';
import 'package:seriesmanager/models/user_preview_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/error.dart';
import 'package:seriesmanager/widgets/button.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';

class SearchDetailsPage extends StatefulWidget {
  final SearchPreviewSeries series;
  const SearchDetailsPage({Key? key, required this.series}) : super(key: key);

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  late Future<SearchDetailsSeries> _series;

  @override
  void initState() {
    super.initState();
    _series = _load();
  }

  Future<SearchDetailsSeries> _load() async {
    HttpResponse response =
        await SearchService().getDetailsById(widget.series.id);

    if (response.success()) {
      return SearchDetailsSeries.fromJson(response.content()['show']);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.series.title,
          style: textStyle,
        ),
      ),
      body: FutureBuilder<SearchDetailsSeries>(
        future: _series,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return AppResponsiveLayout(
              mobileLayout: MobileLayout(series: snapshot.data!),
              desktopLayout: DesktopLayout(series: snapshot.data!),
            );
          }
          return const AppLoading();
        },
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  final SearchDetailsSeries series;
  const MobileLayout({Key? key, required this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SeriesDetails(series: series);
  }
}

class DesktopLayout extends StatelessWidget {
  final SearchDetailsSeries series;
  const DesktopLayout({Key? key, required this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 12,
      ),
      child: MobileLayout(series: series),
    );
  }
}

class SeriesDetails extends StatelessWidget {
  final SearchDetailsSeries series;
  const SeriesDetails({Key? key, required this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(
                    series.ended ? Icons.check_outlined : Icons.movie_outlined,
                    color: series.ended ? Colors.green : Colors.red,
                    size: 30,
                  ),
                  Text(
                    series.ended ? "Terminée" : "En cours",
                    style: textStyle,
                  ),
                ],
              ),
              AppButton(content: 'Ajouter', onPressed: _addSeries),
            ],
          ),
          ImageCard(
            image: series.images['show'],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            child: Text(
              series.description,
              style: textStyle,
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Episodes : ${series.episodes}",
                    style: textStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Durée d'un épisode : ${series.length} minutes",
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (dynamic kind in series.kinds.values) KindCard(kind: kind)
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (dynamic platform in series.platforms)
                  PlatformCard(platform: platform['logo'])
              ],
            ),
          )
        ],
      ),
    );
  }

  void _addSeries() async {
    HttpResponse response = await SeriesService().addSeries(
        UserPreviewSeries(series.id, series.title, series.images['poster']));

    if (response.success()) {
      // TODO: confirmation
    }
  }
}

class ImageCard extends StatelessWidget {
  final dynamic image;
  const ImageCard({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.network(
          image,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

class KindCard extends StatelessWidget {
  final dynamic kind;
  const KindCard({Key? key, required this.kind}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          kind,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class PlatformCard extends StatelessWidget {
  final dynamic platform;
  const PlatformCard({Key? key, required this.platform}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(platform),
      ),
    );
  }
}