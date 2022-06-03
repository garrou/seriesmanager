import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/api_series.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/error.dart';
import 'package:seriesmanager/views/user/series/search/search_details.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';
import 'package:seriesmanager/widgets/series_card.dart';
import 'package:seriesmanager/widgets/textfield.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _title = TextEditingController();
  final _searchService = SearchService();
  String name = '';

  Future<List<ApiSeries>> _loadSeries(String name) async {
    final HttpResponse response = name.isEmpty
        ? await _searchService.discover()
        : await _searchService.getSeriesByName(name);

    if (response.success()) {
      return createApiSeries(response.content()?["shows"]);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: <Widget>[
            AppResponsiveLayout(
              mobileLayout: _buildMobileLayout(),
              desktopLayout: _buildDesktopLayout(),
            ),
            FutureBuilder<List<ApiSeries>>(
              future: _loadSeries(name),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const ErrorPage();
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width < 400
                          ? 1
                          : MediaQuery.of(context).size.width < 600
                              ? 2
                              : 3,
                      children: <Widget>[
                        for (ApiSeries series in snapshot.data!)
                          AppSeriesCard(
                            series: series,
                            onTap: () => push(
                              context,
                              SearchDetailsPage(series: series),
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
        ),
      );

  Widget _buildMobileLayout() => _buildForm();

  Widget _buildDesktopLayout() => Padding(
        child: _buildMobileLayout(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
        ),
      );

  Widget _buildForm() => Row(
        children: <Widget>[
          Expanded(
            child: AppTextField(
              keyboardType: TextInputType.text,
              label: 'Nom de la série',
              textfieldController: _title,
              icon: const Icon(Icons.search_outlined, color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.search_outlined,
              size: 30,
            ),
            onPressed: () {
              setState(() => name = _title.text);
            },
          )
        ],
      );
}
