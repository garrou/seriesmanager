import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/error.dart';
import 'package:seriesmanager/views/user/series/add/search.dart';
import 'package:seriesmanager/views/user/series/series_details.dart';
import 'package:seriesmanager/widgets/drawer.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';
import 'package:seriesmanager/widgets/series_card.dart';
import 'package:seriesmanager/widgets/textfield.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Mes séries', style: textStyle),
            actions: [
              IconButton(
                onPressed: () => push(context, const SearchPage()),
                icon: const Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ]),
        drawer: const AppDrawer(),
        body: const Layout(),
      );
}

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final _seriesService = SeriesService();
  final _title = TextEditingController();
  late String title;

  Future<List<UserSeries>> _loadSeries(String name) async {
    final HttpResponse response = name.isEmpty
        ? await _seriesService.getAll()
        : await _seriesService.getByTitle(title);

    if (response.success()) {
      return createUserSeries(response.content());
    } else {
      throw Exception();
    }
  }

  _LayoutState() {
    _title.addListener(() {
      if (_title.text.isEmpty) {
        setState(() => title = '');
      } else {
        setState(() => title = _title.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          AppResponsiveLayout(
            mobileLayout: _buildMobileLayout(),
            desktopLayout: _buildDesktopLayout(),
          ),
          FutureBuilder<List<UserSeries>>(
            future: _loadSeries(_title.text),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              } else if (snapshot.hasData) {
                final width = MediaQuery.of(context).size.width;

                return Expanded(
                  child: GridView.count(
                    crossAxisCount: width < 400
                        ? 1
                        : width < 600
                            ? 2
                            : width < 900
                                ? 3
                                : 4,
                    children: <Widget>[
                      for (UserSeries series in snapshot.data!)
                        AppSeriesCard(
                          series: series,
                          onTap: () => push(
                            context,
                            SeriesDetailsPage(series: series),
                          ),
                        ),
                    ],
                  ),
                );
              }
              return const AppLoading();
            },
          )
        ],
      );

  Widget _buildMobileLayout() => AppTextField(
        keyboardType: TextInputType.text,
        label: 'Nom de la série',
        textfieldController: _title,
        icon: const Icon(Icons.search_outlined, color: Colors.black),
      );

  Widget _buildDesktopLayout() => Padding(
        child: _buildMobileLayout(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
        ),
      );
}
