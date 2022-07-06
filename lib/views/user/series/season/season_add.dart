import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:seriesmanager/models/api_season.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/services/season_service.dart';
import 'package:seriesmanager/styles/gridview.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/widgets/network_image.dart';
import 'package:seriesmanager/widgets/snackbar.dart';
import 'package:seriesmanager/widgets/error.dart';
import 'package:seriesmanager/widgets/date_picker.dart';
import 'package:seriesmanager/widgets/loading.dart';

final _seasonService = SeasonService();

class AddSeasonPage extends StatefulWidget {
  final UserSeries series;
  const AddSeasonPage({Key? key, required this.series}) : super(key: key);

  @override
  State<AddSeasonPage> createState() => _AddSeasonPageState();
}

class _AddSeasonPageState extends State<AddSeasonPage> {
  late Future<List<ApiSeason>> _future;
  List<ApiSeason> _seasons = [];
  final List<ApiSeason> _selected = [];

  @override
  void initState() {
    _future = _loadSeasons();
    super.initState();
  }

  Future<List<ApiSeason>> _loadSeasons() async {
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
        floatingActionButton: _selected.isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () => DatePicker.showPicker(
                  context,
                  pickerModel: CustomMonthPicker(
                    currentTime: DateTime.now(),
                    minTime: DateTime(2000),
                    maxTime: DateTime.now(),
                    locale: LocaleType.fr,
                  ),
                  onConfirm: (datetime) =>
                      _addSeasons(DateTime(datetime.year, datetime.month, 3)),
                ),
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                child: Icon(
                  Icons.add_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
        body: FutureBuilder<List<ApiSeason>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const AppError();
            } else if (snapshot.hasData) {
              final width = MediaQuery.of(context).size.width;
              _seasons = snapshot.data!;

              return GridView.count(
                controller: ScrollController(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisCount: getNbEltExpandedByWidth(width),
                children: <Widget>[
                  for (ApiSeason season in _seasons)
                    Badge(
                      position: BadgePosition.topEnd(end: 25),
                      badgeColor: Colors.black,
                      padding: const EdgeInsets.all(10),
                      badgeContent: Text(
                        '${season.number}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      child: Card(
                        color: season.isSelected ? Colors.yellow[700] : null,
                        elevation: 10,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              season.isSelected = !season.isSelected;

                              if (season.isSelected) {
                                _selected.add(season);
                              } else {
                                _selected.remove(season);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: season.image.isNotEmpty
                                ? AppNetworkImage(image: season.image)
                                : Center(
                                    child: Text(
                                      'Episodes : ${season.episodes}',
                                      style: textStyle,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                ],
              );
            }
            return const AppLoading();
          },
        ),
      );

  void _addSeasons(DateTime date) async {
    final HttpResponse response =
        await _seasonService.add(widget.series.id, _selected, date);

    if (response.success()) {
      setState(() {
        _selected.clear();
        for (var s in _seasons) {
          s.isSelected = false;
        }
      });
    }
    snackBar(
      context,
      response.message(),
      response.success() ? Colors.black : Colors.red,
    );
  }
}
