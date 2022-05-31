import 'package:flutter/material.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/user/home.dart';
import 'package:seriesmanager/views/user/profile.dart';
import 'package:seriesmanager/views/user/search.dart';
import 'package:seriesmanager/views/user/series.dart';
import 'package:seriesmanager/views/user/statistics.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://pictures.betaseries.com/fonds/show/10051_1389097.jpg",
              ),
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
            leading: const Icon(Icons.search_outlined),
            title: const Text('Chercher des séries'),
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
        ],
      ),
    );
  }
}
