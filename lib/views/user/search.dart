import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/searched_series.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/validator.dart';
import 'package:seriesmanager/widgets/drawer.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Chercher une série', style: textStyle),
      ),
      drawer: const AppDrawer(),
      body: const Layout(),
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final _keyForm = GlobalKey<FormState>();
  final _name = TextEditingController();
  String name = "";

  Future<List<SearchedSeries>> _loadSeries(String name) async {
    final SeriesService _seriesService = SeriesService();
    final HttpResponse response = name.isEmpty
        ? await _seriesService.discoverSeries()
        : await _seriesService.searchSeries(name);

    if (response.success()) {
      return createSearchedSeries(response.content()["shows"]);
    } else {
      throw Exception();
    }
  }

  _LayoutState() {
    _name.addListener(() {
      if (_name.text.isEmpty) {
        setState(() => name = '');
      } else {
        setState(() => name = _name.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppResponsiveLayout(
          mobileLayout: _buildMobileLayout(),
          desktopLayout: _buildDesktopLayout(),
        ),
        FutureBuilder<List<SearchedSeries>>(
            future: _loadSeries(name),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // TODO: app error
              } else if (snapshot.hasData) {
                return Expanded(
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width < 400
                        ? 1
                        : MediaQuery.of(context).size.width < 600
                            ? 2
                            : 3,
                    children: <Widget>[
                      for (SearchedSeries series in snapshot.data!)
                        AppSeriesCard(series: series),
                    ],
                  ),
                );
              }
              return const AppLoading();
            })
      ],
    );
  }

  Widget _buildMobileLayout() => _buildForm();

  Widget _buildDesktopLayout() => Padding(
        child: _buildMobileLayout(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
        ),
      );

  Form _buildForm() => Form(
        key: _keyForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppTextField(
              keyboardType: TextInputType.emailAddress,
              label: 'Nom de la série',
              textfieldController: _name,
              validator: fieldValidator,
              icon: Icons.search_outlined,
            ),
          ],
        ),
      );
}
