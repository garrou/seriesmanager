import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:seriesmanager/models/season.dart';
import 'package:seriesmanager/models/series.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/widgets/network_image.dart';

class AppSeasonCard extends StatelessWidget {
  final Series series;
  final Season season;
  final VoidCallback onTap;
  const AppSeasonCard(
      {Key? key,
      required this.series,
      required this.season,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Badge(
        position: BadgePosition.topEnd(end: 25),
        badgeColor: Colors.black,
        padding: const EdgeInsets.all(5),
        badgeContent: Text(
          '${season.number}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        child: Card(
          elevation: 10,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: season.image.isNotEmpty
                  ? AppNetworkImage(image: season.image)
                  : Center(
                      child: Text(
                        'Episodes : ${season.episodes}',
                        style: textStyle,
                      ),
                    ),
            ),
          ),
        ),
      );
}
