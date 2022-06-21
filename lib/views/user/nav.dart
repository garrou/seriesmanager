import 'package:flutter/material.dart';
import 'package:seriesmanager/views/user/profile/profile.dart';
import 'package:seriesmanager/views/user/series/series.dart';
import 'package:seriesmanager/views/user/statistics/statistics.dart';

class UserNav extends StatefulWidget {
  final int initial;
  const UserNav({Key? key, required this.initial}) : super(key: key);

  @override
  State<UserNav> createState() => _UserNavState();
}

class _UserNavState extends State<UserNav> {
  late int _current;
  final _screens = [
    const SeriesPage(),
    const StatisticsPage(),
    const ProfilePage()
  ];

  @override
  void initState() {
    _current = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          children: _screens,
          index: _current,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current,
          onTap: (index) => setState(() => _current = index),
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.white60,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined),
              label: 'Mes séries',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: 'Statistiques',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profil',
            ),
          ],
        ),
      );
}
