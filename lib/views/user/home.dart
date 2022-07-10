import 'package:flutter/material.dart';
import 'package:seriesmanager/views/user/continue/continue.dart';
import 'package:seriesmanager/views/user/profile/profile.dart';
import 'package:seriesmanager/views/user/series/series.dart';
import 'package:seriesmanager/views/user/statistics/statistics.dart';

class MemberHome extends StatefulWidget {
  const MemberHome({Key? key}) : super(key: key);

  @override
  State<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome> {
  int _current = 0;
  final _screens = [
    const SeriesPage(),
    const ContinuePage(),
    const StatisticsPage(),
    const ProfilePage()
  ];

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
              icon: Icon(Icons.play_arrow_outlined),
              label: 'À voir',
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
