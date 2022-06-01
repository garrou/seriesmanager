import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/search_preview_series.dart';
import 'package:seriesmanager/models/search_details_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/error.dart';
import 'package:seriesmanager/widgets/button.dart';
import 'package:seriesmanager/widgets/loading.dart';

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
            return SeriesDetails(series: snapshot.data!);
          }
          return const AppLoading();
        },
      ),
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
      child: ListView(children: <Widget>[
        Align(
          child: AppButton(content: 'Ajouter', onPressed: () {}),
          alignment: Alignment.topRight,
        ),
        Image.network(
          series.images['poster'] ?? series.images['box'],
          height: 300,
        ),
        Text(
          series.description,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Durée d'un épisode : ${series.length} minutes",
            style: textStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "Nombre d'épisodes : ${series.episodes}",
            style: textStyle,
          ),
        ),
        Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <TableCell>[
                TableCell(
                  child: Text(
                    "Minutes",
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                TableCell(
                  child: Text(
                    "Heures",
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                TableCell(
                  child: Text(
                    "Jours",
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            TableRow(
              children: <TableCell>[
                TableCell(
                  child: Text(
                    '${series.totalMinutes()}',
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                TableCell(
                  child: Text(
                    '${series.totalHours()}',
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                TableCell(
                  child: Text(
                    series.totalDays().toStringAsFixed(2),
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
        for (dynamic value in series.kinds.values)
          Text(
            value,
            style: textStyle,
          )
      ]),
    );
  }
}
