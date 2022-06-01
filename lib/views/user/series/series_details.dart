import 'package:flutter/material.dart';
import 'package:seriesmanager/models/user_preview_series.dart';
import 'package:seriesmanager/styles/text.dart';

class SeriesDetailsPage extends StatefulWidget {
  final UserPreviewSeries series;
  const SeriesDetailsPage({Key? key, required this.series}) : super(key: key);

  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

class _SeriesDetailsPageState extends State<SeriesDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.series.title,
          style: textStyle,
        ),
      ),
      body: Container(),
    );
  }
}
