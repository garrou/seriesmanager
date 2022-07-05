import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seriesmanager/models/api_details_series.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/widgets/network_image.dart';
import 'package:seriesmanager/widgets/snackbar.dart';
import 'package:seriesmanager/utils/time.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';

class SearchDetailsPage extends StatelessWidget {
  final ApiDetailsSeries series;
  const SearchDetailsPage({Key? key, required this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(series.title, style: textStyle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSeries(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add_outlined),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: AppResponsiveLayout(
          mobileLayout: MobileLayout(series: series),
          desktopLayout: DesktopLayout(series: series),
        ),
      ));

  void _addSeries(BuildContext context) async {
    HttpResponse response = await SeriesService().add(
      UserSeries(series.id, series.title, series.getImage(), series.length),
    );

    if (response.success()) {
      Navigator.pop(context);
    }
    snackBar(
      context,
      response.message(),
      response.success() ? Colors.black : Colors.red,
    );
  }
}

class DesktopLayout extends StatelessWidget {
  final ApiDetailsSeries series;
  const DesktopLayout({Key? key, required this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12,
        ),
        child: MobileLayout(series: series),
      );
}

class MobileLayout extends StatefulWidget {
  final ApiDetailsSeries series;
  const MobileLayout({Key? key, required this.series}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  bool _isVisibleKind = false;
  bool _isVisibleSeasons = false;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 10,
              child: Column(children: [
                ImageContainer(image: widget.series.images['show']),
                Padding(
                  child: Text(
                    widget.series.description,
                    style: textStyle,
                    textAlign: TextAlign.start,
                  ),
                  padding: const EdgeInsets.all(10),
                ),
              ]),
            ),
            Card(
              elevation: 10,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      widget.series.ended
                          ? Icons.check_outlined
                          : Icons.movie_outlined,
                      color: widget.series.ended ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      widget.series.ended ? "Terminée" : "En cours",
                      style: textStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.rate_review_outlined),
                    title: RatingBarIndicator(
                      rating: widget.series.mean,
                      itemCount: 5,
                      itemSize: iconSize,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.create_outlined),
                    title: Text('Création : ${widget.series.creation}',
                        style: textStyle),
                  ),
                  ListTile(
                    leading: const Icon(Icons.movie_outlined),
                    title: Text('Saisons : ${widget.series.seasons.length}',
                        style: textStyle),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_alt_outlined),
                    title: Text('Episodes : ${widget.series.episodes}',
                        style: textStyle),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      "Durée d'un épisode : ${widget.series.length} minutes",
                      style: textStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      'Durée total : ${Time.minsToStringHours(widget.series.length * int.parse(widget.series.episodes))}',
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 10,
              child: Column(children: [
                InkWell(
                  onTap: () {
                    setState(() => _isVisibleKind = !_isVisibleKind);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.movie_outlined),
                    title: Text('Genres', style: textStyle),
                    trailing: _isVisibleKind
                        ? const Icon(Icons.arrow_upward_outlined)
                        : const Icon(Icons.arrow_downward_outlined),
                  ),
                ),
                Visibility(
                  visible: _isVisibleKind,
                  child: Column(
                    children: <Widget>[
                      for (String kind in widget.series.kinds.values)
                        ListTile(
                          title: Text(
                            kind,
                            style: textStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() => _isVisibleSeasons = !_isVisibleSeasons);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.list_alt_outlined),
                    title: Text('Saisons et épisodes', style: textStyle),
                    trailing: _isVisibleSeasons
                        ? const Icon(Icons.arrow_upward_outlined)
                        : const Icon(Icons.arrow_downward_outlined),
                  ),
                ),
                Visibility(
                  visible: _isVisibleSeasons,
                  child: Column(
                    children: [
                      for (Map<String, dynamic> season in widget.series.seasons)
                        ListTile(
                          title: Text(
                            'Saison : ${season['number']}',
                            style: textStyle,
                          ),
                          subtitle: Text(
                            'Episodes : ${season['episodes']}',
                            style: textStyle,
                          ),
                        ),
                    ],
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: ListView(
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                children: [
                  for (dynamic platform in widget.series.platforms)
                    PlatformCard(platform: platform['logo'])
                ],
              ),
            )
          ],
        ),
      );
}

class ImageContainer extends StatelessWidget {
  final String image;
  const ImageContainer({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: image.isEmpty
              ? Container()
              : Image.network(
                  image,
                  width: MediaQuery.of(context).size.width,
                ),
        ),
      );
}

class PlatformCard extends StatelessWidget {
  final dynamic platform;
  const PlatformCard({Key? key, required this.platform}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AppNetworkImage(image: platform),
        ),
      );
}
