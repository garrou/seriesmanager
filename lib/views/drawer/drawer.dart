import 'package:flutter/material.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/storage.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/user/home.dart';
import 'package:seriesmanager/views/user/profile/profile.dart';
import 'package:seriesmanager/views/user/search/search.dart';
import 'package:seriesmanager/views/user/series/series.dart';
import 'package:seriesmanager/views/user/statistics/statistics.dart';
import 'package:seriesmanager/widgets/network_image.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: AppNetworkImage(
                image:
                    "https://pictures.betaseries.com/fonds/original/10051_1147314.jpg",
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
