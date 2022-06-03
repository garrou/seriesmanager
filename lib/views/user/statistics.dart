import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/widgets/drawer.dart';

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
          title: Text('Mes statistiques', style: textStyle),
        ),
        drawer: const AppDrawer(),
      );
}
