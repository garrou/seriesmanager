import 'package:flutter/material.dart';
import 'package:seriesmanager/models/actor.dart';
import 'package:seriesmanager/models/character.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/search_service.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/widgets/error.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/network_image.dart';

final _searchService = SearchService();

class ActorDetailsPage extends StatefulWidget {
  final Character character;
  const ActorDetailsPage({Key? key, required this.character}) : super(key: key);

  @override
  State<ActorDetailsPage> createState() => _ActorDetailsPageState();
}

class _ActorDetailsPageState extends State<ActorDetailsPage> {
  late Future<Actor> _actor;
  bool _moviesVisible = false;
  bool _showsVisible = false;

  Future<Actor> _loadActorInfo() async {
    HttpResponse response =
        await _searchService.getActorInfoById(widget.character.id);

    if (response.success()) {
      return Actor.fromJson(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _actor = _loadActorInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.character.actor,
            style: textStyle,
          ),
        ),
        body: FutureBuilder<Actor>(
          future: _actor,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const AppError();
            } else if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() => _moviesVisible = !_moviesVisible);
                    },
                    child: ListTile(
                      leading: const Icon(Icons.movie_outlined),
                      title: const Text('Films'),
                      subtitle: const Text(''),
                      trailing: _moviesVisible
                          ? const Icon(Icons.arrow_drop_up_outlined)
                          : const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  Visibility(
                    visible: _moviesVisible,
                    child: Column(
                      children: <Widget>[
                        for (dynamic movie in snapshot.data!.movies)
                          Card(
                            elevation: 10,
                            child: ListTile(
                              leading: SizedBox(
                                height: 100,
                                width: 50,
                                child: AppNetworkImage(
                                    image: movie['movie']['poster']),
                              ),
                              title: Text(movie['movie']['title']),
                              subtitle: Text('${movie['movie']['production_year']}'),
                            ),
                          )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() => _showsVisible = !_showsVisible);
                    },
                    child: ListTile(
                      leading: const Icon(Icons.movie_outlined),
                      title: const Text('Séries'),
                      subtitle: const Text(''),
                      trailing: _showsVisible
                          ? const Icon(Icons.arrow_drop_up_outlined)
                          : const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  Visibility(
                    visible: _showsVisible,
                    child: Column(
                      children: <Widget>[
                        for (dynamic show in snapshot.data!.shows)
                          Card(
                            elevation: 10,
                            child: ListTile(
                              leading: SizedBox(
                                height: 100,
                                width: 50,
                                child: AppNetworkImage(
                                    image: show['show']['poster']),
                              ),
                              title: Text(show['show']['title']),
                              subtitle: Text('${show['show']['creation']}'),
                            ),
                          )
                      ],
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
