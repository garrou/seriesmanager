import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:seriesmanager/models/character.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/views/user/series/details/actor_details.dart';
import 'package:seriesmanager/widgets/error.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/network_image.dart';

final _searchService = SearchService();

class SeriesCharactersPage extends StatefulWidget {
  final int sid;
  const SeriesCharactersPage({Key? key, required this.sid}) : super(key: key);

  @override
  State<SeriesCharactersPage> createState() => _SeriesCharactersPageState();
}

class _SeriesCharactersPageState extends State<SeriesCharactersPage> {
  late Future<List<Character>> _characters;

  Future<List<Character>> _loadCharacters() async {
    HttpResponse response = await _searchService.getCharactersBySid(widget.sid);

    if (response.success()) {
      return createCharacters(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _characters = _loadCharacters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Personnages', style: textStyle),
        ),
        body: FutureBuilder<List<Character>>(
          future: _characters,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const AppError();
            } else if (snapshot.hasData) {
              final width = MediaQuery.of(context).size.width;

              return GridView.count(
                controller: ScrollController(),
                crossAxisCount: getNbEltExpandedByWidth(width),
                children: <Widget>[
                  for (Character character in snapshot.data!)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Badge(
                        shape: BadgeShape.square,
                        badgeColor: Colors.black,
                        padding: const EdgeInsets.all(5),
                        position: const BadgePosition(bottom: 10),
                        badgeContent: Text(
                          character.actor,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ActorDetailsPage(character: character),
                              ),
                            ),
                            child: character.picture.isEmpty
                                ? Container()
                                : AppNetworkImage(image: character.picture),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
            return const AppLoading();
          },
        ),
      );
}
