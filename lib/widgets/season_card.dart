import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:seriesmanager/models/season.dart';
import 'package:seriesmanager/styles/text.dart';

class AppSeasonCard extends StatefulWidget {
  final Season season;
  const AppSeasonCard({Key? key, required this.season}) : super(key: key);

  @override
  State<AppSeasonCard> createState() => _AppSeasonCardState();
}

class _AppSeasonCardState extends State<AppSeasonCard> {
  DateTime _started = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) =>
            _seasonDialog(context, widget.season),
      ),
      child: Padding(
        child: MouseRegion(
          child: Badge(
            position: BadgePosition.topEnd(end: 15),
            badgeColor: Colors.black,
            padding: const EdgeInsets.all(5),
            badgeContent: Text(
              '${widget.season.number}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            child: Card(
              elevation: 5,
              child: widget.season.image.isNotEmpty
                  ? Image.network(widget.season.image)
                  : Container(
                      child: Text(
                        "someText",
                        style: textStyle,
                      ),
                      color: Colors.white,
                    ),
            ),
          ),
          cursor: SystemMouseCursors.click,
        ),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _seasonDialog(BuildContext context, dynamic season) {
    return AlertDialog(
      title: Text('Ajouter la saison ${season.number}'),
      content: SizedBox(
        height: 300,
        width: 300,
        child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.utc(2000),
            lastDate: DateTime.now(),
            onDateChanged: (dateTime) {
              setState(() => _started = dateTime);
            }),
      ),
      actions: [
        TextButton(
          onPressed: _addSeason,
          child: Text(
            'Valider',
            style: textStyle,
          ),
        ),
      ],
    );
  }

  void _addSeason() async {}
}
