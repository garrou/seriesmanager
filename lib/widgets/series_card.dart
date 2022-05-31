import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';

class AppSeriesCard extends StatelessWidget {
  final dynamic series;
  const AppSeriesCard({Key? key, required this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: series details
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: series.images['poster'] != null
            ? Image.network(
                series.images['poster'],
                semanticLabel: 'Image de la série',
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress == null
                      ? child
                      : LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                          value: loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!,
                        );
                },
                height: MediaQuery.of(context).size.height / 3,
              )
            : Text(
                series.title,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
