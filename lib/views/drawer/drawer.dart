import 'package:flutter/material.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/storage.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/user/home.dart';
import 'package:seriesmanager/views/user/profile/profile.dart';
import 'package:seriesmanager/views/user/search/search.dart';
import 'package:seriesmanager/views/user/series/series.dart';
import 'package:seriesmanager/views/user/statistics/statistics.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Image.network(
                "https://pictures.betaseries.com/fonds/show/10051_1389097.jpg",
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress == null
                      ? child
                      : Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                            value: loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!,
                          ),
                        );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Accueil'),
              onTap: () => push(context, const UserHomePage()),
            ),
            ListTile(
              leading: const Icon(Icons.all_inbox_outlined),
              title: const Text('Mes séries'),
              onTap: () => push(context, const SeriesPage()),
            ),
            ListTile(
              leading: const Icon(Icons.add_outlined),
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
