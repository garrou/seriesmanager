import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';

class AppSeriesCard extends StatelessWidget {
  final dynamic series;
  final VoidCallback onTap;
  const AppSeriesCard({Key? key, required this.series, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: series.poster.isNotEmpty
              ? Image.network(
                  series.poster,
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(series.title, style: textStyle)],
                ),
        ),
      ),
    );
  }
}
