import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_profile.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/drawer/drawer.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/profile/search_banner.dart';
import 'package:seriesmanager/widgets/loading.dart';

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
  Widget build(BuildContext context) => FutureBuilder<UserProfile>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          } else if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: Text('Bannière', style: textStyle),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => showSearch(
                      context: context,
                      delegate: SearchBanner(),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outlined),
                  title: Text("Nom d'utilisateur", style: textStyle),
                  subtitle: Text(snapshot.data!.username, style: minTextStyle),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {},
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text('Email', style: textStyle),
                  subtitle: Text(snapshot.data!.email, style: minTextStyle),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {},
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.password_outlined),
                  title: Text('Mot de passe', style: textStyle),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {},
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.timelapse_outlined),
                  title: Text('Membre depuis le', style: textStyle),
                  subtitle: Text(
                    snapshot.data!.formatJoinedAt(),
                    style: minTextStyle,
                  ),
                ),
              ],
            );
          }
          return const AppLoading();
        },
      );
}
