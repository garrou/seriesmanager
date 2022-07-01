import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:seriesmanager/models/api_season.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/season.dart';
import 'package:seriesmanager/models/user_season.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/styles/gridview.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/snackbar.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/nav.dart';
import 'package:seriesmanager/views/user/series/series_details.dart';
import 'package:seriesmanager/widgets/date_picker.dart';
import 'package:seriesmanager/widgets/loading.dart';

class AddSeasonPage extends StatefulWidget {
  final UserSeries series;
  const AddSeasonPage({Key? key, required this.series}) : super(key: key);

  @override
  State<AddSeasonPage> createState() => _AddSeasonPageState();
}

class _AddSeasonPageState extends State<AddSeasonPage> {
  late Future<List<ApiSeason>> _seasons;
  List<ApiSeason> _seasonsLoaded = [];

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
          actions: [
            IconButton(
              onPressed: _helpDialog,
              icon: const Icon(Icons.help_outline_outlined),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => DatePicker.showPicker(
            context,
            pickerModel: CustomMonthPicker(
              currentTime: DateTime.now(),
              minTime: DateTime(2000),
              maxTime: DateTime.now(),
              locale: LocaleType.fr,
            ),
            onConfirm: (datetime) => _addAllSeasons(
              DateTime(datetime.year, datetime.month, 3),
            ),
          ),
          child: const Icon(Icons.add_outlined),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder<List<ApiSeason>>(
          future: _seasons,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage();
            } else if (snapshot.hasData) {
              final width = MediaQuery.of(context).size.width;
              _seasonsLoaded = snapshot.data!;

              return GridView.count(
                controller: ScrollController(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisCount: getNbEltExpandedByWidth(width),
                children: <Widget>[
                  for (ApiSeason season in _seasonsLoaded)
                    ApiSeasonCard(season: season, series: widget.series)
                ],
              );
            }
            return const AppLoading();
          },
        ),
      );

  Future<void> _helpDialog() => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Aide', style: textStyle),
            content: Text(
              'Pour ajouter toutes les saisons cliquez sur le bouton en bas à droite, pour ajouter une saison cliquez sur la saison concernée.',
              style: minTextStyle,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Compris', style: textStyle),
              )
            ],
          );
        },
      );

  void _addAllSeasons(DateTime date) async {
    final HttpResponse response = await SeasonService()
        .addAllSeasons(widget.series.id, _seasonsLoaded, date);

    if (response.success()) {
      pushAndRemove(context, const UserNav(initial: 0));
    }

    snackBar(
      context,
      response.message(),
      response.success() ? Colors.black : Colors.red,
    );
  }
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
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => DatePicker.showPicker(
          context,
          pickerModel: CustomMonthPicker(
            currentTime: DateTime.now(),
            maxTime: DateTime.now(),
            minTime: DateTime(2000),
            locale: LocaleType.fr,
          ),
          onConfirm: (datetime) => _addSeason(
            DateTime(datetime.year, datetime.month, 3),
          ),
        ),
        onLongPress: () {
          // TODO: mutliselect to add seasons
          // TODO : select to add
          // TODO: backend use body to put path post
          // TODO: update series name and picture
        },
        child: Padding(
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
                                  value: loadingProgress.cumulativeBytesLoaded /
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
          padding: const EdgeInsets.all(10),
        ),
      );

  void _addSeason(DateTime date) async {
    final season = UserSeason(widget.season.number, widget.season.episodes,
        widget.season.image, date, widget.series.id);

    final HttpResponse response = await SeasonService().add(season);

    if (response.success()) {
      doublePush(
        context,
        const UserNav(initial: 0),
        SeriesDetailsPage(series: widget.series),
      );
    }

    snackBar(
      context,
      response.message(),
      response.success() ? Colors.black : Colors.red,
    );
  }
}
