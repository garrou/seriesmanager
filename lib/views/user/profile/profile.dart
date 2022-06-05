import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_profile.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/drawer/drawer.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/network_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Mon profil', style: textStyle),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined, size: iconSize),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: ListView(children: const <Widget>[
          ProfileCard(),
        ]),
        // TODO: update username
        // TODO: update banner
        // TODO: delete account
      );
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late Future<UserProfile> _profile;

  @override
  void initState() {
    _profile = _loadProfile();
    super.initState();
  }

  Future<UserProfile> _loadProfile() async {
    HttpResponse response = await UserService().getProfile();

    if (response.success()) {
      return UserProfile.fromJson(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: 10,
        child: FutureBuilder<UserProfile>(
          future: _profile,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage();
            } else if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  if (snapshot.data!.banner.isNotEmpty)
                    AppNetworkImage(image: snapshot.data!.banner),
                  ListTile(
                    leading: const Icon(Icons.person_outlined),
                    title: Text(
                      "Nom d'utilisateur : ${snapshot.data!.username}",
                      style: textStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(
                      snapshot.data!.email,
                      style: textStyle,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.timelapse_outlined),
                    title: Text(
                      'Membre depuis le ${snapshot.data!.formatJoinedAt()}',
                      style: textStyle,
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
