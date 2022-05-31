import 'package:flutter/material.dart';
import 'package:seriesmanager/widgets/drawer.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      drawer: const AppDrawer(),
      body: ListView(children: []),
    );
  }
}
