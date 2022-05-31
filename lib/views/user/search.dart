import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/searched_series.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/utils/validator.dart';
import 'package:seriesmanager/widgets/button.dart';
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
      appBar: AppBar(backgroundColor: Colors.black),
      drawer: const AppDrawer(),
      body: Column(
        children: const <Widget>[
          AppResponsiveLayout(
            mobileLayout: MobileLayout(),
            desktopLayout: DesktopLayout(),
          ),
          SeriesList(),
        ],
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchForm();
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: const MobileLayout(),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 4,
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({Key? key}) : super(key: key);

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _keyForm = GlobalKey<FormState>();
  final _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
          AppButton(
            content: 'Chercher',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class SeriesList extends StatefulWidget {
  const SeriesList({Key? key}) : super(key: key);

  @override
  State<SeriesList> createState() => _SeriesListState();
}

class _SeriesListState extends State<SeriesList> {
  late final Future<List<SearchedSeries>> _previewSeries;

  @override
  void initState() {
    super.initState();
    _previewSeries = _loadSeries();
  }

  Future<List<SearchedSeries>> _loadSeries() async {
    HttpResponse response = await SeriesService().discoverSeries();

    if (response.success()) {
      return createPreviewsSeries(response.content()["shows"]);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SearchedSeries>>(
        future: _previewSeries,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // TODO: apperror
          } else if (snapshot.hasData) {
            return Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width < 300
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
        });
  }
}
