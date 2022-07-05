import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/gridview.dart';
import 'package:seriesmanager/widgets/snackbar.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/network_image.dart';

final _searchService = SearchService();

class SearchBanner extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Nom de la série';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.cancel, size: iconSize),
          onPressed: () => query = "",
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, size: iconSize),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => FutureBuilder<List<String>>(
      future: _searchService.getSeriesImagesByName(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        } else if (snapshot.hasData) {
          final width = MediaQuery.of(context).size.width;

          return GridView.count(
            controller: ScrollController(),
            crossAxisCount: getNbEltExpandedByWidth(width),
            children: <Widget>[
              for (String image in snapshot.data!)
                InkWell(
                  child: Card(
                    elevation: 10,
                    child: AppNetworkImage(image: image),
                  ),
                  onTap: () => _addImage(context, image),
                )
            ],
          );
        }
        return const AppLoading();
      });

  @override
  Widget buildSuggestions(BuildContext context) => Container();

  void _addImage(BuildContext context, String banner) async {
    HttpResponse response = await UserService().updateBanner(banner);

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
