import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_profile.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/storage.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/error/error.dart';
import 'package:seriesmanager/views/user/home.dart';
import 'package:seriesmanager/views/user/profile/profile.dart';
import 'package:seriesmanager/views/user/search/search.dart';
import 'package:seriesmanager/views/user/series/series.dart';
import 'package:seriesmanager/views/user/statistics/statistics.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/network_image.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: FutureBuilder<UserProfile>(
                future: _profile,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const ErrorPage();
                  } else if (snapshot.hasData) {
                    return AppNetworkImage(image: snapshot.data!.banner);
                  }
                  return const AppLoading();
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Accueil'),
              onTap: () => push(context, const UserHomePage()),
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Mes séries'),
              onTap: () => push(context, const SeriesPage()),
            ),
            ListTile(
              leading: const Icon(Icons.library_add_outlined),
              title: const Text('Ajouter une série'),
              onTap: () => push(context, const SearchPage()),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Statistiques'),
              onTap: () => push(context, const StatisticsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.person_outlined),
              title: const Text('Profil'),
              onTap: () => push(context, const ProfilePage()),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Déconnexion'),
              onTap: () {
                Storage.removeToken();
                pushAndRemove(context, const LoginPage());
              },
            ),
          ],
        ),
      );
}
