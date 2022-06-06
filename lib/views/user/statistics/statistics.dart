import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/user/drawer/drawer.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Statistiques', style: textStyle),
        ),
        drawer: const AppDrawer(),
      );
}
