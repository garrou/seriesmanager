import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:seriesmanager/models/api_season.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/season.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/snackbar.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/series/series.dart';
import 'package:seriesmanager/views/user/series/series_details.dart';
import 'package:seriesmanager/widgets/calendar.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddSeasonPage extends StatefulWidget {
  final UserSeries series;
  const AddSeasonPage({Key? key, required this.series}) : super(key: key);

  @override
  State<AddSeasonPage> createState() => _AddSeasonPageState();
}

class _AddSeasonPageState extends State<AddSeasonPage> {
  late Future<List<ApiSeason>> _seasons;

  @override
  void initState() {
    _seasons = _load();
    super.initState();
  }

  Future<List<ApiSeason>> _load() async {
    HttpResponse response =
        await SearchService().getSeasonsBySid(widget.series.sid!);

    if (response.success()) {
      return createApiSeasons(response.content()?['seasons']);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Saisons', style: textStyle),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder<List<ApiSeason>>(
          future: _seasons,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage();
            } else if (snapshot.hasData) {
              final width = MediaQuery.of(context).size.width;

              return GridView.count(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisCount: width < 400
                    ? 1
                    : width < 600
                        ? 2
                        : 4,
                children: <Widget>[
                  for (ApiSeason season in snapshot.data!)
                    ApiSeasonCard(season: season, series: widget.series)
                ],
              );
            }
            return const AppLoading();
          },
        ),
      );
}

class ApiSeasonCard extends StatefulWidget {
  final Season season;
  final UserSeries series;
  const ApiSeasonCard({Key? key, required this.season, required this.series})
      : super(key: key);

  @override
  State<ApiSeasonCard> createState() => _ApiSeasonCardState();
}

class _ApiSeasonCardState extends State<ApiSeasonCard> {
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) =>
              _seasonDialog(context, widget.season),
        ),
        child: Padding(
          child: MouseRegion(
            child: Badge(
              position: BadgePosition.topEnd(end: 15),
              badgeColor: Colors.black,
              padding: const EdgeInsets.all(5),
              badgeContent: Text(
                '${widget.season.number}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: widget.season.image.isNotEmpty
                    ? Image.network(
                        widget.season.image,
                        loadingBuilder: (context, child, loadingProgress) {
                          return loadingProgress == null
                              ? child
                              : Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                    value:
                                        loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!,
                                  ),
                                );
                        },
                      )
                    : Center(
                        child: Text(
                          'Episodes : ${widget.season.episodes}',
                          style: textStyle,
                        ),
                      ),
              ),
            ),
            cursor: SystemMouseCursors.click,
          ),
          padding: const EdgeInsets.all(10),
        ),
      );

  Widget _seasonDialog(BuildContext context, Season season) => AlertDialog(
        title: Text('Ajouter la saison ${season.number}'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView(
            children: [
              Card(
                elevation: 10,
                child: AppCalendar(
                  callback: _startSelectionChanged,
                  selectedDate: _start,
                  text: 'Début de la saison',
                ),
              ),
              Card(
                elevation: 10,
                child: AppCalendar(
                  callback: _endSelectionChanged,
                  selectedDate: _end,
                  text: 'Fin de la saison',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _addSeason,
            child: const Text(
              'Ajouter',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ],
      );

  void _startSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _start = args.value;
  }

  void _endSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _end = args.value;
  }

  void _addSeason() async {
    if (_start.isAfter(_end)) {
      snackBar(context, 'La date de début doit être inférieure à celle de fin',
          Colors.red);
    } else {
      final season = UserSeason(widget.season.number, widget.season.episodes,
          widget.season.image, _start, _end, widget.series.id);

      final HttpResponse response = await SeasonService().add(season);

      if (response.success()) {
        doublePush(context, const SeriesPage(),
            SeriesDetailsPage(series: widget.series));
      } else {
        snackBar(context, response.message(), Colors.red);
      }
    }
  }
}
