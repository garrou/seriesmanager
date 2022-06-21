import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/snackbar.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/nav.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/network_image.dart';

class SearchBanner extends SearchDelegate {
  final SearchService _searchService = SearchService();

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
            crossAxisCount: width < 400
                ? 1
                : width < 600
                    ? 2
                    : width < 900
                        ? 3
                        : 4,
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
      pushAndRemove(context, const UserNav(initial: 2));
      snackBar(context, response.message());
    } else {
      snackBar(context, response.message(), Colors.red);
    }
  }
}
