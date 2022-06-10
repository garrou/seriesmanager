import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:seriesmanager/models/season.dart';
import 'package:seriesmanager/models/series.dart';
import 'package:seriesmanager/styles/text.dart';

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
  Widget build(BuildContext context) => Padding(
        child: Badge(
          position: BadgePosition.topEnd(end: 15),
          badgeColor: Colors.black,
          padding: const EdgeInsets.all(5),
          badgeContent: Text(
            '${season.number}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: InkWell(
              onTap: onTap,
              child: season.image.isNotEmpty
                  ? Image.network(
                      season.image,
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                  value: loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!,
                                ),
                              );
                      },
                    )
                  : Center(
                      child: Text(
                        'Episodes : ${season.episodes}',
                        style: textStyle,
                      ),
                    ),
            ),
          ),
        ),
        padding: const EdgeInsets.all(10),
      );
}
